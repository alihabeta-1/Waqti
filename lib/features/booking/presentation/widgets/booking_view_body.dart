import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_state.dart';
import 'package:waqti/features/booking/presentation/widgets/booking_actions.dart';
import 'package:waqti/features/booking/presentation/widgets/booking_header.dart';
import 'package:waqti/features/booking/presentation/widgets/booking_intro.dart';
import 'package:waqti/features/booking/presentation/widgets/booking_summary.dart';
import 'package:waqti/features/booking/presentation/widgets/date_selector.dart';
import 'package:waqti/features/booking/presentation/widgets/duration_selector.dart';
import 'package:waqti/features/booking/presentation/widgets/time_slots_section.dart';

class BookingViewBody extends StatelessWidget {
  const BookingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state.status == BookingStatus.initial ||
            state.status == BookingStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            const BookingHeader(),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: ListView(
                  children: [
                    const BookingIntro(),

                    const DateSelector(),

                    SizedBox(height: 16.h),

                    const DurationSelector(),

                    SizedBox(height: 16.h),

                    const TimeSlotsSection(),
                    SizedBox(height: 16.h),

                    const BookingSummary(),
                    SizedBox(height: 16.h),

                    const BookingActions(),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
