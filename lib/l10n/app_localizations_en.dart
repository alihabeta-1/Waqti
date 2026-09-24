// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Waqti';

  @override
  String get selectSlot => 'Select Slot';

  @override
  String get selectSlotSubtitle => 'Choose your preferred appointment time';

  @override
  String get duration => 'Duration';

  @override
  String get chooseStartTime => 'Choose a start time';

  @override
  String get thirtyMinutes => '30 min';

  @override
  String get sixtyMinutes => '60 min';

  @override
  String get ninetyMinutes => '90 min';

  @override
  String get oneHundredTwentyMinutes => '120 min';

  @override
  String get available => 'Available';

  @override
  String get booked => 'Booked';

  @override
  String get unavailable => 'Unavailable';

  @override
  String get selected => 'Selected';

  @override
  String get bookingSummary => 'Booking Summary';

  @override
  String get startTime => 'Start';

  @override
  String get endTime => 'End';

  @override
  String get totalDuration => 'Duration';

  @override
  String get confirmBooking => 'Confirm Booking';

  @override
  String get reset => 'Reset';

  @override
  String get bookingConfirmed => 'Booking confirmed';

  @override
  String get selectDurationFirst =>
      'Select a duration to see available start times';

  @override
  String get noAvailableTimes => 'No available times for this duration';

  @override
  String get slotAlreadyBooked => 'This time is already booked';

  @override
  String get slotUnavailable => 'This time is unavailable';

  @override
  String get notEnoughConsecutiveSlots =>
      'Not enough consecutive time slots are available';

  @override
  String get bookingExceedsWorkingHours =>
      'This appointment would extend beyond working hours';

  @override
  String get invalidThirtyMinuteGap =>
      'This booking would leave an invalid 30-minute gap';
}
