import 'dart:io' show File;
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // kIsWeb

import '../models/AdminProfile.dart';

class AdminProfileRepository {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  /// Upload image from File (mobile)
  Future<String> uploadProfileImage(String uid, File imageFile) async {
    try {
      final ref = _storage.ref().child("admin_profile_pics/$uid.jpg");
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload profile image (mobile): $e");
    }
  }

  /// Upload image from Uint8List (web)
  Future<String> uploadProfileImageWeb({
    required String uid,
    required Uint8List imageBytes,
    String? imageName,
  }) async {
    try {
      final safeImageName = imageName ?? "profile.jpg";
      final ref = _storage.ref().child("admin_profile_pics/$uid/$safeImageName");
      final metadata = SettableMetadata(contentType: 'image/jpeg');
      await ref.putData(imageBytes, metadata);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception("Failed to upload profile image (web): $e");
    }
  }

  /// Platform-aware upload (Web/Mobile)
  Future<String> uploadProfileImageBasedOnPlatform({
    required String uid,
    required dynamic image,
    String? imageName,
  }) async {
    try {
      if (kIsWeb) {
        if (image is Uint8List) {
          return await uploadProfileImageWeb(uid: uid, imageBytes: image, imageName: imageName);
        } else {
          throw Exception("Invalid image format for web. Expected Uint8List.");
        }
      } else {
        if (image is File) {
          return await uploadProfileImage(uid, image);
        } else {
          throw Exception("Invalid image format for mobile. Expected File.");
        }
      }
    } catch (e) {
      debugPrint("Upload error: $e");
      rethrow;
    }
  }

  /// Save or update admin profile
  Future<void> saveAdminProfile(AdminProfile profile) async {
    try {
      final profileData = profile.toMap();
      final docRef = _firestore.collection("admins").doc(profile.uid);
      final docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update(profileData);
        debugPrint("Admin profile updated.");
      } else {
        await docRef.set(profileData);
        debugPrint("Admin profile created.");
      }
    } catch (e) {
      debugPrint("Firestore error: $e");
      throw Exception("Failed to save admin profile: $e");
    }
  }
}
