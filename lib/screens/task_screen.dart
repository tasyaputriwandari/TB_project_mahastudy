import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/date_formatter.dart';
import 'add_task_screen.dart';

/// Screen Daftar Tugas Kuliah (Screen 1 & Screen 5).
/// Mempertahankan 100% struktur UI asli:
/// - Header logo kotak Mahastudy & notifikasi lonceng
/// - Judul "Tugas Kuliah" & Subteks dinamis
/// - Filter Tabs (Aktif, Selesai, Terlewat) lengkap dengan badge jumlah
/// - Kartu tugas asli dengan badge Prioritas, badge Risiko < 24 jam, dan badge "Baru"
/// - Tombol utama full-width "+ Tambah Tugas" (Tanda plus tunggal yang rapi)
/// - Bottom Navigation Bar (5 menu)
/// - Palet warna aksen biru: #2867E8
class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  // ==========================================
  // [STATE] - Data Daftar Tugas & Filter Status
  // ==========================================
  TaskStatus _selectedFilter = TaskStatus.aktif;
  int _currentBottomNavIndex = 2; // Tab "Tugas" aktif secara default

  /// Tiga dummy task awal agar daftar dan filter bisa langsung diuji
  late List<Task> _tasks;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();

    _tasks = [
      Task(
        id: '1',
        title: 'Review Jurnal Cloud Computing',
        course: 'Pemrograman Web',
        // Deadline 18 jam ke depan -> Menguji getter `isRiskAlert` (< 24 jam)
        deadline: now.add(const Duration(hours: 18)),
        priority: TaskPriority.tinggi,
        notes: 'Fokus pada arsitektur serverless AWS & GCP',
        status: TaskStatus.aktif,
      ),
      Task(
        id: '2',
        title: 'Desain Wireframe UI/UX Mahastudy',
        course: 'Pemrograman Teknologi Bergerak',
        deadline: now.add(const Duration(days: 3, hours: 4)),
        priority: TaskPriority.sedang,
        notes: 'Gunakan referensi layout 360x800 px',
        status: TaskStatus.aktif,
      ),
      Task(
        id: '3',
        title: 'Latihan Soal Query Relasional',
        course: 'Basis Data',
        deadline: now.add(const Duration(days: 5, hours: 2)),
        priority: TaskPriority.rendah,
        notes: 'Kerjakan soal modul 4 sampai 6',
        status: TaskStatus.aktif,
      ),
      // Contoh tugas untuk tab "Selesai" dan "Terlewat"
      Task(
        id: '4',
        title: 'Instalasi Flutter SDK & Android Studio',
        course: 'Pemrograman Teknologi Bergerak',
        deadline: now.subtract(const Duration(days: 2)),
        priority: TaskPriority.tinggi,
        status: TaskStatus.selesai,
      ),
      Task(
        id: '5',
        title: 'Resume Pengantar Kecerdasan Buatan',
        course: 'Kecerdasan Buatan',
        deadline: now.subtract(const Duration(days: 4)),
        priority: TaskPriority.sedang,
        status: TaskStatus.terlewat,
      ),
    ];
  }

  int get _activeTaskCount =>
      _tasks.where((t) => t.status == TaskStatus.aktif).length;

  List<Task> get _filteredTasks =>
      _tasks.where((t) => t.status == _selectedFilter).toList();

  List<Task> get _urgentTasks =>
      _tasks.where((t) => t.isRiskAlert).toList();

  // ==========================================
  // [INPUT/EVENT] & [NAVIGATION] - Tambah Tugas Baru
  // ==========================================
  Future<void> _navigateToAddTask() async {
    final newTask = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddTaskScreen(),
      ),
    );

    if (!mounted || newTask == null) return;

    // [STATE] Menambahkan task baru ke urutan teratas tab "Aktif"
    setState(() {
      _tasks.insert(0, newTask);
      _selectedFilter = TaskStatus.aktif;
    });

    // [FEEDBACK] Menampilkan SnackBar konfirmasi
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Tugas '${newTask.title}' berhasil ditambahkan ke daftar.",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'Tutup',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  // ==========================================
  // [INPUT/EVENT] - Modal Notifikasi Deadline Mendesak
  // ==========================================
  void _showNotificationDialog() {
    final urgentList = _urgentTasks;
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: Color(0xFFDC2626),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Pengingat Deadline',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF172B4D),
                  ),
                ),
              ),
            ],
          ),
          content: urgentList.isEmpty
              ? const Text(
                  'Bagus! Tidak ada tugas aktif dengan deadline mendesak (< 24 jam).',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64758D),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Terdapat ${urgentList.length} tugas yang harus segera diselesaikan:',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF172B4D),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...urgentList.map((task) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF1F2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFECDD3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.warning_amber_rounded,
                                color: Color(0xFFDC2626),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF991B1B),
                                      ),
                                    ),
                                    Text(
                                      '${task.course} • Deadline: ${IndonesianDateFormatter.formatShortWithTime(task.deadline)}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFFB91C1C),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Mengerti',
                style: TextStyle(
                  color: Color(0xFF2867E8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _activeTaskCount;
    final subtitleText = activeCount > 3
        ? '$activeCount tugas aktif • Yuk, selesaikan satu per satu.'
        : '$activeCount tugas aktif • Kelola prioritas dan deadline';

    final filteredList = _filteredTasks;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      // ==========================================
      // APP BAR: Logo Mahastudy & Bell Notifikasi
      // ==========================================
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF4FF),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleSpacing: 16,
        title: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF2867E8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2867E8).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Mahastudy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF172B4D),
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                IconButton(
                  onPressed: _showNotificationDialog,
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF172B4D),
                    size: 24,
                  ),
                  tooltip: 'Notifikasi Deadline',
                ),
                if (_urgentTasks.isNotEmpty)
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),

      // ==========================================
      // BODY: Konten Daftar Tugas
      // ==========================================
      body: SafeArea(
        child: Column(
          children: [
            // Header Judul Screen & Subteks
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tugas Kuliah',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF172B4D),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitleText,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF64758D),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            // Tab Filter Status: Aktif, Selesai, Terlewat
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    _buildFilterTab(
                      label: 'Aktif',
                      status: TaskStatus.aktif,
                      count: _tasks.where((t) => t.status == TaskStatus.aktif).length,
                    ),
                    _buildFilterTab(
                      label: 'Selesai',
                      status: TaskStatus.selesai,
                      count: _tasks.where((t) => t.status == TaskStatus.selesai).length,
                    ),
                    _buildFilterTab(
                      label: 'Terlewat',
                      status: TaskStatus.terlewat,
                      count: _tasks.where((t) => t.status == TaskStatus.terlewat).length,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Daftar Kartu Tugas
            Expanded(
              child: filteredList.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final task = filteredList[index];
                        return _buildTaskCard(task);
                      },
                    ),
            ),

            // Tombol Aksi Utama Full-Width: "+ Tambah Tugas"
            // Menggunakan teks tunggal tanpa duplikasi ikon
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2867E8),
                    foregroundColor: Colors.white,
                    elevation: 2,
                    shadowColor: const Color(0xFF2867E8).withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _navigateToAddTask,
                  child: const Text(
                    '+ Tambah Tugas',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ==========================================
      // BOTTOM NAVIGATION BAR
      // 5 Item: Home, Jadwal, Tugas (Aktif), Belajar, Profil
      // ==========================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          setState(() {
            _currentBottomNavIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF2867E8),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedFontSize: 12,
        unselectedFontSize: 11,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today_rounded),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Tugas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book_rounded),
            label: 'Belajar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab({
    required String label,
    required TaskStatus status,
    required int count,
  }) {
    final isSelected = _selectedFilter == status;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedFilter = status;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2867E8) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : const Color(0xFF64758D),
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withOpacity(0.25)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : const Color(0xFF64758D),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: task.isNew
              ? const Color(0xFF2867E8)
              : task.isRiskAlert
                  ? const Color(0xFFFECDD3)
                  : const Color(0xFFE2E8F0),
          width: task.isNew ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu: Mata Kuliah & Badges
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  task.course,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2867E8),
                  ),
                ),
              ),
              // Badge "Baru" untuk tugas yang baru ditambahkan
              if (task.isNew) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2867E8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Baru',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              // Badge Prioritas
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: task.priorityBackgroundColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  task.priorityLabel,
                  style: TextStyle(
                    color: task.priorityColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Judul Tugas
          Text(
            task.title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF172B4D),
            ),
          ),

          // Catatan jika tersedia
          if (task.notes != null && task.notes!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              task.notes!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF64758D),
              ),
            ),
          ],

          const SizedBox(height: 10),

          // Footer: Batas Waktu & Peringatan Risiko
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: task.isRiskAlert
                    ? const Color(0xFFDC2626)
                    : const Color(0xFF64758D),
              ),
              const SizedBox(width: 5),
              Text(
                IndonesianDateFormatter.formatShortDate(task.deadline),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: task.isRiskAlert ? FontWeight.bold : FontWeight.w500,
                  color: task.isRiskAlert
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF64758D),
                ),
              ),
              if (task.isRiskAlert) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 12, color: Color(0xFFDC2626)),
                      SizedBox(width: 3),
                      Text(
                        '< 24 Jam!',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.assignment_turned_in_outlined,
                size: 48,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tidak ada tugas pada kategori ini',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF172B4D),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Gunakan tombol di bawah untuk menambahkan tugas baru.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64758D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
