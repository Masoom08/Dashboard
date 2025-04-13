class DateFilterUtil {
  static bool isInToday(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && now.month == date.month && now.day == date.day;
  }

  static bool isInThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(Duration(seconds: 1))) &&
        date.isBefore(endOfWeek.add(Duration(days: 1)));
  }

  static bool isInThisMonth(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year && now.month == date.month;
  }

  static bool isInHalfYear(DateTime date) {
    final now = DateTime.now();
    final sixMonthsAgo = now.subtract(Duration(days: 180));
    return date.isAfter(sixMonthsAgo);
  }

  static bool isInThisYear(DateTime date) {
    final now = DateTime.now();
    return now.year == date.year;
  }
}
