import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentPage > 1 ? onPrevious : null,
            icon: Icon(Icons.arrow_back),
          ),
          Text("Page $currentPage of $totalPages"),
          IconButton(
            onPressed: currentPage < totalPages ? onNext : null,
            icon: Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }
}
