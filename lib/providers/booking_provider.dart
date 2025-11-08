import 'package:flutter/foundation.dart';
import '../models/booking.dart';

class BookingProvider with ChangeNotifier {
  List<Booking> _bookings = [];

  List<Booking> get bookings => _bookings;

  BookingProvider() {
    _loadSampleBookings();
  }

  void _loadSampleBookings() {
    // Sample bookings for demo
    _bookings = [];
  }

  void createBooking({
    required String propertyId,
    required String propertyTitle,
    required String propertyOwnerId,
    required String propertyOwnerName,
    required String propertyOwnerPhone,
    required String bookerId,
    required String bookerName,
    required String bookerPhone,
    required String bookerEmail,
    required DateTime scheduledDate,
    required String scheduledTime,
    String? notes,
  }) {
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      propertyOwnerId: propertyOwnerId,
      propertyOwnerName: propertyOwnerName,
      propertyOwnerPhone: propertyOwnerPhone,
      bookerId: bookerId,
      bookerName: bookerName,
      bookerPhone: bookerPhone,
      bookerEmail: bookerEmail,
      scheduledDate: scheduledDate,
      scheduledTime: scheduledTime,
      notes: notes,
      status: BookingStatus.pending,
      createdAt: DateTime.now(),
    );

    _bookings.insert(0, booking);
    notifyListeners();
  }

  void updateBookingStatus(String bookingId, BookingStatus status) {
    final index = _bookings.indexWhere((booking) => booking.id == bookingId);
    if (index != -1) {
      final booking = _bookings[index];
      _bookings[index] = Booking(
        id: booking.id,
        propertyId: booking.propertyId,
        propertyTitle: booking.propertyTitle,
        propertyOwnerId: booking.propertyOwnerId,
        propertyOwnerName: booking.propertyOwnerName,
        propertyOwnerPhone: booking.propertyOwnerPhone,
        bookerId: booking.bookerId,
        bookerName: booking.bookerName,
        bookerPhone: booking.bookerPhone,
        bookerEmail: booking.bookerEmail,
        scheduledDate: booking.scheduledDate,
        scheduledTime: booking.scheduledTime,
        notes: booking.notes,
        status: status,
        createdAt: booking.createdAt,
        updatedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }

  List<Booking> getBookingsForUser(String userId) {
    return _bookings.where((booking) =>
        booking.propertyOwnerId == userId || booking.bookerId == userId).toList();
  }

  List<Booking> getBookingsForProperty(String propertyId) {
    return _bookings.where((booking) => booking.propertyId == propertyId).toList();
  }

  List<Booking> getPendingBookings(String userId) {
    return _bookings.where((booking) =>
        (booking.propertyOwnerId == userId || booking.bookerId == userId) &&
        booking.status == BookingStatus.pending).toList();
  }

  void cancelBooking(String bookingId) {
    updateBookingStatus(bookingId, BookingStatus.cancelled);
  }

  void confirmBooking(String bookingId) {
    updateBookingStatus(bookingId, BookingStatus.confirmed);
  }
}

