class Course {
  final String id;
  final String code;
  final String name;
  final String lecturer;
  final String room;
  final int sks;

  const Course({
    required this.id,
    required this.code,
    required this.name,
    required this.lecturer,
    required this.room,
    this.sks = 3,
  });

  Course copyWith({
    String? id,
    String? code,
    String? name,
    String? lecturer,
    String? room,
    int? sks,
  }) {
    return Course(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      lecturer: lecturer ?? this.lecturer,
      room: room ?? this.room,
      sks: sks ?? this.sks,
    );
  }
}
