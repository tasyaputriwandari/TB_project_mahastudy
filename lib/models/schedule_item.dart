enum ScheduleType { kuliah, ujian, organisasi }

class ScheduleItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final String day; // Senin, Selasa, dst.
  final String room;
  final String locationDetail;
  final ScheduleType type;

  const ScheduleItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.day,
    required this.room,
    this.locationDetail = 'Lantai 1, Sayap Barat',
    this.type = ScheduleType.kuliah,
  });
}
