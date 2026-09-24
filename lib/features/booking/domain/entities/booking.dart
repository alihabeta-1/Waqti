import 'package:equatable/equatable.dart';
import 'package:waqti/features/booking/domain/entities/booking_duration.dart';

class Booking extends Equatable {
  const Booking({
    required this.start,
    required this.end,
    required this.duration,
  });

  final DateTime start;
  final DateTime end;
  final BookingDuration duration;

  @override
  List<Object> get props => [start, end, duration];
}
