enum TaskPriority { tinggi, sedang, rendah }
enum TaskStatus { belum, proses, selesai }

class TaskItem {
  final String id;
  final String courseId;
  final String courseName;
  final String title;
  final String deadlineText;
  final DateTime deadline;
  final TaskPriority priority;
  TaskStatus status;
  final String notes;
  final bool isRiskAlert;
  String? proofFileName;
  String? proofFileSize;

  TaskItem({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.title,
    required this.deadlineText,
    required this.deadline,
    this.priority = TaskPriority.sedang,
    this.status = TaskStatus.belum,
    this.notes = '',
    this.isRiskAlert = false,
    this.proofFileName,
    this.proofFileSize,
  });

  String get priorityLabel {
    switch (priority) {
      case TaskPriority.tinggi:
        return 'Prioritas Tinggi';
      case TaskPriority.sedang:
        return 'Prioritas Sedang';
      case TaskPriority.rendah:
        return 'Prioritas Rendah';
    }
  }

  String get statusLabel {
    switch (status) {
      case TaskStatus.belum:
        return 'Belum dikerjakan';
      case TaskStatus.proses:
        return 'Sedang dikerjakan';
      case TaskStatus.selesai:
        return 'Selesai';
    }
  }
}
