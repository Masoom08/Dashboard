import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:mime/mime.dart';
import 'dart:async';
import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart';


import '../models/AdminProfile.dart';



class AdminProfileViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;



  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Uint8List? imageBytes;
  String imageUrl = "";



  void _setLoading(bool value) {
    debugPrint("_setLoading called with value: $value");
    _isLoading = value;
    notifyListeners();
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
      debugPrint("Determining MIME type from image bytes...");
      final mimeType = lookupMimeType('image', headerBytes: imageBytes!) ?? 'image/jpeg';
      debugPrint("Detected MIME type: $mimeType");

      final fileExtension = mimeType.split('/').last;
      debugPrint("Using file extension: $fileExtension");
      debugPrint("Storgae instance: $_storage");
      final ref = _storage.ref().child("admin_profile_pics/$uid.$fileExtension");
      debugPrint("Storage reference created at: admin_profile_pics/$uid.$fileExtension");
      debugPrint("ref : $ref");

      final metadata = SettableMetadata(contentType: mimeType);
      debugPrint("Uploading image with byte length: ${imageBytes!.length}");
      debugPrint("First 20 bytes of image being uploaded: ${imageBytes!.take(20).toList()}");
      try {
        final uploadTaskSnapshot = await ref
            .putData(imageBytes!, metadata)
            .timeout(const Duration(seconds: 15)); // ⏱ Timeout added here

        debugPrint("Upload complete. Fetching download URL...");
        final downloadUrl = await uploadTaskSnapshot.ref.getDownloadURL();
        debugPrint("Download URL retrieved: $downloadUrl");

        return downloadUrl;
      } on FirebaseException catch (e) {
        debugPrint("Firebase upload failed. Code: ${e.code}, Message: ${e.message}");
        throw Exception("Firebase upload failed: ${e.message}");
      } on TimeoutException catch (_) {
        debugPrint("Upload timed out after 15 seconds.");
        throw Exception("Upload timed out. Please try again with a smaller image or better network.");
      }
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
      debugPrint("Current user UID: $uid, Email: ${user.email}");

      if (imageBytes != null) {
        debugPrint("Image selected. Proceeding to upload...");
       imageUrl = await uploadImageWeb(uid);


        //imageUrl= await uploadImageToFirebase();
        debugPrint("$imageUrl");
        //The argument type 'List<int>' can't be assigned to the parameter type 'Uint8List'.
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

      debugPrint("AdminProfile created: ${profile.toMap()}");
      debugPrint("Saving profile to Firestore...");
      await _firestore.collection("admins").doc(uid).set(profile.toMap());
      debugPrint("Profile successfully saved to Firestore.");
    } catch (e, stack) {
      debugPrint('Error saving admin profile: $e');
      debugPrint(stack.toString());
      rethrow;
    } finally {
      _setLoading(false);
      debugPrint("saveAdminProfile complete.");
    }
  }
}
