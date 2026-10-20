import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/notification_item.dart';
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
    const Course(id: 'c1', code: 'ST', name: 'Statistika', lecturer: 'Dr. Irwan, M.Kom', room: 'Ruang A.102', sks: 3),
    const Course(id: 'c2', code: 'PW', name: 'Pemrograman Web', lecturer: 'Ahmad Fauzi, M.T', room: 'Lab Komputer 2', sks: 4),
    const Course(id: 'c3', code: 'IMK', name: 'Interaksi Manusia Komputer', lecturer: 'Siti Rahma, M.Kom', room: 'Ruang C.301', sks: 3),
    const Course(id: 'c4', code: 'BD', name: 'Basis Data', lecturer: 'Hendra Saputra, S.T., M.Cs', room: 'Lab Komputer 1', sks: 3),
  ];

  final List<ScheduleItem> schedules = [
    ScheduleItem(
      id: 's1',
      title: 'Statistika',
      subtitle: 'Kuliah • Ruang A.102',
      time: '09:00 - 10:40',
      day: 'Selasa',
      room: 'Ruang A.102',
      locationDetail: 'Lantai 1, Sayap Barat',
      type: ScheduleType.kuliah,
      lecturer: 'Dr. Irwan, M.Kom',
      notes: 'Bawa modul praktikum bab 4 regresi.',
    ),
    ScheduleItem(
      id: 's2',
      title: 'Pemrograman Web',
      subtitle: 'Kuliah • Lab Komputer 2',
      time: '13:00 - 14:40',
      day: 'Selasa',
      room: 'Lab Komputer 2',
      locationDetail: 'Lantai 2, Gedung FTI Barat',
      type: ScheduleType.kuliah,
      lecturer: 'Ahmad Fauzi, M.T',
      notes: 'Lanjutan materi Flutter state management.',
    ),
    ScheduleItem(
      id: 's3',
      title: 'Basis Data',
      subtitle: 'Kuliah • Lab Komputer 1',
      time: '08:00 - 09:40',
      day: 'Senin',
      room: 'Lab Komputer 1',
      locationDetail: 'Lantai 2, Gedung FTI Timur',
      type: ScheduleType.kuliah,
      lecturer: 'Hendra Saputra, S.T., M.Cs',
    ),
    ScheduleItem(
      id: 's4',
      title: 'Interaksi Manusia Komputer',
      subtitle: 'Kuliah • Ruang C.301',
      time: '10:00 - 11:40',
      day: 'Rabu',
      room: 'Ruang C.301',
      locationDetail: 'Lantai 3, Gedung Utama',
      type: ScheduleType.kuliah,
      lecturer: 'Siti Rahma, M.Kom',
    ),
    ScheduleItem(
      id: 's5',
      title: 'UTS Statistika',
      subtitle: 'Ujian Tengah Semester',
      time: '08:00 - 10:00',
      day: 'Senin',
      room: 'Ruang B.201',
      locationDetail: 'Lantai 2, Sayap Timur',
      type: ScheduleType.ujian,
      date: DateTime.now().add(const Duration(days: 2)),
      dateFormatted: 'Senin, 20 Oktober 2026',
      examType: 'UTS',
      notes: 'Wajib membawa kalkulator scientific & KTM fisik.',
    ),
    ScheduleItem(
      id: 's5b',
      title: 'Kuis Pemrograman Web',
      subtitle: 'Kuis Praktikum Online',
      time: '13:00 - 14:00',
      day: 'Rabu',
      room: 'Lab Komputer 2',
      locationDetail: 'Lantai 2, Gedung FTI Barat',
      type: ScheduleType.ujian,
      date: DateTime.now().add(const Duration(days: 4)),
      dateFormatted: 'Rabu, 22 Oktober 2026',
      examType: 'Kuis',
      notes: 'Materi seputar REST API dan Model Data.',
    ),
    ScheduleItem(
      id: 's6',
      title: 'Rapat BEM FTI',
      subtitle: 'Kegiatan Organisasi Kampus',
      time: '16:00 - 17:30',
      day: 'Selasa',
      room: 'Sekretariat BEM',
      locationDetail: 'Gedung Pusat Kegiatan Mahasiswa Lt. 1',
      type: ScheduleType.organisasi,
      date: DateTime.now().add(const Duration(days: 1)),
      dateFormatted: 'Selasa, 14 Oktober 2026',
      organizer: 'BEM FTI',
      notes: 'Pembahasan persiapan Dies Natalis dan proposal sponsorship.',
    ),
    ScheduleItem(
      id: 's6b',
      title: 'Workshop Flutter HIMATIF',
      subtitle: 'Seminar & Hands-on Coding',
      time: '09:00 - 12:00',
      day: 'Sabtu',
      room: 'Auditorium Kampus Utama',
      locationDetail: 'Gedung Rektorat Lt. 4',
      type: ScheduleType.organisasi,
      date: DateTime.now().add(const Duration(days: 6)),
      dateFormatted: 'Sabtu, 25 Oktober 2026',
      organizer: 'HIMATIF',
      notes: 'Harap membawa laptop yang telah terinstall Flutter SDK.',
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
      courseId: 'c2',
      courseName: 'Pemrograman Web',
      title: 'Tugas slicing halaman Profile',
      deadlineText: '3 hari lagi',
      deadline: DateTime.now().add(const Duration(days: 3)),
      priority: TaskPriority.rendah,
      status: TaskStatus.belum,
      notes: 'Gunakan Flutter StatelessWidget & theme system.',
      isRiskAlert: false,
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

  final List<NotificationItem> notifications = [
    NotificationItem(
      id: 'n1',
      title: 'Pengingat Kuliah: Statistika',
      message: 'Kuliah Statistika dimulai dalam 30 menit di Ruang A.102.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      category: NotificationCategory.kuliah,
      isRead: false,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Peringatan Deadline Tugas',
      message: 'Laporan praktikum Statistika batas pengumpulan malam ini pukul 20:00 WIB.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      category: NotificationCategory.tugas,
      isRead: false,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Jadwal Ujian Mendatang',
      message: 'UTS Statistika dijadwalkan pada Senin, 20 Oktober di Ruang B.201.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      category: NotificationCategory.ujian,
      isRead: true,
    ),
    NotificationItem(
      id: 'n4',
      title: 'Undangan Rapat BEM',
      message: 'Rapat koordinasi BEM FTI besok Selasa pukul 16:00 di Sekretariat.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      category: NotificationCategory.organisasi,
      isRead: true,
    ),
    NotificationItem(
      id: 'n5',
      title: 'Sesi Belajar Mahastudy',
      message: 'Sesi belajar Slicing UI & Navigasi dijadwalkan pukul 19:30 nanti malam.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      category: NotificationCategory.belajar,
      isRead: true,
    ),
  ];

  // Helper methods for Course Management
  void addCourse(Course course) {
    courses.add(course);
    notifyListeners();
  }

  void updateCourse(Course updated) {
    final index = courses.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      courses[index] = updated;
      notifyListeners();
    }
  }

  void deleteCourse(String id) {
    courses.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // Helper methods for Schedule Management
  void addSchedule(ScheduleItem item) {
    schedules.add(item);
    notifyListeners();
  }

  void updateSchedule(ScheduleItem updated) {
    final index = schedules.indexWhere((s) => s.id == updated.id);
    if (index != -1) {
      schedules[index] = updated;
      notifyListeners();
    }
  }

  void deleteSchedule(String id) {
    schedules.removeWhere((s) => s.id == id);
    notifyListeners();
  }

  // Helper methods for Notifications
  void markNotificationAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifyListeners();
    }
  }

  void markAllNotificationsAsRead() {
    for (int i = 0; i < notifications.length; i++) {
      notifications[i] = notifications[i].copyWith(isRead: true);
    }
    notifyListeners();
  }

  int get unreadNotificationCount => notifications.where((n) => !n.isRead).length;

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

  void updateStudyPlan(StudyPlanItem updated) {
    final index = studyPlans.indexWhere((p) => p.id == updated.id);
    if (index != -1) {
      studyPlans[index] = updated;
      notifyListeners();
    }
  }

  void deleteStudyPlan(String id) {
    studyPlans.removeWhere((p) => p.id == id);
    notifyListeners();
  }

  void toggleEmptyState() {
    showEmptyState = !showEmptyState;
    notifyListeners();
  }
}
