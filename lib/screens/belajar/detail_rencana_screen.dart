import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/study_plan_item.dart';
import '../../models/study_plan_model.dart';
import '../../theme/app_theme.dart';
import 'add_study_plan_screen.dart';
import 'dialog_hapus_rencana.dart';
import 'sesi_belajar_timer_screen.dart';
import 'pomodoro_selector_sheet.dart';

class DetailRencanaScreen extends StatefulWidget {
  final StudyPlanItem plan;

  const DetailRencanaScreen({
    super.key,
    required this.plan,
  });

  @override
  State<DetailRencanaScreen> createState() => _DetailRencanaScreenState();
}

class _DetailRencanaScreenState extends State<DetailRencanaScreen> {
  final MockData _mockData = MockData();
  late StudyPlanItem _currentPlan;

  @override
  void initState() {
    super.initState();
    _currentPlan = widget.plan;
  }

  Future<void> _handleDelete() async {
    final confirmed = await showDialogHapusRencana(
      context,
      courseName: _currentPlan.courseName,
      topic: _currentPlan.topic,
    );

    if (confirmed == true && mounted) {
      _mockData.deleteStudyPlan(_currentPlan.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Rencana belajar berhasil dihapus'),
            ],
          ),
          backgroundColor: AppTheme.danger,
        ),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _handleEdit() async {
    final result = await Navigator.push<StudyPlan>(
      context,
      MaterialPageRoute(
        builder: (_) => AddStudyPlanScreen(initialPlan: _currentPlan),
      ),
    );

    if (result != null && mounted) {
      final code = result.course.length > 2
          ? result.course.substring(0, 2).toUpperCase()
          : result.course;
      final dur = (result.endTime.hour * 60 + result.endTime.minute) -
          (result.startTime.hour * 60 + result.startTime.minute);
      final durationMinutes = dur > 0 ? dur : 45;

      final updated = _currentPlan.copyWith(
        courseCode: code,
        courseName: result.course,
        topic: result.target,
        scheduledTime: '${StudyPlan.formatDate(result.date)}, ${result.formattedTime}',
        durationMinutes: durationMinutes,
      );

      _mockData.updateStudyPlan(updated);

      setState(() {
        _currentPlan = updated;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Rencana belajar berhasil diperbarui'),
            ],
          ),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  Future<void> _handleStartTimer() async {
    final chosenMinutes = await showPomodoroSelectorSheet(
      context,
      currentMinutes: _currentPlan.durationMinutes,
    );

    if (!mounted) return;
    final minutes = chosenMinutes ?? _currentPlan.durationMinutes;

    final completed = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => SesiBelajarTimerScreen(
          courseName: _currentPlan.courseName,
          topic: _currentPlan.topic,
          initialMinutes: minutes,
        ),
      ),
    );

    if (completed != null && mounted) {
      final newCompleted = _currentPlan.completedMinutes + completed;
      final isFinished = newCompleted >= _currentPlan.durationMinutes;

      final updated = _currentPlan.copyWith(
        completedMinutes: newCompleted,
        isCompleted: isFinished,
      );

      _mockData.updateStudyPlan(updated);

      setState(() {
        _currentPlan = updated;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Detail Rencana Belajar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Ubah Rencana',
            onPressed: _handleEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppTheme.danger),
            tooltip: 'Hapus Rencana',
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // Card Header
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                _currentPlan.courseCode,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _currentPlan.courseName,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _currentPlan.isCompleted
                                        ? 'Selesai dipelajari 🎉'
                                        : 'Sesi belajar mandiri aktif',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _currentPlan.isCompleted
                                          ? AppTheme.success
                                          : AppTheme.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Divider(height: 1, color: AppTheme.cardBorder),
                        const SizedBox(height: 14),
                        const Text(
                          'Target Belajar (Materi / Topik):',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textMuted,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _currentPlan.topic,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Progress Belajar
                  Container(
                    padding: const EdgeInsets.all(18),
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
                              'Progres Jam Belajar',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            Text(
                              '${_currentPlan.progressPersen}%',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: _currentPlan.progress,
                            minHeight: 8,
                            backgroundColor: AppTheme.cardBorder,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _currentPlan.isCompleted ? AppTheme.success : AppTheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_currentPlan.completedMinutes} dari ${_currentPlan.durationMinutes} menit selesai',
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Waktu Jadwal
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informasi Waktu Pelaksanaan',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined, size: 18, color: AppTheme.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _currentPlan.scheduledTime,
                                style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, size: 18, color: AppTheme.primary),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Target Durasi: ${_currentPlan.durationMinutes} Menit',
                                style: const TextStyle(fontSize: 13, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppTheme.cardBorder)),
              ),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _handleDelete,
                    icon: const Icon(Icons.delete_outline, size: 20),
                    label: const Text('Hapus'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.danger,
                      side: const BorderSide(color: AppTheme.dangerLight),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleStartTimer,
                      icon: const Icon(Icons.play_arrow_rounded, size: 22),
                      label: const Text('Mulai Study Timer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
