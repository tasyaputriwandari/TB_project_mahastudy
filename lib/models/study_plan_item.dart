class StudyPlanItem {
  final String id;
  final String courseCode;
  final String courseName;
  final String topic;
  final String scheduledTime;
  final int durationMinutes;
  bool isCompleted;

  StudyPlanItem({
    required this.id,
    required this.courseCode,
    required this.courseName,
    required this.topic,
    required this.scheduledTime,
    required this.durationMinutes,
    this.isCompleted = false,
  });
}
