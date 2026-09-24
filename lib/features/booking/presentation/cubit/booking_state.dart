import 'package:equatable/equatable.dart';
import 'package:waqti/features/booking/domain/entities/booking_duration.dart';
import 'package:waqti/features/booking/domain/entities/time_slot.dart';
import 'package:waqti/features/booking/domain/services/booking_failure_reason.dart';

enum BookingStatus { initial, loading, ready, confirming, confirmed, failure }

class BookingState extends Equatable {
  const BookingState({
    required this.selectedDate,
    this.status = BookingStatus.initial,
    this.slots = const [],
    this.selectedDuration,
    this.selectedStartTime,
    this.selectedSlots = const [],
    this.validStartTimes = const [],
    this.failureReason,
  });

  factory BookingState.initial() {
    final now = DateTime.now();

    return BookingState(selectedDate: DateTime(now.year, now.month, now.day));
  }

  final BookingStatus status;

  final DateTime selectedDate;

  final List<TimeSlot> slots;

  final BookingDuration? selectedDuration;

  final DateTime? selectedStartTime;

  final List<TimeSlot> selectedSlots;

  final List<DateTime> validStartTimes;

  final BookingFailureReason? failureReason;

  DateTime? get endTime {
    final start = selectedStartTime;
    final duration = selectedDuration;

    if (start == null || duration == null) {
      return null;
    }

    return start.add(duration.duration);
  }

  bool get hasValidSelection {
    return selectedDuration != null &&
        selectedStartTime != null &&
        selectedSlots.isNotEmpty &&
        failureReason == null;
  }

  BookingState copyWith({
    BookingStatus? status,
    DateTime? selectedDate,
    List<TimeSlot>? slots,
    BookingDuration? selectedDuration,
    bool clearSelectedDuration = false,
    DateTime? selectedStartTime,
    bool clearSelectedStartTime = false,
    List<TimeSlot>? selectedSlots,
    List<DateTime>? validStartTimes,
    BookingFailureReason? failureReason,
    bool clearFailureReason = false,
  }) {
    return BookingState(
      status: status ?? this.status,
      selectedDate: selectedDate ?? this.selectedDate,
      slots: slots ?? this.slots,
      selectedDuration: clearSelectedDuration
          ? null
          : selectedDuration ?? this.selectedDuration,
      selectedStartTime: clearSelectedStartTime
          ? null
          : selectedStartTime ?? this.selectedStartTime,
      selectedSlots: selectedSlots ?? this.selectedSlots,
      validStartTimes: validStartTimes ?? this.validStartTimes,
      failureReason: clearFailureReason
          ? null
          : failureReason ?? this.failureReason,
    );
  }

  @override
  List<Object?> get props => [
    status,
    selectedDate,
    slots,
    selectedDuration,
    selectedStartTime,
    selectedSlots,
    validStartTimes,
    failureReason,
  ];
}
