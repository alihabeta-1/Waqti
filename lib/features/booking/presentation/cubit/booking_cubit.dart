import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waqti/features/booking/domain/entities/booking.dart';
import 'package:waqti/features/booking/domain/entities/booking_duration.dart';
import 'package:waqti/features/booking/domain/repositories/booking_repository.dart';
import 'package:waqti/features/booking/domain/services/booking_failure_reason.dart';
import 'package:waqti/features/booking/domain/services/booking_validator.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  BookingCubit({
    required BookingRepository repository,
    required BookingValidator validator,
  }) : _repository = repository,
       _validator = validator,
       super(BookingState.initial());

  final BookingRepository _repository;
  final BookingValidator _validator;

  Future<void> initialize() async {
    await _loadDate(state.selectedDate);
  }

  Future<void> selectDate(DateTime date) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);

    if (normalizedDate == state.selectedDate) {
      return;
    }

    await _loadDate(normalizedDate);
  }

  void selectDuration(BookingDuration duration) {
    final validStartTimes = _validator.getValidStartTimes(
      slots: state.slots,
      duration: duration,
    );

    final currentStart = state.selectedStartTime;

    if (currentStart != null && validStartTimes.contains(currentStart)) {
      final validation = _validator.validate(
        slots: state.slots,
        startTime: currentStart,
        duration: duration,
      );

      if (validation.isValid) {
        emit(
          state.copyWith(
            status: BookingStatus.ready,
            selectedDuration: duration,
            selectedSlots: validation.selectedSlots,
            validStartTimes: validStartTimes,
            clearFailureReason: true,
          ),
        );

        return;
      }
    }

    emit(
      state.copyWith(
        status: BookingStatus.ready,
        selectedDuration: duration,
        clearSelectedStartTime: true,
        selectedSlots: const [],
        validStartTimes: validStartTimes,
        clearFailureReason: true,
      ),
    );
  }

  void selectStartTime(DateTime startTime) {
    final duration = state.selectedDuration;

    if (duration == null) {
      return;
    }

    final result = _validator.validate(
      slots: state.slots,
      startTime: startTime,
      duration: duration,
    );

    if (!result.isValid) {
      emit(
        state.copyWith(
          status: BookingStatus.ready,
          clearSelectedStartTime: true,
          selectedSlots: const [],
          failureReason: result.failureReason,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        status: BookingStatus.ready,
        selectedStartTime: startTime,
        selectedSlots: result.selectedSlots,
        clearFailureReason: true,
      ),
    );
  }

  Future<void> confirmBooking() async {
    final duration = state.selectedDuration;
    final startTime = state.selectedStartTime;

    if (duration == null || startTime == null) {
      return;
    }

    final validation = _validator.validate(
      slots: state.slots,
      startTime: startTime,
      duration: duration,
    );

    if (!validation.isValid) {
      emit(
        state.copyWith(
          status: BookingStatus.ready,
          selectedSlots: const [],
          clearSelectedStartTime: true,
          failureReason: validation.failureReason,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        status: BookingStatus.confirming,
        clearFailureReason: true,
      ),
    );

    try {
      final booking = Booking(
        start: startTime,
        end: startTime.add(duration.duration),
        duration: duration,
      );

      await _repository.saveBooking(booking);

      final slots = await _repository.getSlotsForDate(state.selectedDate);

      final validStartTimes = _validator.getValidStartTimes(
        slots: slots,
        duration: duration,
      );

      emit(
        state.copyWith(
          status: BookingStatus.confirmed,
          slots: slots,
          validStartTimes: validStartTimes,
          clearSelectedStartTime: true,
          selectedSlots: const [],
          clearFailureReason: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BookingStatus.failure,
          failureReason: BookingFailureReason.persistenceFailure,
        ),
      );
    }
  }

  void resetSelection() {
    emit(
      state.copyWith(
        status: BookingStatus.ready,
        clearSelectedDuration: true,
        clearSelectedStartTime: true,
        selectedSlots: const [],
        validStartTimes: const [],
        clearFailureReason: true,
      ),
    );
  }

  void clearFailure() {
    if (state.failureReason == null) {
      return;
    }

    emit(state.copyWith(clearFailureReason: true));
  }

  Future<void> _loadDate(DateTime date) async {
    emit(
      state.copyWith(
        status: BookingStatus.loading,
        selectedDate: date,
        clearSelectedStartTime: true,
        selectedSlots: const [],
        clearFailureReason: true,
      ),
    );

    try {
      final slots = await _repository.getSlotsForDate(date);

      final duration = state.selectedDuration;

      final validStartTimes = duration == null
          ? <DateTime>[]
          : _validator.getValidStartTimes(slots: slots, duration: duration);

      emit(
        state.copyWith(
          status: BookingStatus.ready,
          selectedDate: date,
          slots: slots,
          validStartTimes: validStartTimes,
          clearSelectedStartTime: true,
          selectedSlots: const [],
          clearFailureReason: true,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: BookingStatus.failure,
          selectedDate: date,
          clearSelectedStartTime: true,
          selectedSlots: const [],
          failureReason: BookingFailureReason.persistenceFailure,
        ),
      );
    }
  }
}
