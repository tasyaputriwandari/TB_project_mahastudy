import 'package:flutter/material.dart';

class StudyPlan {
  const StudyPlan({
    required this.course,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.target,
    this.status = 'Sesi belajar mandiri',
  });

  final String course;
  final DateTime date;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String target;
  final String status;

  String get formattedDate => formatDate(date);

  String get formattedTime =>
      '${_formatTime(startTime)} – ${_formatTime(endTime)}';

  static String formatDate(DateTime date) =>
      '${date.day} ${_monthName(date.month)} ${date.year}';

  static String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}';

  static String _monthName(int month) => const [
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
  ][month - 1];
}
