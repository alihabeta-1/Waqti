import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waqti/features/booking/domain/services/booking_failure_reason.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_state.dart';
import 'package:waqti/features/booking/presentation/widgets/booking_view_body.dart';
import 'package:waqti/l10n/app_localizations.dart';

class BookingViewContent extends StatelessWidget {
  const BookingViewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listenWhen: (previous, current) {
        return previous.status != current.status ||
            previous.failureReason != current.failureReason;
      },
      listener: (context, state) {
        final l10n = AppLocalizations.of(context)!;

        if (state.status == BookingStatus.confirmed) {
          _showMessage(context, message: l10n.bookingConfirmed, isError: false);

          return;
        }

        if (state.failureReason != null) {
          _showMessage(
            context,
            message: _failureMessage(l10n, state.failureReason!),
            isError: true,
          );

          context.read<BookingCubit>().clearFailure();
        }
      },
      child: const Scaffold(body: SafeArea(child: BookingViewBody())),
    );
  }

  void _showMessage(
    BuildContext context, {
    required String message,
    required bool isError,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: isError
              ? colorScheme.error
              : const Color(0xFF10B981),
        ),
      );
  }

  String _failureMessage(AppLocalizations l10n, BookingFailureReason reason) {
    switch (reason) {
      case BookingFailureReason.bookedSlot:
        return l10n.slotAlreadyBooked;

      case BookingFailureReason.unavailableSlot:
        return l10n.slotUnavailable;

      case BookingFailureReason.notEnoughConsecutiveSlots:
        return l10n.notEnoughConsecutiveSlots;

      case BookingFailureReason.exceedsWorkingHours:
        return l10n.bookingExceedsWorkingHours;

      case BookingFailureReason.createsInvalidGap:
        return l10n.invalidThirtyMinuteGap;

      case BookingFailureReason.pastDate:
        return l10n.pastDateBookingNotAllowed;

      case BookingFailureReason.pastTime:
        return l10n.pastTimeBookingNotAllowed;

      case BookingFailureReason.persistenceFailure:
        return l10n.bookingSaveFailed;

      case BookingFailureReason.startTimeNotFound:
        return l10n.invalidStartTime;
    }
  }
}
