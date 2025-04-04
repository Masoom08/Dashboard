import 'package:cloud_firestore/cloud_firestore.dart';

class CallModel {
  String callType; // "voice" or "video"
  String callerId;
  String callerName;
  String channelId; // Agora Channel ID
  String doctorName;
  int duration; // Duration in seconds
  DateTime startedAt;
  DateTime? endedAt;
  String receiverId;
  String status; // "ongoing", "completed", "missed"

  CallModel({
    required this.callType,
    required this.callerId,
    required this.callerName,
    required this.channelId,
    required this.doctorName,
    required this.duration,
    required this.startedAt,
    this.endedAt,
    required this.receiverId,
    required this.status,
  });

  // Convert Firestore document to CallModel
  factory CallModel.fromMap(Map<String, dynamic> data) {
    return CallModel(
      callType: data['call_type'] ?? '',
      callerId: data['caller_id'] ?? '',
      callerName: data['caller_name'] ?? '',
      channelId: data['channel_id'] ?? '',
      doctorName: data['doctor_name'] ?? '',
      duration: data['duration'] ?? 0,
      startedAt: (data['started_at'] as Timestamp).toDate(),
      endedAt: data['ended_at'] != null ? (data['ended_at'] as Timestamp).toDate() : null,
      receiverId: data['receiver_id'] ?? '',
      status: data['status'] ?? '',
    );
  }

  // Convert CallModel to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'call_type': callType,
      'caller_id': callerId,
      'caller_name': callerName,
      'channel_id': channelId,
      'doctor_name': doctorName,
      'duration': duration,
      'started_at': Timestamp.fromDate(startedAt),
      'ended_at': endedAt != null ? Timestamp.fromDate(endedAt!) : null,
      'receiver_id': receiverId,
      'status': status,
    };
  }
}
