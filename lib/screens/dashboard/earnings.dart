import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class EarningsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardPadding = constraints.maxWidth < 600 ? 12 : 16;
        double fontSize = constraints.maxWidth < 600 ? 24 : 32;
        return Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Earnings",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text("Custom", style: TextStyle(fontSize: 14, color: Colors.black54)),
                      SizedBox(width: 4),
                      Icon(Icons.toggle_on, size: 20, color: Colors.black54),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  _buildFilterChip("Today", isSelected: true),
                  _buildFilterChip("This Week"),
                  _buildFilterChip("This Month"),
                  _buildFilterChip("Half Yearly"),
                  _buildFilterChip("This Year"),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    "₹",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    "100,000",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black54,
          ),
        ),
        backgroundColor: isSelected ? AppColors.primaryBlue : Colors.grey[200],
      ),
    );
  }
}
