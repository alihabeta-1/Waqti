import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waqti/core/di/injection_container.dart';
import 'package:waqti/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:waqti/features/booking/presentation/widgets/booking_view_body.dart';

class BookingView extends StatelessWidget {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<BookingCubit>()..initialize(),
      child: const Scaffold(body: SafeArea(child: BookingViewBody())),
    );
  }
}
