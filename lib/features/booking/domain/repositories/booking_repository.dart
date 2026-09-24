import 'package:waqti/features/booking/domain/entities/booking.dart';
import 'package:waqti/features/booking/domain/entities/time_slot.dart';

abstract interface class BookingRepository {
  Future<List<TimeSlot>> getSlotsForDate(DateTime date);

  Future<List<Booking>> getBookingsForDate(DateTime date);

  Future<void> saveBooking(Booking booking);
}
