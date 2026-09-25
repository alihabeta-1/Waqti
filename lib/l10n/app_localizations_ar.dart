// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'وقتي';

  @override
  String get selectSlot => 'اختر موعدك';

  @override
  String get selectSlotSubtitle => 'اختر الوقت المناسب لموعدك';

  @override
  String get duration => 'مدة الحجز';

  @override
  String get chooseStartTime => 'اختر وقت البداية';

  @override
  String get thirtyMinutes => '30 دقيقة';

  @override
  String get sixtyMinutes => '60 دقيقة';

  @override
  String get ninetyMinutes => '90 دقيقة';

  @override
  String get oneHundredTwentyMinutes => '120 دقيقة';

  @override
  String get available => 'متاح';

  @override
  String get booked => 'محجوز';

  @override
  String get unavailable => 'غير متاح';

  @override
  String get selected => 'محدد';

  @override
  String get bookingSummary => 'ملخص الحجز';

  @override
  String get startTime => 'البداية';

  @override
  String get endTime => 'النهاية';

  @override
  String get totalDuration => 'المدة';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get bookingConfirmed => 'تم تأكيد الحجز';

  @override
  String get selectDurationFirst => 'اختر مدة الحجز لعرض المواعيد المتاحة';

  @override
  String get noAvailableTimes => 'لا توجد مواعيد متاحة لهذه المدة';

  @override
  String get slotAlreadyBooked => 'هذا الموعد محجوز بالفعل';

  @override
  String get slotUnavailable => 'هذا الموعد غير متاح';

  @override
  String get notEnoughConsecutiveSlots => 'لا توجد مواعيد متتالية كافية للحجز';

  @override
  String get bookingExceedsWorkingHours => 'هذا الحجز يتجاوز ساعات العمل';

  @override
  String get invalidThirtyMinuteGap =>
      'هذا الحجز سيترك فترة 30 دقيقة غير صالحة';

  @override
  String get notAvailableForDuration => 'غير مناسب لمدة الحجز';
}
