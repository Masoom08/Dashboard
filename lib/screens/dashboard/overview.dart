import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OverviewGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              Text("Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Align(
                alignment: Alignment.centerRight,
                child: Text("Full Screen", style: TextStyle(fontSize: 12, color: Colors.blue)),
              ),
              SizedBox(height: 16),
              SizedBox(
                height: 200,
                width: 600, // Adjust the width to make the graph narrower
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
                              '${value ~/ 1000}K',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            int year = 2025 + value.toInt();
                            return Text(
                              year.toString(),
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            );
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 500),
                          FlSpot(1, 1000),
                          FlSpot(2, 1800),
                          FlSpot(3, 1600),
                          FlSpot(4, 2500),
                          FlSpot(5, 2300),
                          FlSpot(6, 3000),
                          FlSpot(7, 3500),
                          FlSpot(8, 4000),
                        ],
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
  }
}
