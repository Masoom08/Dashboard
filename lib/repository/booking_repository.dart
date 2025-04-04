import '../models/booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingRepository {
  final CollectionReference _bookingCollection =
  FirebaseFirestore.instance.collection('bookings');

  Future<void> createBooking(Booking booking) async {
    await _bookingCollection.doc(booking.bookingId).set(booking.toMap());
  }

  Future<List<Booking>> getUserBookings(String userId) async {
    final querySnapshot =
    await _bookingCollection.where('user_id', isEqualTo: userId).get();
    return querySnapshot.docs
        .map((doc) => Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _bookingCollection.doc(bookingId).update({'appointment_status': status});
  }
}
