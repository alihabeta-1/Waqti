import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_state.dart';
import 'package:waqti/features/booking/presentation/widgets/date_item.dart';
import 'package:waqti/features/booking/presentation/widgets/month_header.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  static const int _visibleDays = 5;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      buildWhen: (previous, current) =>
          previous.selectedDate != current.selectedDate,
      builder: (context, state) {
        final selectedDate = state.selectedDate;

        final dates = _buildVisibleDates(selectedDate);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MonthHeader(selectedDate: selectedDate),

            SizedBox(height: 12.h),

            Row(
              children: dates.map((date) {
                return Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: date != dates.last ? 6.w : 0,
                    ),
                    child: DayItem(
                      date: date,
                      isSelected: _isSameDate(date, selectedDate),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  List<DateTime> _buildVisibleDates(DateTime selectedDate) {
    final startDate = selectedDate.subtract(const Duration(days: 2));

    return List.generate(
      _visibleDays,
      (index) => startDate.add(Duration(days: index)),
    );
  }

  bool _isSameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
