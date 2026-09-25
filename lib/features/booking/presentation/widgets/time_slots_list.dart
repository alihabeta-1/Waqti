import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waqti/features/booking/domain/entities/time_slot.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_state.dart';
import 'package:waqti/features/booking/presentation/widgets/time_slot_tile.dart';

class TimeSlotsList extends StatelessWidget {
  const TimeSlotsList({super.key, required this.state});

  final BookingState state;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.slots.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 2.2,
          ),
      itemBuilder: (context, index) {
        final slot = state.slots[index];

        return TimeSlotTile(
          slot: slot,
          hasDuration: state.selectedDuration != null,
          isValidStartTime: state.validStartTimes.contains(
            slot.start,
          ),
          isSelected: _isSelected(
            slot,
            state.selectedSlots,
          ),
          onTap: () {
            context.read<BookingCubit>().selectStartTime(
              slot.start,
            );
          },
        );
      },
    );
  }

  bool _isSelected(
    TimeSlot slot,
    List<TimeSlot> selectedSlots,
  ) {
    return selectedSlots.any(
      (selectedSlot) => selectedSlot.start == slot.start,
    );
  }
}
