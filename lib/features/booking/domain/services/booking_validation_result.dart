import 'package:equatable/equatable.dart';
import 'package:waqti/features/booking/domain/entities/time_slot.dart';
import 'package:waqti/features/booking/domain/services/booking_failure_reason.dart';

class BookingValidationResult extends Equatable {
  const BookingValidationResult._({
    required this.isValid,
    this.selectedSlots = const [],
    this.failureReason,
  });

  const BookingValidationResult.valid({required List<TimeSlot> selectedSlots})
    : this._(isValid: true, selectedSlots: selectedSlots);

  const BookingValidationResult.invalid(BookingFailureReason reason)
    : this._(isValid: false, failureReason: reason);

  final bool isValid;
  final List<TimeSlot> selectedSlots;
  final BookingFailureReason? failureReason;

  @override
  List<Object?> get props => [isValid, selectedSlots, failureReason];
}
