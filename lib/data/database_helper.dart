import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../models/course.dart';
import '../models/schedule_item.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  bool _isWebOrUnsupported = false;

  Future<Database?> get database async {
    if (kIsWeb) {
      _isWebOrUnsupported = true;
      return null;
    }
    if (_database != null) return _database;
    try {
      _database = await _initDatabase();
      return _database;
    } catch (e) {
      debugPrint('DatabaseHelper init error: $e');
      _isWebOrUnsupported = true;
      return null;
    }
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'mahastudy.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // 1. Tabel Mata Kuliah
    await db.execute('''
      CREATE TABLE courses (
        id TEXT PRIMARY KEY,
        code TEXT,
        name TEXT NOT NULL,
        lecturer TEXT,
        room TEXT,
        sks INTEGER DEFAULT 3
      )
    ''');

    // 2. Tabel Jadwal (Kuliah, Ujian, Kegiatan Organisasi)
    await db.execute('''
      CREATE TABLE schedules (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        subtitle TEXT,
        time TEXT NOT NULL,
        day TEXT NOT NULL,
        room TEXT NOT NULL,
        locationDetail TEXT,
        type TEXT NOT NULL,
        lecturer TEXT,
        notes TEXT,
        date TEXT,
        dateFormatted TEXT,
        examType TEXT,
        organizer TEXT,
        isNew INTEGER DEFAULT 0
      )
    ''');

    // 3. Tabel Tugas (Disediakan juga untuk integrasi modul Tugas)
    await db.execute('''
      CREATE TABLE tasks (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        courseName TEXT,
        deadline TEXT,
        priority TEXT,
        status TEXT,
        description TEXT,
        proofFileName TEXT,
        proofFileSize TEXT
      )
    ''');

    // 4. Tabel Rencana Belajar
    await db.execute('''
      CREATE TABLE study_plans (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        courseName TEXT,
        targetMinutes INTEGER,
        scheduledDate TEXT,
        isDone INTEGER DEFAULT 0
      )
    ''');

    // Seed data awal jika baru pertama kali dibuat
    await _seedInitialData(db);
  }

  Future<void> _seedInitialData(Database db) async {
    // Initial Courses
    final initialCourses = [
      {'id': 'c1', 'code': 'ST', 'name': 'Statistika', 'lecturer': 'Dr. Irwan, M.Kom', 'room': 'Ruang A.102', 'sks': 3},
      {'id': 'c2', 'code': 'PW', 'name': 'Pemrograman Web', 'lecturer': 'Ahmad Fauzi, M.T', 'room': 'Lab Komputer 2', 'sks': 4},
      {'id': 'c3', 'code': 'IMK', 'name': 'Interaksi Manusia Komputer', 'lecturer': 'Siti Rahma, M.Kom', 'room': 'Ruang C.301', 'sks': 3},
      {'id': 'c4', 'code': 'BD', 'name': 'Basis Data', 'lecturer': 'Hendra Saputra, S.T., M.Cs', 'room': 'Lab Komputer 1', 'sks': 3},
    ];
    for (final c in initialCourses) {
      await db.insert('courses', c, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Initial Schedules
    final initialSchedules = [
      {
        'id': 's1',
        'title': 'Statistika',
        'subtitle': 'Kuliah • Ruang A.102',
        'time': '09:00 - 10:40',
        'day': 'Selasa',
        'room': 'Ruang A.102',
        'locationDetail': 'Lantai 1, Sayap Barat',
        'type': 'kuliah',
        'lecturer': 'Dr. Irwan, M.Kom',
        'notes': 'Bawa modul praktikum bab 4 regresi.',
        'isNew': 0,
      },
      {
        'id': 's2',
        'title': 'Pemrograman Web',
        'subtitle': 'Kuliah • Lab Komputer 2',
        'time': '13:00 - 14:40',
        'day': 'Selasa',
        'room': 'Lab Komputer 2',
        'locationDetail': 'Lantai 2, Gedung FTI Barat',
        'type': 'kuliah',
        'lecturer': 'Ahmad Fauzi, M.T',
        'notes': 'Siapkan tugas perancangan REST API.',
        'isNew': 0,
      },
      {
        'id': 's3',
        'title': 'Basis Data',
        'subtitle': 'Kuliah • Lab Komputer 1',
        'time': '08:00 - 09:40',
        'day': 'Senin',
        'room': 'Lab Komputer 1',
        'locationDetail': 'Lantai 2, Gedung FTI Timur',
        'type': 'kuliah',
        'lecturer': 'Hendra Saputra, S.T., M.Cs',
        'notes': 'Praktikum SQL Query subquery dan indexing.',
        'isNew': 0,
      },
      {
        'id': 's4',
        'title': 'Interaksi Manusia Komputer',
        'subtitle': 'Kuliah • Ruang C.301',
        'time': '10:00 - 11:40',
        'day': 'Kamis',
        'room': 'Ruang C.301',
        'locationDetail': 'Lantai 3, Gedung Dekanat',
        'type': 'kuliah',
        'lecturer': 'Siti Rahma, M.Kom',
        'notes': 'Presentasi wireframe prototype mobile.',
        'isNew': 0,
      },
      {
        'id': 'u1',
        'title': 'Ujian Tengah Semester: Basis Data',
        'subtitle': 'UTS • Ruang B.204',
        'time': '08:00 - 10:00',
        'day': 'Senin',
        'room': 'Ruang B.204',
        'locationDetail': 'Lantai 2, Sayap Timur',
        'type': 'ujian',
        'date': '2026-10-26',
        'examType': 'UTS',
        'notes': 'Ujian tertutup. Bawa kartu ujian fisik.',
        'isNew': 0,
      },
      {
        'id': 'o1',
        'title': 'Rapat Kerja Himpunan Mahasiswa',
        'subtitle': 'Kegiatan • Ruang Seminar FTI',
        'time': '16:00 - 18:00',
        'day': 'Rabu',
        'room': 'Ruang Seminar FTI',
        'locationDetail': 'Gedung FTI Lantai 1',
        'type': 'organisasi',
        'date': '2026-10-21',
        'organizer': 'HMDSI Unand',
        'notes': 'Evaluasi proker bulan Oktober dan persiapan dies natalis.',
        'isNew': 0,
      },
    ];
    for (final s in initialSchedules) {
      await db.insert('schedules', s, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // ================= CRUD JADWAL (SCHEDULES) =================
  Future<List<ScheduleItem>> getSchedules() async {
    final db = await database;
    if (db == null) return [];

    final List<Map<String, dynamic>> maps = await db.query('schedules');
    return maps.map((m) {
      ScheduleType type = ScheduleType.kuliah;
      if (m['type'] == 'ujian') type = ScheduleType.ujian;
      if (m['type'] == 'organisasi') type = ScheduleType.organisasi;

      DateTime? parsedDate;
      if (m['date'] != null && m['date'].toString().isNotEmpty) {
        parsedDate = DateTime.tryParse(m['date'].toString());
      }

      return ScheduleItem(
        id: m['id'] as String,
        title: m['title'] as String,
        subtitle: m['subtitle'] as String? ?? '',
        time: m['time'] as String,
        day: m['day'] as String,
        room: m['room'] as String,
        locationDetail: m['locationDetail'] as String? ?? 'Kampus Utama',
        type: type,
        lecturer: m['lecturer'] as String?,
        notes: m['notes'] as String?,
        date: parsedDate,
        dateFormatted: m['dateFormatted'] as String?,
        examType: m['examType'] as String?,
        organizer: m['organizer'] as String?,
        isNew: (m['isNew'] as int? ?? 0) == 1,
      );
    }).toList();
  }

  Future<int> insertSchedule(ScheduleItem item) async {
    final db = await database;
    if (db == null) return 0;

    String typeStr = 'kuliah';
    if (item.type == ScheduleType.ujian) typeStr = 'ujian';
    if (item.type == ScheduleType.organisasi) typeStr = 'organisasi';

    return await db.insert(
      'schedules',
      {
        'id': item.id,
        'title': item.title,
        'subtitle': item.subtitle,
        'time': item.time,
        'day': item.day,
        'room': item.room,
        'locationDetail': item.locationDetail,
        'type': typeStr,
        'lecturer': item.lecturer,
        'notes': item.notes,
        'date': item.date?.toIso8601String().split('T').first,
        'dateFormatted': item.dateFormatted,
        'examType': item.examType,
        'organizer': item.organizer,
        'isNew': item.isNew ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateSchedule(ScheduleItem item) async {
    final db = await database;
    if (db == null) return 0;

    String typeStr = 'kuliah';
    if (item.type == ScheduleType.ujian) typeStr = 'ujian';
    if (item.type == ScheduleType.organisasi) typeStr = 'organisasi';

    return await db.update(
      'schedules',
      {
        'title': item.title,
        'subtitle': item.subtitle,
        'time': item.time,
        'day': item.day,
        'room': item.room,
        'locationDetail': item.locationDetail,
        'type': typeStr,
        'lecturer': item.lecturer,
        'notes': item.notes,
        'date': item.date?.toIso8601String().split('T').first,
        'dateFormatted': item.dateFormatted,
        'examType': item.examType,
        'organizer': item.organizer,
        'isNew': item.isNew ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }

  Future<int> deleteSchedule(String id) async {
    final db = await database;
    if (db == null) return 0;
    return await db.delete('schedules', where: 'id = ?', whereArgs: [id]);
  }

  // ================= CRUD MATA KULIAH (COURSES) =================
  Future<List<Course>> getCourses() async {
    final db = await database;
    if (db == null) return [];

    final List<Map<String, dynamic>> maps = await db.query('courses');
    return maps.map((m) {
      return Course(
        id: m['id'] as String,
        code: m['code'] as String? ?? 'MK',
        name: m['name'] as String,
        lecturer: m['lecturer'] as String? ?? '',
        room: m['room'] as String? ?? '',
        sks: m['sks'] as int? ?? 3,
      );
    }).toList();
  }

  Future<int> insertCourse(Course course) async {
    final db = await database;
    if (db == null) return 0;

    return await db.insert(
      'courses',
      {
        'id': course.id,
        'code': course.code,
        'name': course.name,
        'lecturer': course.lecturer,
        'room': course.room,
        'sks': course.sks,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> updateCourse(Course course) async {
    final db = await database;
    if (db == null) return 0;

    return await db.update(
      'courses',
      {
        'code': course.code,
        'name': course.name,
        'lecturer': course.lecturer,
        'room': course.room,
        'sks': course.sks,
      },
      where: 'id = ?',
      whereArgs: [course.id],
    );
  }

  Future<int> deleteCourse(String id) async {
    final db = await database;
    if (db == null) return 0;
    return await db.delete('courses', where: 'id = ?', whereArgs: [id]);
  }
}
