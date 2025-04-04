import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class EarningsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center( // Center the card on screen
      child: SizedBox(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double cardPadding = constraints.maxWidth < 600 ? 12 : 16;
            double fontSize = constraints.maxWidth < 600 ? 24 : 32;
            return Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all/*fromLTRB*/(cardPadding /*, cardPadding, cardPadding, cardPadding + 64*/ ),
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
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "₹",
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            "100,000",
                            style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
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
