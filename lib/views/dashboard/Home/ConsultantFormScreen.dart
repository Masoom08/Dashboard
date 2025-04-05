import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConsultantFormScreen extends StatelessWidget {
  final Map<String, String> data;

  ConsultantFormScreen({required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Consultant Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${data["name"]}", style: TextStyle(fontSize: 18)),
            Text("Specialization: ${data["specialization"]}", style: TextStyle(fontSize: 16)),
            // Add form fields or other logic here
          ],
        ),
      ),
    );
  }
}
