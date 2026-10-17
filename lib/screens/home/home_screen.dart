import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/agenda_timeline_card.dart';
import '../../widgets/deadline_risk_banner.dart';
import '../../widgets/quick_action_card.dart';
import '../../widgets/stat_badge.dart';
import '../tugas/detail_tugas_screen.dart';
import '../jadwal/detail_jadwal_screen.dart';
import '../jadwal/smart_agenda_screen.dart';
import '../notifikasi/notifikasi_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onNavigateTab;

  const HomeScreen({
    super.key,
    required this.onNavigateTab,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MockData _mockData = MockData();

  @override
  void initState() {
    super.initState();
    _mockData.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _mockData.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (_mockData.showEmptyState) {
      return _buildEmptyState();
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Mahastudy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Toggle demo mode button (to switch between empty state & populated state)
                      IconButton(
                        tooltip: 'Beralih Tampilan Demo (Data / Kosong)',
                        icon: const Icon(Icons.swap_horiz, size: 20, color: AppTheme.textMuted),
                        onPressed: () => _mockData.toggleEmptyState(),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NotifikasiScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppTheme.cardBorder),
                              ),
                              child: const Icon(
                                Icons.notifications_none_rounded,
                                size: 20,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            if (_mockData.unreadNotificationCount > 0)
                              Positioned(
                                top: -2,
                                right: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDC2626),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    '${_mockData.unreadNotificationCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Greeting Section
              Text(
                'Halo, ${_mockData.currentUser.name}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Selasa, 13 Oktober 2026',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              // Daily summary card
              const StatSummaryCard(
                classCount: 1,
                taskCount: 2,
                activityCount: 1,
              ),
              const SizedBox(height: 24),
              // Smart Daily Agenda Section (Hero Feature 1)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Smart Daily Agenda',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SmartAgendaScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Lihat semua',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Column(
                  children: [
                    AgendaTimelineCard(
                      time: '09:00',
                      title: 'Statistika',
                      subtitle: 'Kuliah • Ruang A.102',
                      icon: Icons.school_outlined,
                      onTap: () {
                        final schedule = _mockData.schedules.firstWhere(
                          (s) => s.id == 's1',
                          orElse: () => _mockData.schedules.first,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailJadwalScreen(schedule: schedule),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 12, color: AppTheme.cardBorder),
                    AgendaTimelineCard(
                      time: '13:00',
                      title: 'Review presentasi',
                      subtitle: 'Tugas • Interaksi Manusia Komputer',
                      icon: Icons.assignment_outlined,
                      onTap: () {
                        final task = _mockData.tasks.firstWhere(
                          (t) => t.id == 't2',
                          orElse: () => _mockData.tasks.first,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailTugasScreen(task: task),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 12, color: AppTheme.cardBorder),
                    AgendaTimelineCard(
                      time: '16:00',
                      title: 'Rapat BEM',
                      subtitle: 'Kegiatan • Sekretariat BEM',
                      icon: Icons.groups_outlined,
                      onTap: () {
                        final schedule = _mockData.schedules.firstWhere(
                          (s) => s.id == 's6',
                          orElse: () => _mockData.schedules.first,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailJadwalScreen(schedule: schedule),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Deadline Risk Alert Banner (Hero Feature 2)
              DeadlineRiskBanner(
                title: 'Laporan praktikum Statistika',
                deadlineText: 'Hari ini, 20:00',
                statusText: 'Belum selesai',
                onTap: () {
                  final task = _mockData.tasks.firstWhere((t) => t.id == 't1');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailTugasScreen(task: task),
                    ),
                  );
                },
                onScheduleStudy: () => widget.onNavigateTab(3),
              ),
              const SizedBox(height: 20),
              // Weekly Productivity Recap Banner (Hero Feature 3)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Progres minggu ini',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: () => widget.onNavigateTab(3),
                          child: const Row(
                            children: [
                              Text(
                                'Weekly Recap',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.primary,
                                ),
                              ),
                              Icon(Icons.chevron_right, size: 16, color: AppTheme.primary),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: const LinearProgressIndicator(
                        value: 8 / 12,
                        minHeight: 8,
                        backgroundColor: AppTheme.cardBorder,
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '8/12 tugas selesai',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        Text(
                          '6/10 jam belajar',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Akses Cepat Section
              const Text(
                'Akses cepat',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  QuickActionChip(
                    icon: Icons.calendar_month_outlined,
                    label: 'Jadwal Kuliah',
                    onTap: () => widget.onNavigateTab(1),
                  ),
                  QuickActionChip(
                    icon: Icons.assignment_outlined,
                    label: 'Jadwal Ujian',
                    onTap: () => widget.onNavigateTab(1),
                  ),
                  QuickActionChip(
                    icon: Icons.groups_outlined,
                    label: 'Kegiatan Organisasi',
                    onTap: () => widget.onNavigateTab(1),
                  ),
                  QuickActionChip(
                    icon: Icons.menu_book_outlined,
                    label: 'Study Planner',
                    onTap: () => widget.onNavigateTab(3),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Mahastudy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    tooltip: 'Kembali ke tampilan isi',
                    icon: const Icon(Icons.swap_horiz, size: 20, color: AppTheme.textMuted),
                    onPressed: () => _mockData.toggleEmptyState(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Halo, ${_mockData.currentUser.name}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Selasa, 13 Oktober 2026',
                      style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Empty State Graphic
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.4), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.calendar_today_rounded,
                        size: 44,
                        color: AppTheme.primary,
                      ),
                    ),
                    Positioned(
                      bottom: 22,
                      right: 22,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppTheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Belum ada aktivitas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Hari yang teratur dimulai dari satu jadwal.\nTambahkan kuliah pertamamu di sini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.4,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 240,
                child: ElevatedButton(
                  onPressed: () {
                    _mockData.toggleEmptyState();
                    widget.onNavigateTab(1);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Tambah jadwal pertama',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
