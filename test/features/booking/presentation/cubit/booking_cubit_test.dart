import 'package:flutter_test/flutter_test.dart';
import 'package:waqti/features/booking/domain/entities/booking.dart';
import 'package:waqti/features/booking/domain/entities/booking_duration.dart';
import 'package:waqti/features/booking/domain/entities/slot_status.dart';
import 'package:waqti/features/booking/domain/entities/time_slot.dart';
import 'package:waqti/features/booking/domain/repositories/booking_repository.dart';
import 'package:waqti/features/booking/domain/services/booking_validator.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_state.dart';

import '../../domain/services/booking_validator_test.dart';

void main() {
  late FakeBookingRepository repository;
  late BookingCubit cubit;

  final testDate = DateTime(2026, 9, 24);

  DateTime time(int hour, [int minute = 0]) {
    return DateTime(testDate.year, testDate.month, testDate.day, hour, minute);
  }

  List<TimeSlot> createFullDaySlots() {
    final slots = <TimeSlot>[];

    var current = time(9);
    final end = time(18);

    while (current.isBefore(end)) {
      slots.add(
        TimeSlot(
          start: current,
          end: current.add(const Duration(minutes: 30)),
          status: SlotStatus.available,
        ),
      );

      current = current.add(const Duration(minutes: 30));
    }

    return slots;
  }

  setUp(() {
    repository = FakeBookingRepository(slots: createFullDaySlots());

    cubit = BookingCubit(
      repository: repository,
      validator: BookingValidator(
        timeProvider: FakeTimeProvider(DateTime(2026, 9, 24, 8)),
      ),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('BookingCubit', () {
    test('initial state has no booking selection', () {
      expect(cubit.state.status, BookingStatus.initial);
      expect(cubit.state.selectedDuration, isNull);
      expect(cubit.state.selectedStartTime, isNull);
      expect(cubit.state.selectedSlots, isEmpty);
      expect(cubit.state.validStartTimes, isEmpty);
      expect(cubit.state.hasValidSelection, isFalse);
    });

    test('selecting duration calculates valid start times', () async {
      await cubit.selectDate(testDate);

      cubit.selectDuration(BookingDuration.sixtyMinutes);

      expect(cubit.state.selectedDuration, BookingDuration.sixtyMinutes);

      expect(cubit.state.validStartTimes, isNotEmpty);

      expect(cubit.state.selectedStartTime, isNull);
    });

    test('selecting valid start time creates booking selection', () async {
      await cubit.selectDate(testDate);

      cubit.selectDuration(BookingDuration.sixtyMinutes);

      cubit.selectStartTime(time(10));

      expect(cubit.state.selectedStartTime, time(10));

      expect(cubit.state.selectedSlots.length, 2);

      expect(cubit.state.endTime, time(11));

      expect(cubit.state.hasValidSelection, isTrue);
    });

    test('changing duration recalculates selected booking range', () async {
      await cubit.selectDate(testDate);

      cubit.selectDuration(BookingDuration.sixtyMinutes);

      cubit.selectStartTime(time(10));

      expect(cubit.state.selectedSlots.length, 2);

      cubit.selectDuration(BookingDuration.ninetyMinutes);

      expect(cubit.state.selectedDuration, BookingDuration.ninetyMinutes);

      expect(cubit.state.selectedStartTime, time(10));

      expect(cubit.state.selectedSlots.length, 3);

      expect(cubit.state.endTime, time(11, 30));
    });

    test('reset clears current selection', () async {
      await cubit.selectDate(testDate);

      cubit.selectDuration(BookingDuration.sixtyMinutes);

      cubit.selectStartTime(time(10));

      cubit.resetSelection();

      expect(cubit.state.selectedDuration, isNull);

      expect(cubit.state.selectedStartTime, isNull);

      expect(cubit.state.selectedSlots, isEmpty);

      expect(cubit.state.validStartTimes, isEmpty);

      expect(cubit.state.hasValidSelection, isFalse);
    });

    test('confirm booking saves booking and clears selection', () async {
      await cubit.selectDate(testDate);

      cubit.selectDuration(BookingDuration.sixtyMinutes);

      cubit.selectStartTime(time(10));

      await cubit.confirmBooking();

      expect(repository.savedBookings.length, 1);

      expect(repository.savedBookings.first.start, time(10));

      expect(repository.savedBookings.first.end, time(11));

      expect(cubit.state.status, BookingStatus.confirmed);

      expect(cubit.state.selectedStartTime, isNull);

      expect(cubit.state.selectedSlots, isEmpty);
    });
  });
}

class FakeBookingRepository implements BookingRepository {
  FakeBookingRepository({required List<TimeSlot> slots})
    : _slots = List<TimeSlot>.from(slots);

  List<TimeSlot> _slots;

  final List<Booking> savedBookings = [];

  @override
  Future<List<Booking>> getBookingsForDate(DateTime date) async {
    return savedBookings.where((booking) {
      return booking.start.year == date.year &&
          booking.start.month == date.month &&
          booking.start.day == date.day;
    }).toList();
  }

  @override
  Future<List<TimeSlot>> getSlotsForDate(DateTime date) async {
    return List<TimeSlot>.from(_slots);
  }

  @override
  Future<void> saveBooking(Booking booking) async {
    savedBookings.add(booking);

    _slots = _slots.map((slot) {
      final overlaps =
          slot.start.isBefore(booking.end) && slot.end.isAfter(booking.start);

      if (!overlaps) {
        return slot;
      }

      return slot.copyWith(status: SlotStatus.booked);
    }).toList();
  }
}
