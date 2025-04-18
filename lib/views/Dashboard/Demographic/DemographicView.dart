import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/colors.dart';
import '../../../viewmodels/demographic_viewmodel.dart';
import '../../../viewmodels/user_viewmodel.dart';

class UserDemographicsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Trigger fetching demographics on widget build
    Future.delayed(Duration.zero, () {
      Provider.of<DemographicsViewModel>(context, listen: false)
          .fetchDemographics();
    });

    return Consumer<DemographicsViewModel>(
      builder: (context, viewModel, child) {
        final demographics = viewModel.demographics;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: const Text(
                  "Users Demographics",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: viewModel.isLoading
                    ? const CircularProgressIndicator()
                    : demographics.isEmpty
                    ? const Text("No data available.")
                    : Column(
                  children: demographics.map((demo) {
                    final total = demographics.fold<int>(
                        0, (sum, e) => sum + e.count);
                    final percentage = total == 0
                        ? 0.0
                        : demo.count / total;

                    return _buildBarRow(context, demo.place, percentage);
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBarRow(BuildContext context, String place, double percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(place, overflow: TextOverflow.ellipsis,)),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Container(
                  height: 10,
                  width: MediaQuery.of(context).size.width * 0.5 * percentage,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
          Text('${(percentage * 100).toStringAsFixed(1)}%'),
        ],
      ),
    );
  }
}
