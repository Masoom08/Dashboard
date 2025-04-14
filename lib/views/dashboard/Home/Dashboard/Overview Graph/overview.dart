import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../viewmodels/earning_view_model.dart';

class OverviewGraph extends StatefulWidget {
  @override
  _OverviewGraphState createState() => _OverviewGraphState();
}

class _OverviewGraphState extends State<OverviewGraph> {
  String filterType = 'Month'; // Default filter type

  @override
  Widget build(BuildContext context) {
    return Consumer<EarningsViewModel>(
      builder: (context, viewModel, child) {
        final allEarnings = viewModel.monthlyEarnings;

        // Prepare display data based on filter
        List<String> filteredKeys = allEarnings.keys.toList();
        Map<String, double> displayData = {};

        if (filterType == 'Year') {
          allEarnings.forEach((key, value) {
            final parts = key.split('-');
            final year = parts.last;
            displayData[year] = (displayData[year] ?? 0.0) + value;
          });
        } else if (filterType == 'Date') {
          displayData = Map.fromEntries(allEarnings.entries.toList()
            ..sort((a, b) {
              final aParts = a.key.split('-');
              final bParts = b.key.split('-');
              final dateA = DateTime(int.parse(aParts[2]), int.parse(aParts[1]), int.parse(aParts[0]));
              final dateB = DateTime(int.parse(bParts[2]), int.parse(bParts[1]), int.parse(bParts[0]));
              return dateA.compareTo(dateB);
            }));
        } else {
          // Month
          displayData = Map.fromEntries(allEarnings.entries.toList()
            ..sort((a, b) {
              final aParts = a.key.split('-');
              final bParts = b.key.split('-');
              final dateA = DateTime(int.parse(aParts[1]), int.parse(aParts[0]));
              final dateB = DateTime(int.parse(bParts[1]), int.parse(bParts[0]));
              return dateA.compareTo(dateB);
            }));
        }

        final labels = displayData.keys.toList();
        final spots = [
          for (int i = 0; i < labels.length; i++)
            FlSpot(i.toDouble(), displayData[labels[i]] ?? 0.0)
        ];

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
                  // Title & Filter
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Overview",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: filterType,
                        items: ['Date', 'Month', 'Year']
                            .map((e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ))
                            .toList(),
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
                  // Graph
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
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  '${(value / 1000).toStringAsFixed(0)}K',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black),
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
                                  final label = labels[index];

                                  // If the filter type is 'Date', show dates like 7, 14, 21, etc.
                                  if (filterType == 'Date') {
                                    final dateParts = label.split('-');
                                    final date = int.parse(dateParts[0]); // Assuming label format is 'DD-MM-YYYY'

                                    // Show only specific dates (7, 14, 21, 28, 31)
                                    if (date == 7 || date == 14 || date == 21 || date == 28 || date == 31) {
                                      return Text(label, style: TextStyle(fontSize: 10));
                                    } else {
                                      return SizedBox.shrink();  // Hide labels that don't match the criteria
                                    }
                                  }

                                  // If the filter type is 'Month' or 'Year', show the usual format
                                  else if (filterType == 'Month') {
                                    final parts = label.split('-');
                                    return Text('${parts[0]}/${parts[1]}', style: TextStyle(fontSize: 10));
                                  } else {
                                    return Text(label, style: TextStyle(fontSize: 10));
                                  }
                                }

                                return SizedBox.shrink();
                              },
                            ),
                          ),
                          topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: spots,
                            isCurved: false,
                            color: Colors.transparent,
                            barWidth: 0,
                            isStrokeCapRound: false,
                            dotData: FlDotData(show: false),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFF45DE5D),
                                  Color(0xFFA9EFB4),
                                  Color(0xFFD3F6D9),
                                  Color(0xFFFBFDFB),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
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
