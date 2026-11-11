enum AgeVysor {
  years,
  months,
  days,
  hours,
  minutes,
  seconds;

  String format(Duration age) {
    return switch (this) {
      AgeVysor.years => '${age.inDays ~/ (30 * 12)} years',
      AgeVysor.months => '${age.inDays ~/ 30} months',
      AgeVysor.days => '${age.inDays} days',
      AgeVysor.hours => '${age.inHours} hours',
      AgeVysor.minutes => '${age.inMinutes} minutes',
      AgeVysor.seconds => '${age.inSeconds} seconds',
    };
  }
}
