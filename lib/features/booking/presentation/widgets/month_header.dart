import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/widgets/navigatin_button.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader({super.key, required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;

    final monthText = DateFormat('MMMM yyyy', locale).format(selectedDate);

    return Row(
      children: [
        Expanded(
          child: Text(
            monthText,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),

        NavigationButton(
          icon: Icons.chevron_left_rounded,
          onTap: () {
            _changeDate(
              context,
              selectedDate.subtract(const Duration(days: 5)),
            );
          },
        ),

        SizedBox(width: 6.w),

        NavigationButton(
          icon: Icons.chevron_right_rounded,
          onTap: () {
            _changeDate(context, selectedDate.add(const Duration(days: 5)));
          },
        ),
      ],
    );
  }

  void _changeDate(BuildContext context, DateTime date) {
    context.read<BookingCubit>().selectDate(date);
  }
}
