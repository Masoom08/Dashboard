class DateFilterUtil {
  static bool isInToday(DateTime date) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));
    return date.isAfter(startOfDay.subtract(const Duration(milliseconds: 1))) &&
        date.isBefore(endOfDay.add(const Duration(milliseconds: 1)));
  }

  static bool isInThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day).subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    return date.isAfter(startOfWeek.subtract(const Duration(milliseconds: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(milliseconds: 1)));
  }

  static bool isInThisMonth(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && now.month == date.month;
  }

  static bool isInHalfYear(DateTime date) {
    final now = DateTime.now();
    final sixMonthsAgo = DateTime(now.year, now.month - 6, now.day);
    return date.isAfter(sixMonthsAgo.subtract(const Duration(milliseconds: 1)));
  }

  static bool isInThisYear(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year;
  }
}
