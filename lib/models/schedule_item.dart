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
  final bool isNew;

  const ScheduleItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.day,
    required this.room,
    this.locationDetail = 'Lantai 1, Sayap Barat',
    this.type = ScheduleType.kuliah,
    this.isNew = false,
  });

  ScheduleItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? time,
    String? day,
    String? room,
    String? locationDetail,
    ScheduleType? type,
    bool? isNew,
  }) {
    return ScheduleItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      day: day ?? this.day,
      room: room ?? this.room,
      locationDetail: locationDetail ?? this.locationDetail,
      type: type ?? this.type,
      isNew: isNew ?? this.isNew,
    );
  }
}
