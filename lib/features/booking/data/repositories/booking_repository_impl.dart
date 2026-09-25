import 'package:waqti/core/constants/booking_constants.dart';
import 'package:waqti/features/booking/data/datasources/booking_local_data_source.dart';
import 'package:waqti/features/booking/data/models/booking_model.dart';
import 'package:waqti/features/booking/domain/entities/booking.dart';
import 'package:waqti/features/booking/domain/entities/slot_status.dart';
import 'package:waqti/features/booking/domain/entities/time_slot.dart';
import 'package:waqti/features/booking/domain/repositories/booking_repository.dart';

class BookingRepositoryImpl implements BookingRepository {
  BookingRepositoryImpl({required BookingLocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  final BookingLocalDataSource _localDataSource;

  @override
  Future<List<Booking>> getBookingsForDate(DateTime date) async {
    final bookings = await _localDataSource.getBookings();

    return bookings.where((booking) {
      return _isSameDate(booking.start, date);
    }).toList();
  }

  @override
  Future<List<TimeSlot>> getSlotsForDate(DateTime date) async {
    final bookings = await getBookingsForDate(date);

    final slots = <TimeSlot>[];

    var current = DateTime(
      date.year,
      date.month,
      date.day,
      BookingConstants.workingDayStartHour,
    );

    final workingDayEnd = DateTime(
      date.year,
      date.month,
      date.day,
      BookingConstants.workingDayEndHour,
    );

    while (current.isBefore(workingDayEnd)) {
      final slotEnd = current.add(
        const Duration(minutes: BookingConstants.slotDurationMinutes),
      );

      final status = _getSlotStatus(
        slotStart: current,
        slotEnd: slotEnd,
        bookings: bookings,
      );

      slots.add(TimeSlot(start: current, end: slotEnd, status: status));

      current = slotEnd;
    }

    return slots;
  }

  @override
  Future<void> saveBooking(Booking booking) async {
    final model = BookingModel.fromEntity(booking);

    await _localDataSource.saveBooking(model);
  }

  SlotStatus _getSlotStatus({
    required DateTime slotStart,
    required DateTime slotEnd,
    required List<Booking> bookings,
  }) {
    final isUserBooked = bookings.any((booking) {
      return slotStart.isBefore(booking.end) && slotEnd.isAfter(booking.start);
    });

    if (isUserBooked) {
      return SlotStatus.booked;
    }

    return SlotStatus.available;
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
