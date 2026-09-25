import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_state.dart';
import 'package:waqti/features/booking/presentation/widgets/confirm_booking_button.dart';
import 'package:waqti/features/booking/presentation/widgets/reset_booking_button.dart';
import 'package:waqti/l10n/app_localizations.dart';

class BookingActions extends StatelessWidget {
  const BookingActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (previous, current) {
        return previous.status != current.status ||
            previous.selectedDuration != current.selectedDuration ||
            previous.selectedStartTime != current.selectedStartTime ||
            previous.selectedSlots != current.selectedSlots;
      },
      builder: (context, state) {
        final isConfirming = state.status == BookingStatus.confirming;

        final canReset =
            state.selectedDuration != null ||
            state.selectedStartTime != null ||
            state.selectedSlots.isNotEmpty;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: ResetBookingButton(
                  label: l10n.reset,
                  isEnabled: canReset && !isConfirming,
                  onPressed: () {
                    context.read<BookingCubit>().resetSelection();
                  },
                ),
              ),

              SizedBox(width: 10.w),

              Expanded(
                flex: 3,
                child: ConfirmBookingButton(
                  label: l10n.confirmBooking,
                  isEnabled: state.hasValidSelection,
                  isLoading: isConfirming,
                  onPressed: () {
                    context.read<BookingCubit>().confirmBooking();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
