class FeedbackModel {
  final String message;
  final String relatedDocId;
  final DateTime timestamp;
  final String userId;

  FeedbackModel({
    required this.message,
    required this.relatedDocId,
    required this.timestamp,
    required this.userId,
  });

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      message: map['message'] ?? '',
      relatedDocId: map['relatedDocId'] ?? '',
      timestamp: map['timestamp']?.toDate() ?? DateTime.now(),
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'relatedDocId': relatedDocId,
      'timestamp': timestamp,
      'userId': userId,
    };
  }
}
