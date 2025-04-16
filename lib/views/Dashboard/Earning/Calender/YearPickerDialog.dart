import 'package:flutter/material.dart';

class YearPickerDialog extends StatelessWidget {
  final int startYear = 2021;
  final int endYear = 2030;
  final Function(int) onYearSelected;

  YearPickerDialog({required this.onYearSelected});

  @override
  Widget build(BuildContext context) {
    final List<int> years = List.generate(endYear - startYear + 1, (index) => startYear + index);

    return Dialog(
      backgroundColor: const Color(0xFFF4F8FB),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Use max height to control scroll behavior if content exceeds
          double maxHeight = MediaQuery.of(context).size.height * 0.6;

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 600,
              maxHeight: maxHeight,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Text(
                          "Select Year",
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
                  const SizedBox(height: 20),
                  Flexible(
                    child: Scrollbar(
                      thickness: 4,
                      radius: Radius.circular(10),
                      child: GridView.builder(
                        shrinkWrap: true,
                        itemCount: years.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '$year',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
