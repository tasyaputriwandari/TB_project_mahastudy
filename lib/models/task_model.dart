import 'package:flutter/material.dart';

/// Status pengerjaan tugas kuliah
enum TaskStatus {
  aktif,
  selesai,
  terlewat,
}

/// Tingkat prioritas tugas
enum TaskPriority {
  tinggi,
  sedang,
  rendah,
}

/// Model data utama untuk Tugas Mahastudy
class Task {
  final String id;
  final String title;
  final String course;
  final DateTime deadline;
  final TaskPriority priority;
  final String? notes;
  final TaskStatus status;
  final bool isNew;

  const Task({
    required this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.priority,
    this.notes,
    this.status = TaskStatus.aktif,
    this.isNew = false,
  });

  /// Alias getter agar task.courseName dan task.course dua-duanya valid
  String get courseName => course;

  /// Getter untuk mendeteksi deadline aktif yang tersisa kurang dari 24 jam
  bool get isRiskAlert {
    if (status != TaskStatus.aktif) return false;
    final now = DateTime.now();
    final difference = deadline.difference(now);
    return !difference.isNegative && difference.inHours < 24;
  }

  /// Label prioritas
  String get priorityLabel {
    switch (priority) {
      case TaskPriority.tinggi:
        return 'Tinggi';
      case TaskPriority.sedang:
        return 'Sedang';
      case TaskPriority.rendah:
        return 'Rendah';
    }
  }

  /// Warna teks prioritas
  Color get priorityColor {
    switch (priority) {
      case TaskPriority.tinggi:
        return const Color(0xFFDC2626); // Merah
      case TaskPriority.sedang:
        return const Color(0xFFD97706); // Amber
      case TaskPriority.rendah:
        return const Color(0xFF16A34A); // Hijau
    }
  }

  /// Warna latar chip prioritas
  Color get priorityBackgroundColor {
    switch (priority) {
      case TaskPriority.tinggi:
        return const Color(0xFFFEE2E2);
      case TaskPriority.sedang:
        return const Color(0xFFFEF3C7);
      case TaskPriority.rendah:
        return const Color(0xFFDCFCE7);
    }
  }

  Task copyWith({
    String? id,
    String? title,
    String? course,
    DateTime? deadline,
    TaskPriority? priority,
    String? notes,
    TaskStatus? status,
    bool? isNew,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      isNew: isNew ?? this.isNew,
    );
  }
}
