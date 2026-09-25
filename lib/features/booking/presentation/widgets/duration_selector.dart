import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waqti/features/booking/domain/entities/booking_duration.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_state.dart';
import 'package:waqti/features/booking/presentation/widgets/duration_option_card.dart';
import 'package:waqti/l10n/app_localizations.dart';

class DurationSelector extends StatelessWidget {
  const DurationSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (previous, current) =>
          previous.selectedDuration != current.selectedDuration,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.duration,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 12.h),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 2.8,
              children: BookingDuration.values.map((duration) {
                return DurationOptionCard(
                  label: _getDurationLabel(l10n, duration),
                  isSelected: state.selectedDuration == duration,
                  onTap: () {
                    context.read<BookingCubit>().selectDuration(duration);
                  },
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  String _getDurationLabel(AppLocalizations l10n, BookingDuration duration) {
    switch (duration) {
      case BookingDuration.thirtyMinutes:
        return l10n.thirtyMinutes;

      case BookingDuration.sixtyMinutes:
        return l10n.sixtyMinutes;

      case BookingDuration.ninetyMinutes:
        return l10n.ninetyMinutes;

      case BookingDuration.oneHundredTwentyMinutes:
        return l10n.oneHundredTwentyMinutes;
    }
  }
}
