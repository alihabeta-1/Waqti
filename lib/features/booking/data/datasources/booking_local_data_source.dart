import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:waqti/features/booking/data/models/booking_model.dart';

abstract interface class BookingLocalDataSource {
  Future<List<BookingModel>> getBookings();

  Future<void> saveBooking(BookingModel booking);
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  BookingLocalDataSourceImpl({required SharedPreferences sharedPreferences})
    : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  static const String _bookingsKey = 'confirmed_bookings';

  @override
  Future<List<BookingModel>> getBookings() async {
    final storedBookings =
        _sharedPreferences.getStringList(_bookingsKey) ?? const [];

    return storedBookings.map((bookingJson) {
      final json = jsonDecode(bookingJson) as Map<String, dynamic>;

      return BookingModel.fromJson(json);
    }).toList();
  }

  @override
  Future<void> saveBooking(BookingModel booking) async {
    final storedBookings =
        _sharedPreferences.getStringList(_bookingsKey) ?? <String>[];

    final updatedBookings = [...storedBookings, jsonEncode(booking.toJson())];

    final saved = await _sharedPreferences.setStringList(
      _bookingsKey,
      updatedBookings,
    );

    if (!saved) {
      throw StateError('Failed to persist booking locally.');
    }
  }
}
