import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime/mime.dart';
import 'dart:async';

import '../models/AdminProfile.dart';

class AdminProfileViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Uint8List? imageBytes;
  String imageUrl = "";

  AdminProfile? _adminProfile;
  AdminProfile? get adminProfile => _adminProfile;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> pickImageWeb() async {
    final pickedImage = await ImagePickerWeb.getImageAsBytes();
    if (pickedImage != null) {
      imageBytes = pickedImage;
      notifyListeners();
    }
  }

  Future<String> uploadImageWeb(String uid) async {
    if (imageBytes == null) throw Exception("No image data to upload.");

    try {
      final mimeType = lookupMimeType('image', headerBytes: imageBytes!) ?? 'image/jpeg';
      final fileExtension = mimeType.split('/').last;
      final ref = _storage.ref().child("admin_profile_pics/$uid.$fileExtension");
      final metadata = SettableMetadata(contentType: mimeType);

      final uploadTaskSnapshot = await ref
          .putData(imageBytes!, metadata)
          .timeout(const Duration(seconds: 15));

      return await uploadTaskSnapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw Exception("Firebase upload failed: ${e.message}");
    } on TimeoutException catch (_) {
      throw Exception("Upload timed out. Try again with a smaller image or better network.");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveAdminProfile({
    required String name,
    required String phone,
    required String role,
  }) async {
    _setLoading(true);
    try {
      final user = _auth.currentUser!;
      final uid = user.uid;

      if (imageBytes != null) {
        imageUrl = await uploadImageWeb(uid);
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
    } catch (e) {
      rethrow;
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
    }
  }
}
