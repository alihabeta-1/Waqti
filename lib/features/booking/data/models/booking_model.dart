import 'package:waqti/features/booking/domain/entities/booking.dart';
import 'package:waqti/features/booking/domain/entities/booking_duration.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.start,
    required super.end,
    required super.duration,
  });

  factory BookingModel.fromEntity(Booking booking) {
    return BookingModel(
      start: booking.start,
      end: booking.end,
      duration: booking.duration,
    );
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final durationMinutes = json['durationMinutes'] as int;

    return BookingModel(
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      duration: _durationFromMinutes(durationMinutes),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start.toIso8601String(),
      'end': end.toIso8601String(),
      'durationMinutes': duration.minutes,
    };
  }

  static BookingDuration _durationFromMinutes(int minutes) {
    return BookingDuration.values.firstWhere(
      (duration) => duration.minutes == minutes,
      orElse: () => throw FormatException(
        'Unsupported booking duration: $minutes minutes',
      ),
    );
  }
}
