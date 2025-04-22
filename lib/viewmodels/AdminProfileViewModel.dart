import 'dart:typed_data';
import 'dart:async';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime/mime.dart';

import '../models/AdminProfile.dart';

class AdminProfileViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Uint8List? imageBytes;
  String imageUrl = "";

  String name = '';
  String email = '';
  String phone = '';
  String role = '';

  AdminProfile? _adminProfile;
  AdminProfile? get adminProfile => _adminProfile;

  void _setLoading(bool value) {
    debugPrint("_setLoading called with value: $value");
    _isLoading = value;
    notifyListeners();
  }

  void initialize() {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      fetchAdminProfile(uid);
    }
  }

  Future<void> fetchAdminProfile(String uid) async {
    _setLoading(true);
    try {
      var doc = await _firestore.collection("admins").doc(uid).get();
      if (doc.exists) {
        var data = doc.data()!;
        name = data['name'] ?? '';
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';
        role = data['role'] ?? '';
        imageUrl = data['profilePicUrl'] ?? '';
        notifyListeners();
      } else {
        throw Exception('Admin not found');
      }
    } catch (e) {
      debugPrint("Error fetching admin profile: $e");
      throw e;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadAdminProfile() async {
    _setLoading(true);
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      final doc = await _firestore.collection("admins").doc(user.uid).get();
      if (!doc.exists) throw Exception("Admin profile not found");

      _adminProfile = AdminProfile.fromMap(doc.id, doc.data()!);
      imageUrl = _adminProfile?.profilePicUrl ?? '';
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
      debugPrint("loadAdminProfile complete.");
    }
  }

  Future<void> pickImageWeb() async {
    debugPrint("Attempting to pick image from web...");
    final pickedImage = await ImagePickerWeb.getImageAsBytes();
    if (pickedImage != null) {
      debugPrint("Image successfully picked.");
      imageBytes = pickedImage;
      notifyListeners();
    } else {
      debugPrint("No image was picked.");
    }
  }

  Future<String> uploadImageWeb(String uid) async {
    if (imageBytes == null) {
      debugPrint("uploadImageWeb called but imageBytes is null.");
      throw Exception("No image data to upload.");
    }

    try {
      final mimeType = lookupMimeType('image', headerBytes: imageBytes!) ?? 'image/jpeg';
      final fileExtension = mimeType.split('/').last;

      final ref = _storage.ref().child("admin_profile_pics/$uid.$fileExtension");
      final metadata = SettableMetadata(contentType: mimeType);

      final uploadTaskSnapshot = await ref
          .putData(imageBytes!, metadata)
          .timeout(const Duration(seconds: 120));

      final downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } on FirebaseException catch (e) {
      debugPrint("Firebase upload failed: ${e.message}");
      throw Exception("Firebase upload failed: ${e.message}");
    } on TimeoutException {
      debugPrint("Upload timed out.");
      throw Exception("Upload timed out. Please try again.");
    } catch (e) {
      debugPrint("Unexpected error during image upload: $e");
      rethrow;
    }
  }

  Future<void> saveAdminProfile({
    required String name,
    required String phone,
    required String role,
  }) async {
    debugPrint("Starting saveAdminProfile...");
    _setLoading(true);

    try {
      final user = _auth.currentUser!;
      final uid = user.uid;

      if (imageBytes != null) {
        debugPrint("Image selected. Proceeding to upload...");
        imageUrl = await uploadImageWeb(uid);
      } else {
        debugPrint("No image selected. Skipping image upload.");
      }

      final profile = AdminProfile(
        uid: uid,
        email: user.email!,
        name: name,
        phone: phone,
        role: role,
        profilePicUrl: imageUrl,
      );

      await _firestore.collection("admins").doc(uid).set(profile.toMap());
      _adminProfile = profile;
      notifyListeners();
    } catch (e, stack) {
      debugPrint('Error saving admin profile: $e');
      debugPrint(stack.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}
