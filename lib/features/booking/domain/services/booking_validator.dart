import 'package:waqti/core/constants/booking_constants.dart';
import 'package:waqti/features/booking/domain/entities/booking_duration.dart';
import 'package:waqti/features/booking/domain/entities/slot_status.dart';
import 'package:waqti/features/booking/domain/entities/time_slot.dart';
import 'package:waqti/features/booking/domain/services/booking_failure_reason.dart';
import 'package:waqti/features/booking/domain/services/booking_validation_result.dart';

class BookingValidator {
  const BookingValidator();

  BookingValidationResult validate({
    required List<TimeSlot> slots,
    required DateTime startTime,
    required BookingDuration duration,
    DateTime? now,
  }) {
    final sortedSlots = [...slots]
      ..sort((a, b) => a.start.compareTo(b.start));

    final currentTime = now ?? DateTime.now();

    final bookingDate = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
    );

    final today = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
    );

    // Past dates are view-only.
    if (bookingDate.isBefore(today)) {
      return const BookingValidationResult.invalid(
        BookingFailureReason.pastDate,
      );
    }

    final isToday =
        bookingDate.year == today.year &&
        bookingDate.month == today.month &&
        bookingDate.day == today.day;

    // On today, a slot that has already started cannot be booked.
    if (isToday && !startTime.isAfter(currentTime)) {
      return const BookingValidationResult.invalid(
        BookingFailureReason.pastTime,
      );
    }

    final bookingEnd = startTime.add(duration.duration);

    final workingDayEnd = DateTime(
      startTime.year,
      startTime.month,
      startTime.day,
      BookingConstants.workingDayEndHour,
    );

    if (bookingEnd.isAfter(workingDayEnd)) {
      return const BookingValidationResult.invalid(
        BookingFailureReason.exceedsWorkingHours,
      );
    }

    final startIndex = sortedSlots.indexWhere(
      (slot) => slot.start == startTime,
    );

    if (startIndex == -1) {
      return const BookingValidationResult.invalid(
        BookingFailureReason.startTimeNotFound,
      );
    }

    final requiredSlotsCount = duration.slotsCount;
    final endIndex = startIndex + requiredSlotsCount;

    if (endIndex > sortedSlots.length) {
      return const BookingValidationResult.invalid(
        BookingFailureReason.notEnoughConsecutiveSlots,
      );
    }

    final selectedSlots = sortedSlots.sublist(
      startIndex,
      endIndex,
    );

    if (!_areContinuous(selectedSlots)) {
      return const BookingValidationResult.invalid(
        BookingFailureReason.notEnoughConsecutiveSlots,
      );
    }

    for (final slot in selectedSlots) {
      if (slot.status == SlotStatus.booked) {
        return const BookingValidationResult.invalid(
          BookingFailureReason.bookedSlot,
        );
      }

      if (slot.status == SlotStatus.unavailable) {
        return const BookingValidationResult.invalid(
          BookingFailureReason.unavailableSlot,
        );
      }
    }

    if (_createsInvalidThirtyMinuteGap(
      slots: sortedSlots,
      selectedSlots: selectedSlots,
    )) {
      return const BookingValidationResult.invalid(
        BookingFailureReason.createsInvalidGap,
      );
    }

    return BookingValidationResult.valid(
      selectedSlots: selectedSlots,
    );
  }

  List<DateTime> getValidStartTimes({
    required List<TimeSlot> slots,
    required BookingDuration duration,
    DateTime? now,
  }) {
    final validStartTimes = <DateTime>[];

    for (final slot in slots) {
      if (slot.status != SlotStatus.available) {
        continue;
      }

      final result = validate(
        slots: slots,
        startTime: slot.start,
        duration: duration,
        now: now,
      );

      if (result.isValid) {
        validStartTimes.add(slot.start);
      }
    }

    return validStartTimes;
  }

  bool _areContinuous(List<TimeSlot> slots) {
    if (slots.isEmpty) return false;

    for (var index = 0; index < slots.length - 1; index++) {
      final current = slots[index];
      final next = slots[index + 1];

      if (current.end != next.start) {
        return false;
      }
    }

    return true;
  }

  bool _createsInvalidThirtyMinuteGap({
    required List<TimeSlot> slots,
    required List<TimeSlot> selectedSlots,
  }) {
    if (selectedSlots.isEmpty) return false;

    final selectedStarts = selectedSlots
        .map((slot) => slot.start)
        .toSet();

    final simulatedStatuses = slots.map((slot) {
      if (selectedStarts.contains(slot.start)) {
        return SlotStatus.booked;
      }

      return slot.status;
    }).toList();

    for (
      var index = 0;
      index < simulatedStatuses.length;
      index++
    ) {
      if (simulatedStatuses[index] !=
          SlotStatus.available) {
        continue;
      }

      final isLastSlot =
          index == simulatedStatuses.length - 1;

      // A single available slot at the end of the working day is allowed.
      if (isLastSlot) {
        continue;
      }

      final previousIsBlocked =
          index == 0 ||
          simulatedStatuses[index - 1] !=
              SlotStatus.available;

      final nextIsBlocked =
          simulatedStatuses[index + 1] !=
          SlotStatus.available;

      if (previousIsBlocked && nextIsBlocked) {
        return true;
      }
    }

    return false;
  }
}
