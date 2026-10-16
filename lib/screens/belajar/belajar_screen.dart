import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/study_plan_item.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/study_session_card.dart';
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
                    ],
                  ),
                  const SizedBox(height: 20),
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
                  // Weekly Study Target Card (Hero Feature 3 component)
                  Container(
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
                            Text(
                              '60%',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
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
                        const Text(
                          '4 jam lagi menuju targetmu',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sesi belajarmu',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            // Study Plans List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _mockData.studyPlans.length,
                itemBuilder: (context, index) {
                  final plan = _mockData.studyPlans[index];
                  return StudySessionCard(
                    plan: plan,
                    onStartTimer: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SesiBelajarTimerScreen(
                            courseName: plan.courseName,
                            topic: plan.topic,
                            initialMinutes: plan.durationMinutes,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // Bottom Action Button: + Tambah Rencana Belajar
            Padding(
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(
                text: '+ Tambah Rencana Belajar',
                onPressed: _showAddPlanDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPlanDialog() {
    final topicController = TextEditingController();
    final durationController = TextEditingController(text: '45');
    String selectedCourse = 'Pemrograman Web';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tambah Rencana Belajar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: selectedCourse,
              decoration: const InputDecoration(labelText: 'Mata Kuliah'),
              items: _mockData.courses.map((c) {
                return DropdownMenuItem(value: c.name, child: Text(c.name));
              }).toList(),
              onChanged: (val) {
                if (val != null) selectedCourse = val;
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: topicController,
              decoration: const InputDecoration(labelText: 'Target Topik Belajar (cth: Latihan Soal)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: durationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Durasi (menit)'),
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: 'Simpan Rencana',
              onPressed: () {
                if (topicController.text.isNotEmpty) {
                  final code = selectedCourse.length > 2
                      ? selectedCourse.substring(0, 2).toUpperCase()
                      : selectedCourse;
                  final dur = int.tryParse(durationController.text) ?? 45;

                  _mockData.addStudyPlan(
                    StudyPlanItem(
                      id: 'sp_${DateTime.now().millisecondsSinceEpoch}',
                      courseCode: code,
                      courseName: selectedCourse,
                      topic: topicController.text,
                      scheduledTime: 'Hari ini, 20:00',
                      durationMinutes: dur,
                    ),
                  );
                  Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
