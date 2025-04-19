import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/AdminProfileViewModel.dart';

class CompleteAdminProfileScreen extends StatefulWidget {
  @override
  State<CompleteAdminProfileScreen> createState() => _CompleteAdminProfileScreenState();
}

class _CompleteAdminProfileScreenState extends State<CompleteAdminProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final roleController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Consumer<AdminProfileViewModel>(
        builder: (context, vm, _) {
          final imageProvider = vm.imageBytes != null ? MemoryImage(vm.imageBytes!) : null;
          final userEmail = FirebaseAuth.instance.currentUser?.email ?? "No email found";

          return Scaffold(
            appBar: AppBar(title: Text("Complete Admin Profile")),
            body: AbsorbPointer(
              absorbing: vm.isLoading,
              child: Stack(
                children: [
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await vm.pickImageWeb();
                                if (vm.imageBytes == null && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("No image selected")),
                                  );
                                }
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: imageProvider,
                                child: imageProvider == null
                                    ? Icon(Icons.camera_alt, size: 40)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              initialValue: userEmail,
                              readOnly: true,
                              decoration: InputDecoration(
                                labelText: "Admin Email",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: "Admin Name",
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.isEmpty ? "Enter name" : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: "Phone Number",
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.isEmpty ? "Enter phone" : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: roleController,
                              decoration: InputDecoration(
                                labelText: "Role (e.g. Super Admin)",
                                border: OutlineInputBorder(),
                              ),
                              validator: (val) => val == null || val.isEmpty ? "Enter role" : null,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              icon: Icon(Icons.save),
                              label: Text("Save Admin Profile"),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    await vm.saveAdminProfile(
                                      name: nameController.text.trim(),
                                      phone: phoneController.text.trim(),
                                      role: roleController.text.trim(),
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Profile Saved Successfully")),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Failed to save profile")),
                                      );
                                    }
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (vm.isLoading)
                    Center(
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                        child: Center(child: CircularProgressIndicator()),
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
