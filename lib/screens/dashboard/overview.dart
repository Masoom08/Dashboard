import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class OverviewGraph extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Overview", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(height: 200, child: LineChart(LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 12, color: AppColors.grey),
                      );
                    },
                    reservedSize: 20,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(1, 100),
                    FlSpot(2, 300),
                    FlSpot(3, 500),
                    FlSpot(4, 700),
                    FlSpot(5, 900),
                    FlSpot(6, 1200),
                  ],
                  isCurved: true,
                  color: AppColors.green,
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: true, color: AppColors.green.withOpacity(0.3)),
                ),
              ],
            ),
            ),
            ),
          ],
        ),
      ),
    );
  }
}