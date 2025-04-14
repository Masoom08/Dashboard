import 'package:flutter/material.dart';
import 'package:dashboard/viewmodels/wallet_view_model.dart';
import 'package:provider/provider.dart';
import '../../../../../theme/colors.dart';
import 'Calender/MonthPickerDialog.dart';
import 'Calender/YearPickerDialog.dart';

class EarningsCard extends StatefulWidget {
  const EarningsCard({super.key});

  @override
  State<EarningsCard> createState() => _EarningsCardState();
}

class _EarningsCardState extends State<EarningsCard> {
  int? selectedYear;
  int? selectedMonth;
  String selectedFilter = "Today";

  void _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      context.read<EarningsViewModel>().fetchEarningsForDate(picked); // Using context.read
      setState(() {
        selectedFilter = "Today";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<EarningsViewModel>().fetchEarningsForToday(); // Default earnings fetch
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EarningsViewModel>(); // Using context.watch for listening

    return Center(
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
                  _buildHeader(),
                  const SizedBox(height: 12),
                  _buildFilters(),
                  const SizedBox(height: 16),
                  state.isLoading
                      ? const CircularProgressIndicator()
                      : Row(
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
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${state.earnings.toStringAsFixed(2)}",
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
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
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
    );
  }

  Widget _buildFilters() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildFilterChip("Today", () {
          _pickDate(context);
        }),
        _buildFilterChip("This Week", () {
          context.read<EarningsViewModel>().fetchEarningsForThisWeek();
          setState(() {
            selectedFilter = "This Week";
          });
        }),
        _buildFilterChip("This Month", () {
          showDialog(
            context: context,
            builder: (_) => Align(
              alignment: const Alignment(0, -0.2),
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
                    setState(() {
                      selectedMonth = selectedMonthNumber;
                      selectedYear ??= DateTime.now().year;
                      selectedFilter = "This Month";
                    });
                    context.read<EarningsViewModel>().fetchEarningsForMonth(selectedMonth!, selectedYear!);
                  }
                },
              ),
            ),
          );
        }),
        _buildFilterChip("This Year", () {
          showDialog(
            context: context,
            builder: (_) => Align(
              alignment: const Alignment(0, -0.2),
              child: YearPickerDialog(
                onYearSelected: (year) {
                  setState(() {
                    selectedYear = year;
                    selectedFilter = "This Year";
                  });
                  context.read<EarningsViewModel>().fetchEarningsForYear(year);
                },
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onTap) {
    final bool isSelected = label == selectedFilter;

    return GestureDetector(
      onTap: onTap,
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
          backgroundColor: isSelected ? AppColors.primaryBlue : Colors.grey[200],
        ),
      ),
    );
  }
}
