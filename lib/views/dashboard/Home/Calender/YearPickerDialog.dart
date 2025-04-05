import 'package:flutter/material.dart';

class YearPickerDialog extends StatelessWidget {
  final List<int> years = List.generate(12, (index) => 1999 + index);
  final Function(int) onYearSelected;

  YearPickerDialog({required this.onYearSelected});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFF4F8FB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: 778,
        height: 464,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Center(
                    child: Text(
                      "Years",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close, size: 24),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: years.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.5,
                  ),
                  itemBuilder: (context, index) {
                    final year = years[index];
                    return GestureDetector(
                      onTap: () {
                        onYearSelected(year);
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          '$year',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
