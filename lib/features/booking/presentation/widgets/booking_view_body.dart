import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_state.dart';

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

        if (state.status == BookingStatus.failure && state.slots.isEmpty) {
          return const Center(child: Text('Unable to load booking slots'));
        }

        return const Center(child: Text('Waqti Booking'));
      },
    );
  }
}
