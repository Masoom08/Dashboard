import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String bookingId;
  final String userId;
  final String userName;
  final String userPhone;
  final String userPic;
  final String doctorId;
  final String doctorName;
  final String doctorPhone;
  final String doctorPic;
  final String serviceId;
  final String appointmentStatus;
  final String paymentMethod;
  final String paymentStatus;
  final String selectedDate;
  final String selectedTime;
  final String selectedShift;
  final double consultationFees;
  final double platformFee;
  final double totalFee;
  final bool isCancelled;
  final bool isDeleted;
  final bool isVerified;
  final int otp;
  final DateTime createdAt;

  Booking({
    required this.bookingId,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.userPic,
    required this.doctorId,
    required this.doctorName,
    required this.doctorPhone,
    required this.doctorPic,
    required this.serviceId,
    required this.appointmentStatus,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedShift,
    required this.consultationFees,
    required this.platformFee,
    required this.totalFee,
    required this.isCancelled,
    required this.isDeleted,
    required this.isVerified,
    required this.otp,
    required this.createdAt,
  });

  factory Booking.fromMap(Map<String, dynamic> data, String id) {
    return Booking(
      bookingId: id,
      userId: data['user_id'],
      userName: data['user_name'],
      userPhone: data['user_phone'],
      userPic: data['user_pic'],
      doctorId: data['doctor_id'],
      doctorName: data['doctor_name'],
      doctorPhone: data['doctor_phone'],
      doctorPic: data['doctor_pic'],
      serviceId: data['service_id'],
      appointmentStatus: data['appointment_status'],
      paymentMethod: data['payment_method'],
      paymentStatus: data['payment_status'],
      selectedDate: data['selected_date'],
      selectedTime: data['selected_time'],
      selectedShift: data['selected_shift'],
      consultationFees: data['consultation_fees'].toDouble(),
      platformFee: data['platform_fee'].toDouble(),
      totalFee: data['total_fee'].toDouble(),
      isCancelled: data['is_cancelled'],
      isDeleted: data['is_deleted'],
      isVerified: data['isVerified'],
      otp: data['otp'],
      createdAt: (data['created_at'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'user_name': userName,
      'user_phone': userPhone,
      'user_pic': userPic,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'doctor_phone': doctorPhone,
      'doctor_pic': doctorPic,
      'service_id': serviceId,
      'appointment_status': appointmentStatus,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'selected_date': selectedDate,
      'selected_time': selectedTime,
      'selected_shift': selectedShift,
      'consultation_fees': consultationFees,
      'platform_fee': platformFee,
      'total_fee': totalFee,
      'is_cancelled': isCancelled,
      'is_deleted': isDeleted,
      'isVerified': isVerified,
      'otp': otp,
      'created_at': createdAt,
    };
  }
}
