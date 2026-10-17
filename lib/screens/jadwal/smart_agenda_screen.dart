import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/schedule_item.dart';
import '../../models/task_item.dart';
import '../../theme/app_theme.dart';
import '../tugas/detail_tugas_screen.dart';
import 'detail_jadwal_screen.dart';

enum AgendaFilter { semua, kuliah, tugas, ujian, organisasi, belajar }

class AgendaEntry {
  final String id;
  final String time;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final AgendaFilter category;
  final ScheduleItem? scheduleItem;
  final TaskItem? taskItem;

  const AgendaEntry({
    required this.id,
    required this.time,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.category,
    this.scheduleItem,
    this.taskItem,
  });
}

class SmartAgendaScreen extends StatefulWidget {
  const SmartAgendaScreen({super.key});

  @override
  State<SmartAgendaScreen> createState() => _SmartAgendaScreenState();
}

class _SmartAgendaScreenState extends State<SmartAgendaScreen> {
  final MockData _mockData = MockData();
  AgendaFilter _selectedFilter = AgendaFilter.semua;

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

  List<AgendaEntry> _buildAgendaEntries() {
    final List<AgendaEntry> list = [];

    // 1. Schedules (Kuliah, Ujian, Organisasi)
    for (final s in _mockData.schedules) {
      if (s.type == ScheduleType.kuliah) {
        list.add(
          AgendaEntry(
            id: s.id,
            time: s.time.split('-').first.trim(),
            title: s.title,
            subtitle: '${s.day} • ${s.room}',
            icon: Icons.school_outlined,
            color: AppTheme.primary,
            category: AgendaFilter.kuliah,
            scheduleItem: s,
          ),
        );
      } else if (s.type == ScheduleType.ujian) {
        list.add(
          AgendaEntry(
            id: s.id,
            time: s.time.split('-').first.trim(),
            title: s.title,
            subtitle: '${s.dateFormatted ?? s.day} • ${s.room}',
            icon: Icons.assignment_late_outlined,
            color: const Color(0xFFEA580C),
            category: AgendaFilter.ujian,
            scheduleItem: s,
          ),
        );
      } else if (s.type == ScheduleType.organisasi) {
        list.add(
          AgendaEntry(
            id: s.id,
            time: s.time.split('-').first.trim(),
            title: s.title,
            subtitle: '${s.organizer ?? "Organisasi"} • ${s.room}',
            icon: Icons.groups_outlined,
            color: const Color(0xFF7C3AED),
            category: AgendaFilter.organisasi,
            scheduleItem: s,
          ),
        );
      }
    }

    // 2. Tasks
    for (final t in _mockData.tasks) {
      list.add(
        AgendaEntry(
          id: t.id,
          time: t.deadlineText.contains(',') ? t.deadlineText.split(',').last.trim() : '23:59',
          title: t.title,
          subtitle: 'Deadline Tugas • ${t.courseName}',
          icon: Icons.assignment_outlined,
          color: const Color(0xFF10B981),
          category: AgendaFilter.tugas,
          taskItem: t,
        ),
      );
    }

    // 3. Study Plans
    for (final sp in _mockData.studyPlans) {
      list.add(
        AgendaEntry(
          id: sp.id,
          time: sp.scheduledTime.contains(',') ? sp.scheduledTime.split(',').last.trim() : '19:30',
          title: 'Belajar: ${sp.topic}',
          subtitle: '${sp.courseName} • ${sp.durationMinutes} Menit',
          icon: Icons.timer_outlined,
          color: const Color(0xFF0284C7),
          category: AgendaFilter.belajar,
        ),
      );
    }

    // Sort by time
    list.sort((a, b) => a.time.compareTo(b.time));
    return list;
  }

  void _onEntryTapped(AgendaEntry entry) {
    if (entry.scheduleItem != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailJadwalScreen(schedule: entry.scheduleItem!),
        ),
      );
    } else if (entry.taskItem != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailTugasScreen(task: entry.taskItem!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aktivitas: ${entry.title} (${entry.time})'),
          backgroundColor: entry.color,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final allEntries = _buildAgendaEntries();
    final filtered = allEntries.where((e) {
      if (_selectedFilter == AgendaFilter.semua) return true;
      return e.category == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.school_rounded, size: 12, color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Mahastudy',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(8),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(Icons.arrow_back, size: 22, color: Color(0xFF172C46)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Smart Daily Agenda',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172C46),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Linimasa terpadu kuliah, ujian, organisasi, tugas & sesi belajar.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 12),

                  // Filter Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Semua', AgendaFilter.semua),
                        const SizedBox(width: 8),
                        _buildFilterChip('Kuliah', AgendaFilter.kuliah),
                        const SizedBox(width: 8),
                        _buildFilterChip('Tugas', AgendaFilter.tugas),
                        const SizedBox(width: 8),
                        _buildFilterChip('Ujian', AgendaFilter.ujian),
                        const SizedBox(width: 8),
                        _buildFilterChip('Organisasi', AgendaFilter.organisasi),
                        const SizedBox(width: 8),
                        _buildFilterChip('Belajar', AgendaFilter.belajar),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppTheme.cardBorder),

            // Timeline Entries
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.event_available_outlined, size: 48, color: AppTheme.primary),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Tidak Ada Agenda',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Tidak ada aktivitas pada filter ini untuk hari ini.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final entry = filtered[index];
                        return InkWell(
                          onTap: () => _onEntryTapped(entry),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppTheme.cardBorder),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: entry.color.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    entry.time,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: entry.color,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: entry.color.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(entry.icon, size: 18, color: entry.color),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        entry.subtitle,
                                        style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, size: 18, color: AppTheme.textMuted),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, AgendaFilter filter) {
    final isSelected = _selectedFilter == filter;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = filter),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.cardBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}
