import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/task_item.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/task_card.dart';
import 'detail_tugas_screen.dart';
import 'form_tambah_tugas_screen.dart';

class TugasScreen extends StatefulWidget {
  final VoidCallback? onNavigateToStudy;

  const TugasScreen({super.key, this.onNavigateToStudy});

  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> {
  final MockData _mockData = MockData();
  String _activeFilter = 'Semua';

  final List<String> _filters = [
    'Semua',
    'Prioritas Tinggi',
    'Prioritas Sedang',
    'Prioritas Rendah',
    'Mendekati',
    'Selesai',
  ];

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
    // Filter tasks based on active filter
    final filteredTasks = _mockData.tasks.where((t) {
      if (_activeFilter == 'Semua') return true;
      if (_activeFilter == 'Prioritas Tinggi') return t.priority == TaskPriority.tinggi;
      if (_activeFilter == 'Prioritas Sedang') return t.priority == TaskPriority.sedang;
      if (_activeFilter == 'Prioritas Rendah') return t.priority == TaskPriority.rendah;
      if (_activeFilter == 'Mendekati') return t.isRiskAlert || t.deadlineText.contains('Hari ini');
      if (_activeFilter == 'Selesai') return t.status == TaskStatus.selesai;
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Brand
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
                  const SizedBox(height: 20),
                  const Text(
                    'Daftar Tugas Kuliah',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Kelola prioritas dan kumpulkan tepat waktu.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _filters.map((filter) {
                        final isSelected = filter == _activeFilter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () => setState(() => _activeFilter = filter),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primary : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                                ),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            // Tasks List
            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada tugas pada kategori ini',
                        style: TextStyle(color: AppTheme.textMuted),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = filteredTasks[index];
                        return TaskCard(
                          task: task,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailTugasScreen(task: task),
                              ),
                            );
                          },
                          onScheduleStudy: () {
                            if (widget.onNavigateToStudy != null) {
                              widget.onNavigateToStudy!();
                            }
                          },
                        );
                      },
                    ),
            ),
            // Bottom Action Button: + Tambah Tugas
            Padding(
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(
                text: '+ Tambah Tugas',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FormTambahTugasScreen(),
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
}
