/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/AdminProfileViewModel.dart';

class AdminProfileDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AdminProfileViewModel>(context);

    return PopupMenuButton<int>(
      offset: Offset(0, 50), // Controls dropdown position below icon
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      icon: viewModel.imageUrl.isNotEmpty
          ? CircleAvatar(
        backgroundImage: NetworkImage(viewModel.imageUrl),
      )
          : Icon(Icons.account_circle, size: 30),
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              viewModel.imageUrl.isNotEmpty
                  ? CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(viewModel.imageUrl),
              )
                  : Icon(Icons.account_circle, size: 60),
              SizedBox(height: 12),
              Text('Name: ${viewModel.name}', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Email: ${viewModel.email}'),
              Text('Phone: ${viewModel.phone}'),
              Text('Role: ${viewModel.role}'),
            ],
          ),
        ),
      ],
    );
  }
}

 */