import '../models/call.dart';
import '../services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CallRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference callsCollection =
  FirebaseFirestore.instance.collection('calls');

  // Start a new call
  Future<void> startCall(CallModel call) async {
    try {
      await callsCollection.doc(call.channelId).set(call.toMap());
    } catch (e) {
      throw Exception("Failed to start call: $e");
    }
  }

  // Update call status (e.g., when call ends)
  Future<void> updateCallStatus(String channelId, Map<String, dynamic> updates) async {
    try {
      await callsCollection.doc(channelId).update(updates);
    } catch (e) {
      throw Exception("Failed to update call status: $e");
    }
  }

  // Get call details by Channel ID
  Future<CallModel?> getCall(String channelId) async {
    try {
      DocumentSnapshot doc = await callsCollection.doc(channelId).get();
      if (doc.exists) {
        return CallModel.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw Exception("Failed to get call: $e");
    }
  }
}
