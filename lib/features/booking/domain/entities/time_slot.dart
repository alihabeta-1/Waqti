import 'package:equatable/equatable.dart';
import 'package:waqti/features/booking/domain/entities/slot_status.dart';

class TimeSlot extends Equatable {
  const TimeSlot({
    required this.start,
    required this.end,
    required this.status,
  });

  final DateTime start;
  final DateTime end;
  final SlotStatus status;

  TimeSlot copyWith({DateTime? start, DateTime? end, SlotStatus? status}) {
    return TimeSlot(
      start: start ?? this.start,
      end: end ?? this.end,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [start, end, status];
}
