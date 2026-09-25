import 'package:flutter_test/flutter_test.dart';
import 'package:waqti/features/booking/domain/entities/booking_duration.dart';
import 'package:waqti/features/booking/domain/entities/slot_status.dart';
import 'package:waqti/features/booking/domain/entities/time_slot.dart';
import 'package:waqti/features/booking/domain/services/booking_failure_reason.dart';
import 'package:waqti/features/booking/domain/services/booking_validator.dart';

void main() {
  const validator = BookingValidator();

  final testDate = DateTime(2026, 9, 24);

  DateTime time(int hour, [int minute = 0]) {
    return DateTime(
      testDate.year,
      testDate.month,
      testDate.day,
      hour,
      minute,
    );
  }

  TimeSlot slot(
    int hour,
    int minute, {
    SlotStatus status = SlotStatus.available,
  }) {
    final start = time(hour, minute);

    return TimeSlot(
      start: start,
      end: start.add(const Duration(minutes: 30)),
      status: status,
    );
  }

  List<TimeSlot> fullDay({
    Map<DateTime, SlotStatus> statuses = const {},
  }) {
    final slots = <TimeSlot>[];

    var current = time(9);
    final end = time(18);

    while (current.isBefore(end)) {
      slots.add(
        TimeSlot(
          start: current,
          end: current.add(const Duration(minutes: 30)),
          status: statuses[current] ?? SlotStatus.available,
        ),
      );

      current = current.add(const Duration(minutes: 30));
    }

    return slots;
  }

  group('Past date and time validation', () {
    test('rejects booking on a past date', () {
      final slots = fullDay();

      final result = validator.validate(
        slots: slots,
        startTime: time(10),
        duration: BookingDuration.thirtyMinutes,
        now: DateTime(2026, 9, 25, 8),
      );

      expect(result.isValid, isFalse);
      expect(
        result.failureReason,
        BookingFailureReason.pastDate,
      );
    });

    test('rejects a slot that already started today', () {
      final slots = fullDay();

      final result = validator.validate(
        slots: slots,
        startTime: time(10),
        duration: BookingDuration.thirtyMinutes,
        now: time(10, 15),
      );

      expect(result.isValid, isFalse);
      expect(
        result.failureReason,
        BookingFailureReason.pastTime,
      );
    });

    test(
      'rejects a slot starting exactly at current time',
      () {
        final slots = fullDay();

        final result = validator.validate(
          slots: slots,
          startTime: time(10),
          duration: BookingDuration.thirtyMinutes,
          now: time(10),
        );

        expect(result.isValid, isFalse);
        expect(
          result.failureReason,
          BookingFailureReason.pastTime,
        );
      },
    );

    test('allows a future slot today', () {
      final slots = fullDay();

      final result = validator.validate(
        slots: slots,
        startTime: time(10, 30),
        duration: BookingDuration.thirtyMinutes,
        now: time(10, 15),
      );

      expect(result.isValid, isTrue);
    });

    test(
      'valid start times exclude times that already passed today',
      () {
        final slots = fullDay();

        final validStartTimes = validator
            .getValidStartTimes(
              slots: slots,
              duration: BookingDuration.thirtyMinutes,
              now: time(10, 15),
            );

        expect(validStartTimes, isNot(contains(time(9))));

        expect(validStartTimes, isNot(contains(time(10))));

        expect(validStartTimes, contains(time(10, 30)));
      },
    );
  });

  group('BookingValidator.validate', () {
    test(
      'returns valid for a normal 30-minute booking',
      () {
        final slots = fullDay();

        final result = validator.validate(
          slots: slots,
          startTime: time(9),
          duration: BookingDuration.thirtyMinutes,
        );

        expect(result.isValid, isTrue);
        expect(result.failureReason, isNull);
        expect(result.selectedSlots.length, 1);
      },
    );

    test(
      'returns valid for continuous 90-minute booking',
      () {
        final slots = fullDay();

        final result = validator.validate(
          slots: slots,
          startTime: time(9),
          duration: BookingDuration.ninetyMinutes,
        );

        expect(result.isValid, isTrue);
        expect(result.selectedSlots.length, 3);

        expect(result.selectedSlots.first.start, time(9));

        expect(result.selectedSlots.last.end, time(10, 30));
      },
    );

    test(
      'returns bookedSlot when booking overlaps a booked slot',
      () {
        final slots = fullDay(
          statuses: {time(10): SlotStatus.booked},
        );

        final result = validator.validate(
          slots: slots,
          startTime: time(9, 30),
          duration: BookingDuration.sixtyMinutes,
        );

        expect(result.isValid, isFalse);

        expect(
          result.failureReason,
          BookingFailureReason.bookedSlot,
        );
      },
    );

    test(
      'returns unavailableSlot when range contains unavailable slot',
      () {
        final slots = fullDay(
          statuses: {time(10): SlotStatus.unavailable},
        );

        final result = validator.validate(
          slots: slots,
          startTime: time(9, 30),
          duration: BookingDuration.sixtyMinutes,
        );

        expect(result.isValid, isFalse);

        expect(
          result.failureReason,
          BookingFailureReason.unavailableSlot,
        );
      },
    );

    test(
      'returns exceedsWorkingHours when booking ends after 6 PM',
      () {
        final slots = fullDay();

        final result = validator.validate(
          slots: slots,
          startTime: time(17, 30),
          duration: BookingDuration.sixtyMinutes,
        );

        expect(result.isValid, isFalse);

        expect(
          result.failureReason,
          BookingFailureReason.exceedsWorkingHours,
        );
      },
    );

    test('allows booking that ends exactly at 6 PM', () {
      final slots = fullDay();

      final result = validator.validate(
        slots: slots,
        startTime: time(17),
        duration: BookingDuration.sixtyMinutes,
      );

      expect(result.isValid, isTrue);
    });

    test(
      'returns startTimeNotFound when start slot does not exist',
      () {
        final slots = fullDay();

        final result = validator.validate(
          slots: slots,
          startTime: time(8, 30),
          duration: BookingDuration.thirtyMinutes,
        );

        expect(result.isValid, isFalse);

        expect(
          result.failureReason,
          BookingFailureReason.startTimeNotFound,
        );
      },
    );

    test(
      'returns notEnoughConsecutiveSlots when slots are not continuous',
      () {
        final slots = [
          slot(9, 0),
          slot(9, 30),
          slot(10, 30),
        ];

        final result = validator.validate(
          slots: slots,
          startTime: time(9, 30),
          duration: BookingDuration.sixtyMinutes,
        );

        expect(result.isValid, isFalse);

        expect(
          result.failureReason,
          BookingFailureReason.notEnoughConsecutiveSlots,
        );
      },
    );
  });

  group('30-minute gap rule', () {
    test(
      'rejects booking that leaves an isolated slot at start of day',
      () {
        final slots = fullDay(
          statuses: {time(10): SlotStatus.booked},
        );

        final result = validator.validate(
          slots: slots,
          startTime: time(9, 30),
          duration: BookingDuration.thirtyMinutes,
        );

        expect(result.isValid, isFalse);

        expect(
          result.failureReason,
          BookingFailureReason.createsInvalidGap,
        );
      },
    );

    test(
      'rejects booking that creates an isolated internal 30-minute gap',
      () {
        final slots = fullDay(
          statuses: {
            time(9): SlotStatus.booked,
            time(11): SlotStatus.booked,
          },
        );

        final result = validator.validate(
          slots: slots,
          startTime: time(10),
          duration: BookingDuration.sixtyMinutes,
        );

        expect(result.isValid, isFalse);

        expect(
          result.failureReason,
          BookingFailureReason.createsInvalidGap,
        );
      },
    );

    test(
      'allows an isolated 30-minute slot at end of working day',
      () {
        final slots = fullDay();

        final result = validator.validate(
          slots: slots,
          startTime: time(16, 30),
          duration: BookingDuration.sixtyMinutes,
        );

        expect(result.isValid, isTrue);
      },
    );
  });

  group('BookingValidator.getValidStartTimes', () {
    test(
      'returns only start times valid for selected duration',
      () {
        final slots = fullDay(
          statuses: {time(10, 30): SlotStatus.booked},
        );

        final validStartTimes = validator
            .getValidStartTimes(
              slots: slots,
              duration: BookingDuration.ninetyMinutes,
            );

        expect(validStartTimes, contains(time(9)));

        expect(
          validStartTimes,
          isNot(contains(time(9, 30))),
        );

        expect(validStartTimes, isNot(contains(time(10))));

        expect(
          validStartTimes,
          isNot(contains(time(10, 30))),
        );
      },
    );
  });
}
