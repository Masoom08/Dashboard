import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/stats_viewmodel.dart';

class OverviewGraph extends StatefulWidget {
  @override
  _OverviewGraphState createState() => _OverviewGraphState();
}

class _OverviewGraphState extends State<OverviewGraph> {
  String filterType = 'Month';

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<StatsViewModel>(context, listen: false);
    viewModel.fetchUsersJoinedMonthlyStats();
  }

  double _getDynamicYInterval(List<FlSpot> spots) {
    if (spots.isEmpty) return 1;

    final maxY = spots.map((e) => e.y).reduce(max);

    if (maxY <= 5) return 1;
    if (maxY <= 20) return 2;
    if (maxY <= 50) return 10;
    if (maxY <= 100) return 20;
    if (maxY <= 500) return 50;
    if (maxY <= 1000) return 100;
    if (maxY <= 2000) return 200;
    return 500;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsViewModel>(
      builder: (context, viewModel, child) {
        final userStats = viewModel.usersJoinedCount;

        if (viewModel.isLoading) {
          return Center(child: CircularProgressIndicator());
        }

        // 👉 Handle empty state
        if (userStats.isEmpty) {
          return Container(
            constraints: BoxConstraints(maxWidth: 650),
            child: Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Dropdown
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Overview",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        DropdownButton<String>(
                          value: filterType,
                          items: ['Month'].map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          )).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              filterType = newValue!;
                            });
                          },
                          underline: Container(),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "No user registration data available yet.",
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // 📅 Data exists: process and display graph
        DateTime getFirstDateFromMapKeys(Map<String, int> map) {
          final keys = map.keys.map((e) {
            final parts = e.split('-');
            return DateTime(int.parse(parts[1]), int.parse(parts[0]));
          }).toList();
          keys.sort();
          return keys.first;
        }

        List<String> generateMonthLabels(DateTime start, DateTime end) {
          final List<String> result = [];
          DateTime current = DateTime(start.year, start.month);
          while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
            final label = '${current.month.toString().padLeft(2, '0')}-${current.year}';
            result.add(label);
            current = DateTime(current.year, current.month + 1);
          }
          return result;
        }

        final DateTime now = DateTime.now();
        final DateTime startDate = getFirstDateFromMapKeys(userStats);
        final labels = generateMonthLabels(startDate, DateTime(now.year, now.month));
        final displayData = {
          for (var label in labels) label: userStats[label] ?? 0,
        };

        final spots = [
          for (int i = 0; i < labels.length; i++)
            FlSpot(i.toDouble(), max(0, displayData[labels[i]]!.toDouble())),
        ];

        final yInterval = _getDynamicYInterval(spots);

        return Container(
          constraints: BoxConstraints(maxWidth: 650),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Users Registered Overview",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      DropdownButton<String>(
                        value: filterType,
                        items: ['Month'].map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        )).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            filterType = newValue!;
                          });
                        },
                        underline: Container(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    width: 600,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              interval: yInterval,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  value.toInt().toString(),
                                  style: TextStyle(fontSize: 12),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, _) {
                                int index = value.toInt();
                                if (index >= 0 && index < labels.length) {
                                  final parts = labels[index].split('-');
                                  return Text('${parts[0]}/${parts[1]}',
                                      style: TextStyle(fontSize: 10));
                                }
                                return SizedBox.shrink();
                              },
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: false,
                            color: Colors.green,
                            barWidth: 2,
                            isStrokeCapRound: true,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF45DE5D).withOpacity(0.4),
                                  Color(0xFFA9EFB4).withOpacity(0.3),
                                  Color(0xFFD3F6D9).withOpacity(0.2),
                                  Color(0xFFFBFDFB).withOpacity(0.1),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [0.0, 0.33, 0.66, 1.0],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}