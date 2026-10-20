import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/study_plan_item.dart';
import '../../models/study_plan_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/study_session_card.dart';
import 'add_study_plan_screen.dart';
import 'detail_rencana_screen.dart';
import 'progres_belajar_screen.dart';
import 'weekly_recap_screen.dart';
import 'pomodoro_selector_sheet.dart';
import 'sesi_belajar_timer_screen.dart';

class BelajarScreen extends StatefulWidget {
  const BelajarScreen({super.key});

  @override
  State<BelajarScreen> createState() => _BelajarScreenState();
}

class _BelajarScreenState extends State<BelajarScreen> {
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

  Future<void> _startTimerForPlan(StudyPlanItem plan) async {
    final chosenMinutes = await showPomodoroSelectorSheet(
      context,
      currentMinutes: plan.durationMinutes,
    );
    if (!mounted) return;
    final minutes = chosenMinutes ?? plan.durationMinutes;

    final completed = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => SesiBelajarTimerScreen(
          courseName: plan.courseName,
          topic: plan.topic,
          initialMinutes: minutes,
        ),
      ),
    );

    if (completed != null && mounted) {
      final updated = plan.copyWith(
        completedMinutes: plan.completedMinutes + completed,
        isCompleted: (plan.completedMinutes + completed) >= plan.durationMinutes,
      );
      _mockData.updateStudyPlan(updated);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Sesi belajar selesai (+$completed menit tersimpan)'),
            ],
          ),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      const Spacer(),
                      // Shortcut ke Weekly Productivity Recap (FR-21)
                      IconButton(
                        tooltip: 'Weekly Recap',
                        icon: const Icon(Icons.insights_rounded, color: AppTheme.primary),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const WeeklyRecapScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rencana Belajar',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Atur sesi fokus belajar agar target tercapai.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Weekly Study Target Card (Hero Feature 3 - FR-09 & FR-21)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProgresBelajarScreen()),
                      );
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Target Minggu ini : 6/10 Jam Belajar',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '60%',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.chevron_right, size: 16, color: AppTheme.textMuted),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: const LinearProgressIndicator(
                              value: 0.6,
                              minHeight: 8,
                              backgroundColor: AppTheme.cardBorder,
                              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '4 jam lagi menuju targetmu',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              Text(
                                'Lihat Rincian Progres >',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Sesi belajarmu',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        '${_mockData.studyPlans.length} Rencana',
                        style: const TextStyle(fontSize: 12, color: AppTheme.textMuted, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Study Plans List or Empty State (FR-14)
            Expanded(
              child: _mockData.studyPlans.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _mockData.studyPlans.length,
                      itemBuilder: (context, index) {
                        final plan = _mockData.studyPlans[index];
                        return StudySessionCard(
                          plan: plan,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailRencanaScreen(plan: plan),
                              ),
                            );
                          },
                          onStartTimer: () => _startTimerForPlan(plan),
                        );
                      },
                    ),
            ),

            // Bottom Action Button: + Tambah Rencana Belajar (FR-06)
            Padding(
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(
                text: '+ Tambah Rencana Belajar',
                onPressed: _navigateToAddStudyPlan,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: const BoxDecoration(
                color: AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 44,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Belum ada rencana belajar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Yuk tentukan waktu dan target belajarmu hari ini agar lebih terarah.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _navigateToAddStudyPlan() async {
    final result = await Navigator.push<StudyPlan>(
      context,
      MaterialPageRoute(builder: (_) => const AddStudyPlanScreen()),
    );
    if (!mounted || result == null) return;

    final code = result.course.length > 2
        ? result.course.substring(0, 2).toUpperCase()
        : result.course;
    final dur = (result.endTime.hour * 60 + result.endTime.minute) -
        (result.startTime.hour * 60 + result.startTime.minute);
    final durationMinutes = dur > 0 ? dur : 45;

    _mockData.addStudyPlan(
      StudyPlanItem(
        id: 'sp_${DateTime.now().millisecondsSinceEpoch}',
        courseCode: code,
        courseName: result.course,
        topic: result.target,
        scheduledTime: '${StudyPlan.formatDate(result.date)}, ${result.formattedTime}',
        durationMinutes: durationMinutes,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text('Rencana belajar berhasil dibuat'),
          ],
        ),
        backgroundColor: Color(0xFF24714E),
      ),
    );
  }
}
