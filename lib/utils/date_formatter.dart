/// Utility helper untuk memformat tanggal dan waktu dalam Bahasa Indonesia
/// tanpa ketergantungan library eksternal.
class IndonesianDateFormatter {
  static const List<String> _monthsFull = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const List<String> _monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  /// Format: 24 Oktober 2026 • 23:59 WIB
  static String formatFullWithTime(DateTime dt) {
    final day = dt.day;
    final month = _monthsFull[dt.month - 1];
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day $month $year • $hour:$minute WIB';
  }

  /// Format: 24 Okt 2026 • 23:59 WIB
  static String formatShortWithTime(DateTime dt) {
    final day = dt.day;
    final month = _monthsShort[dt.month - 1];
    final year = dt.year;
    final hour = dt.hour.toString().padLeft(2, '0');
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$day $month $year • $hour:$minute WIB';
  }

  /// Format tanggal pendek saja: 24 Okt 2026
  static String formatShortDate(DateTime dt) {
    final day = dt.day;
    final month = _monthsShort[dt.month - 1];
    final year = dt.year;
    return '$day $month $year';
  }
}

