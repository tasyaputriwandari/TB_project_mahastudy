import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/schedule_item.dart';
import '../models/task_item.dart';
import '../models/study_plan_item.dart';
import '../models/user_model.dart';

class MockUserAccount {
  final UserModel user;
  final String password;

  const MockUserAccount({
    required this.user,
    required this.password,
  });
}

class MockData extends ChangeNotifier {
  static final MockData _instance = MockData._internal();
  factory MockData() => _instance;
  MockData._internal();

  final List<MockUserAccount> _registeredUsers = [
    const MockUserAccount(
      user: UserModel(
        id: 'u1',
        name: 'Nadia',
        email: 'nadia@mahasiswa.ac.id',
        major: 'Informatika',
      ),
      password: 'password123',
    ),
  ];

  List<MockUserAccount> get registeredUsers => List.unmodifiable(_registeredUsers);

  MockUserAccount? findAccount(String identifier) {
    final clean = identifier.trim().toLowerCase();
    if (clean.isEmpty) return null;
    try {
      return _registeredUsers.firstWhere(
        (acc) =>
            acc.user.email.toLowerCase() == clean ||
            acc.user.name.toLowerCase() == clean,
      );
    } catch (_) {
      return null;
    }
  }

  bool isAccountRegistered(String identifier) {
    return findAccount(identifier) != null;
  }

  void registerUser(UserModel user, String password) {
    _registeredUsers.removeWhere((acc) =>
        acc.user.email.toLowerCase() == user.email.toLowerCase() ||
        acc.user.name.toLowerCase() == user.name.toLowerCase());
    _registeredUsers.add(MockUserAccount(user: user, password: password));
    currentUser = user;
    notifyListeners();
  }

  UserModel currentUser = const UserModel(
    id: 'u1',
    name: 'Nadia',
    email: 'nadia@mahasiswa.ac.id',
    major: 'Informatika',
  );

  bool isUserLoggedIn = true;
  bool showEmptyState = false; // Toggle to view populated vs empty state

  final List<Course> courses = [
    const Course(id: 'c1', code: 'ST', name: 'Statistika', lecturer: 'Dr. Irwan, M.Kom', room: 'Ruang A.102'),
    const Course(id: 'c2', code: 'PW', name: 'Pemrograman Web', lecturer: 'Ahmad Fauzi, M.T', room: 'Lab Komputer 2'),
    const Course(id: 'c3', code: 'IMK', name: 'Interaksi Manusia Komputer', lecturer: 'Siti Rahma, M.Kom', room: 'Ruang C.301'),
    const Course(id: 'c4', code: 'BD', name: 'Basis Data', lecturer: 'Hendra Saputra, S.T., M.Cs', room: 'Lab Komputer 1'),
  ];

  final List<ScheduleItem> schedules = [
    const ScheduleItem(
      id: 's1',
      title: 'Statistika',
      subtitle: 'Kuliah • Ruang A.102',
      time: '09:00 - 10:40',
      day: 'Selasa',
      room: 'Ruang A.102',
      locationDetail: 'Lantai 1, Sayap Barat',
      type: ScheduleType.kuliah,
    ),
    const ScheduleItem(
      id: 's2',
      title: 'Pemrograman Web',
      subtitle: 'Kuliah • Lab Komputer 2',
      time: '13:00 - 14:40',
      day: 'Selasa',
      room: 'Lab Komputer 2',
      locationDetail: 'Lantai 2, Gedung FTI Barat',
      type: ScheduleType.kuliah,
    ),
    const ScheduleItem(
      id: 's3',
      title: 'Basis Data',
      subtitle: 'Kuliah • Lab Komputer 1',
      time: '08:00 - 09:40',
      day: 'Senin',
      room: 'Lab Komputer 1',
      locationDetail: 'Lantai 2, Gedung FTI Timur',
      type: ScheduleType.kuliah,
    ),
    const ScheduleItem(
      id: 's4',
      title: 'Interaksi Manusia Komputer',
      subtitle: 'Kuliah • Ruang C.301',
      time: '10:00 - 11:40',
      day: 'Rabu',
      room: 'Ruang C.301',
      locationDetail: 'Lantai 3, Gedung Utama',
      type: ScheduleType.kuliah,
    ),
    const ScheduleItem(
      id: 's5',
      title: 'UTS Statistika',
      subtitle: 'Ujian Tengah Semester',
      time: '08:00 - 10:00',
      day: 'Senin',
      room: 'Ruang B.201',
      locationDetail: 'Lantai 2, Sayap Timur',
      type: ScheduleType.ujian,
    ),
    const ScheduleItem(
      id: 's6',
      title: 'Rapat BEM',
      subtitle: 'Kegiatan Organisasi Kampus',
      time: '16:00 - 17:30',
      day: 'Selasa',
      room: 'Sekretariat BEM',
      locationDetail: 'Gedung Pusat Kegiatan Mahasiswa Lt. 1',
      type: ScheduleType.organisasi,
    ),
  ];

  final List<TaskItem> tasks = [
    TaskItem(
      id: 't1',
      courseId: 'c1',
      courseName: 'Statistika',
      title: 'Laporan praktikum Statistika',
      deadlineText: 'Hari ini, 20:00',
      deadline: DateTime.now().add(const Duration(hours: 8)),
      priority: TaskPriority.tinggi,
      status: TaskStatus.belum,
      notes: 'Analisis regresi linier berganda dan lampirkan output SPSS.',
      isRiskAlert: true,
      proofFileName: 'Bukti_Statistika.jpg',
      proofFileSize: '1.2 MB • Foto dokumen',
    ),
    TaskItem(
      id: 't2',
      courseId: 'c3',
      courseName: 'Interaksi Manusia Komputer',
      title: 'Review presentasi IMK',
      deadlineText: 'Besok, 23:59',
      deadline: DateTime.now().add(const Duration(days: 1)),
      priority: TaskPriority.sedang,
      status: TaskStatus.proses,
      notes: 'Review slide evaluasi heuristik 10 Nielsen.',
      isRiskAlert: false,
    ),
    TaskItem(
      id: 't3',
      courseId: 'c4',
      courseName: 'Basis Data',
      title: 'Tugas Relasi Tabel',
      deadlineText: 'Jumat, 14:00',
      deadline: DateTime.now().add(const Duration(days: 3)),
      priority: TaskPriority.rendah,
      status: TaskStatus.belum,
      notes: 'Buat diagram ERD relasi foreign key dan script SQL DDL.',
      isRiskAlert: false,
    ),
    TaskItem(
      id: 't4',
      courseId: 'c2',
      courseName: 'Pemrograman Web',
      title: 'Tugas 1 Slicing UI CSS',
      deadlineText: 'Kemarin, 23:59',
      deadline: DateTime.now().subtract(const Duration(days: 1)),
      priority: TaskPriority.sedang,
      status: TaskStatus.selesai,
      notes: 'Slicing layout dashboard responsif.',
      isRiskAlert: false,
      proofFileName: 'Bukti_Slicing.png',
      proofFileSize: '2.4 MB • Screenshot',
    ),
  ];

  final List<StudyPlanItem> studyPlans = [
    StudyPlanItem(
      id: 'sp1',
      courseCode: 'PW',
      courseName: 'Pemrograman Web',
      topic: 'Slicing UI & Navigasi',
      scheduledTime: 'Hari ini, 19:30',
      durationMinutes: 45,
    ),
    StudyPlanItem(
      id: 'sp2',
      courseCode: 'ST',
      courseName: 'Statistika',
      topic: 'Latihan Bab 4',
      scheduledTime: 'Besok, 14:00',
      durationMinutes: 60,
    ),
    StudyPlanItem(
      id: 'sp3',
      courseCode: 'BD',
      courseName: 'Basis Data',
      topic: 'Normalisasi Database',
      scheduledTime: 'Kamis, 16:00',
      durationMinutes: 50,
    ),
  ];

  // Helper methods to update state
  void addTask(TaskItem task) {
    tasks.insert(0, task);
    notifyListeners();
  }

  void markTaskComplete(String taskId, String fileName, String fileSize) {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      tasks[index].status = TaskStatus.selesai;
      tasks[index].proofFileName = fileName;
      tasks[index].proofFileSize = fileSize;
      notifyListeners();
    }
  }

  void addStudyPlan(StudyPlanItem plan) {
    studyPlans.add(plan);
    notifyListeners();
  }

  void toggleEmptyState() {
    showEmptyState = !showEmptyState;
    notifyListeners();
  }
}
