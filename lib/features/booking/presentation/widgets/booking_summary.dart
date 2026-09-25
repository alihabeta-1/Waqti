import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_state.dart';
import 'package:waqti/features/booking/presentation/widgets/summary_item.dart';
import 'package:waqti/l10n/app_localizations.dart';

class BookingSummary extends StatelessWidget {
  const BookingSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (previous, current) {
        return previous.selectedStartTime != current.selectedStartTime ||
            previous.selectedDuration != current.selectedDuration ||
            previous.selectedSlots != current.selectedSlots;
      },
      builder: (context, state) {
        final hasSelection = state.hasValidSelection;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: hasSelection
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.30)
                  : Theme.of(context).dividerColor,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34.r,
                    height: 34.r,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(9.r),
                    ),
                    child: Icon(
                      Icons.calendar_month_rounded,
                      size: 18.r,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: Text(
                      l10n.bookingSummary,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: SummaryItem(
                      label: l10n.startTime,
                      value: state.selectedStartTime == null
                          ? '--'
                          : _formatTime(context, state.selectedStartTime!),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: SummaryItem(
                      label: l10n.endTime,
                      value: state.endTime == null
                          ? '--'
                          : _formatTime(context, state.endTime!),
                    ),
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: SummaryItem(
                      label: l10n.totalDuration,
                      value: state.selectedDuration == null
                          ? '--'
                          : _durationLabel(
                              l10n,
                              state.selectedDuration!.minutes,
                            ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(BuildContext context, DateTime time) {
    final locale = Localizations.localeOf(context).languageCode;

    return DateFormat('hh:mm a', locale).format(time);
  }

  String _durationLabel(AppLocalizations l10n, int minutes) {
    switch (minutes) {
      case 30:
        return l10n.thirtyMinutes;
      case 60:
        return l10n.sixtyMinutes;
      case 90:
        return l10n.ninetyMinutes;
      case 120:
        return l10n.oneHundredTwentyMinutes;
      default:
        return '$minutes min';
    }
  }
}
