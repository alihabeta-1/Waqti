enum BookingDuration {
  thirtyMinutes(minutes: 30),
  sixtyMinutes(minutes: 60),
  ninetyMinutes(minutes: 90),
  oneHundredTwentyMinutes(minutes: 120);

  const BookingDuration({required this.minutes});

  final int minutes;

  int get slotsCount => minutes ~/ 30;

  Duration get duration => Duration(minutes: minutes);
}
