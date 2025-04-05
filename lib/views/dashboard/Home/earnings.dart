import 'package:flutter/material.dart';
import '../../../theme/colors.dart';
import 'Calender/MonthPickerDialog.dart';
import 'Calender/YearPickerDialog.dart';

class EarningsCard extends StatefulWidget {
  @override
  _EarningsCardState createState() => _EarningsCardState();
}

class _EarningsCardState extends State<EarningsCard> {
  int? selectedYear;
  int? selectedMonth;

  void _pickDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();

    if (selectedYear != null && selectedMonth != null) {
      initialDate = DateTime(selectedYear!, selectedMonth!);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      print("Selected Date: $picked");
      // Handle the selected date here if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double cardPadding = constraints.maxWidth < 600 ? 12 : 16;
            double fontSize = constraints.maxWidth < 600 ? 24 : 32;

            return Card(
              elevation: 4,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
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
                            Text("Custom",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black54)),
                            SizedBox(width: 4),
                            Icon(Icons.toggle_on,
                                size: 20, color: Colors.black54),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFilterChip(context, "Today", isSelected: true),
                        _buildFilterChip(context, "This Week"),
                        _buildFilterChip(context, "This Month"),
                        _buildFilterChip(context, "Half Yearly"),
                        _buildFilterChip(context, "This Year"),
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

  Widget _buildFilterChip(BuildContext context, String label,
      {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        if (label == "This Month") {
          showDialog(
            context: context,
            builder: (_) => Align(
              alignment: Alignment(0, -0.2),
              child: MonthPickerDialog(
                onMonthSelected: (String selectedMonthName) {
                  final monthMap = {
                    'January': 1,
                    'February': 2,
                    'March': 3,
                    'April': 4,
                    'May': 5,
                    'June': 6,
                    'July': 7,
                    'August': 8,
                    'September': 9,
                    'October': 10,
                    'November': 11,
                    'December': 12,
                  };

                  final selectedMonthNumber = monthMap[selectedMonthName];

                  if (selectedMonthNumber != null) {
                    // Assuming you're using stateful widget and have a setState
                    setState(() {
                      selectedMonth = selectedMonthNumber;
                      selectedYear ??= DateTime.now().year; // Optional fallback
                    });
                  }
                },
              ),
            ),
          );
        } else if (label == "This Year") {
          showDialog(
            context: context,
            builder: (_) => Align(
              alignment: Alignment(0, -0.2),
              child: YearPickerDialog(
                onYearSelected: (year) {
                  setState(() {
                    selectedYear = year;
                  });
                  print("Selected Year: $year");
                },
              ),
            ),
          );
        } else if (label == "Today") {
          _pickDate(context); // Open calendar using selected year & month
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8),
        child: Chip(
          label: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
          backgroundColor:
          isSelected ? AppColors.primaryBlue : Colors.grey[200],
        ),
      ),
    );
  }
}
