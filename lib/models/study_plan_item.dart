class StudyPlanItem {
  final String id;
  final String courseCode;
  final String courseName;
  final String topic;
  final String scheduledTime;
  final int durationMinutes;
  int completedMinutes;
  bool isCompleted;
  final String notes;

  StudyPlanItem({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.topic,
    required this.scheduledTime,
    required this.durationMinutes,
    this.completedMinutes = 0,
    this.isCompleted = false,
    this.notes = '',
  });

  double get progress => durationMinutes > 0
      ? (completedMinutes / durationMinutes).clamp(0.0, 1.0)
      : 0.0;

  int get progressPersen => (progress * 100).toInt();

  StudyPlanItem copyWith({
    String? id,
    String? courseCode,
    String? courseName,
    String? topic,
    String? scheduledTime,
    int? durationMinutes,
    int? completedMinutes,
    bool? isCompleted,
    String? notes,
  }) {
    return StudyPlanItem(
      id: id ?? this.id,
      courseCode: courseCode ?? this.courseCode,
      courseName: courseName ?? this.courseName,
      topic: topic ?? this.topic,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      completedMinutes: completedMinutes ?? this.completedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      notes: notes ?? this.notes,
    );
  }
}
