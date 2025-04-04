import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../repository/booking_repository.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingRepository _bookingRepository = BookingRepository();
  List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

  Future<void> fetchUserBookings(String userId) async {
    _bookings = await _bookingRepository.getUserBookings(userId);
    notifyListeners();
  }

  Future<void> createBooking(Booking booking) async {
    await _bookingRepository.createBooking(booking);
    fetchUserBookings(booking.userId);
  }
}
