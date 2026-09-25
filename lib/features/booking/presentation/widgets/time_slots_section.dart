import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_state.dart';
import 'package:waqti/features/booking/presentation/widgets/slots_legend.dart';
import 'package:waqti/features/booking/presentation/widgets/time_slots_list.dart';
import 'package:waqti/l10n/app_localizations.dart';

class TimeSlotsSection extends StatelessWidget {
  const TimeSlotsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.chooseStartTime,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),

            SizedBox(height: 10.h),

            const SlotsLegend(),

            SizedBox(height: 12.h),

            if (state.selectedDuration == null) ...[
              Text(
                l10n.selectDurationFirst,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 12.h),
            ],

            TimeSlotsList(state: state),
          ],
        );
      },
    );
  }
}
