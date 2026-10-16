import 'package:flutter/material.dart';

import '../../models/study_plan_model.dart';
import 'add_study_plan_screen.dart';
import 'sesi_belajar_timer_screen.dart';

class StudyPlanScreen extends StatefulWidget {
  const StudyPlanScreen({super.key});

  @override
  State<StudyPlanScreen> createState() => _StudyPlanScreenState();
}

class _StudyPlanScreenState extends State<StudyPlanScreen> {
  static const _navy = Color(0xFF182C46);
  static const _blue = Color(0xFF2563EB);
  static const _muted = Color(0xFF657890);

  // STATE: daftar dan status sukses disimpan di layar induk.
  final List<StudyPlan> _plans = [
    StudyPlan(
      course: 'Pemrograman Web',
      date: DateTime.now(),
      startTime: const TimeOfDay(hour: 19, minute: 30),
      endTime: const TimeOfDay(hour: 20, minute: 15),
      target: 'Slicing UI & Navigasi',
      status: 'Sesi belajar mandiri',
    ),
    StudyPlan(
      course: 'Statistika',
      date: DateTime.now().add(const Duration(days: 1)),
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 0),
      target: 'Latihan Bab 4',
      status: 'Sesi belajar mandiri',
    ),
  ];
  bool _showSuccess = false;

  // INPUT/EVENT: buka form, tunggu result, lalu update daftar tanpa reload aplikasi.
  Future<void> _addPlan() async {
    final result = await Navigator.push<StudyPlan>(
      context,
      MaterialPageRoute(builder: (_) => const AddStudyPlanScreen()),
    );

    if (!mounted || result == null) return;
    setState(() {
      _plans.insert(0, result);
      _showSuccess = true;
    });
    // FEEDBACK: tampilkan konfirmasi pada daftar bersama data yang baru disimpan.
  }

  Widget _brandHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
    child: const Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Mahastudy',
        style: TextStyle(
          color: _navy,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  Widget _pageHeading() => const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Rencana Belajar',
        style: TextStyle(
          color: _navy,
          fontSize: 26,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 6),
      Text(
        'Langkah kecil untuk progres besar.',
        style: TextStyle(color: _muted, fontSize: 14),
      ),
    ],
  );

  Widget _emptyState() => Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(20, 32, 20, 24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        _emptyIllustration(),
        const SizedBox(height: 30),
        const Text(
          'Belum ada rencana belajar',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _navy,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Yuk, tentukan waktu dan targetmu. Belajar jadi lebih terarah.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 24),
        _primaryAddButton(),
      ],
    ),
  );

  Widget _emptyIllustration() => Container(
    width: 144,
    height: 144,
    decoration: const BoxDecoration(
      color: Color(0xFFEAF4FF),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Container(
        width: 84,
        height: 108,
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFB9D2F8), width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 5,
              decoration: BoxDecoration(
                color: _blue,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDCE8FF),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 30,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDCE8FF),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const Spacer(),
            const CircleAvatar(
              radius: 13,
              backgroundColor: _blue,
              child: Icon(Icons.check, color: Colors.white, size: 17),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _primaryAddButton() => SizedBox(
    width: double.infinity,
    height: 52,
    child: FilledButton(
      onPressed: _addPlan,
      style: FilledButton.styleFrom(
        backgroundColor: _blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        '+ Tambah Rencana',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );

  Widget _planCard(StudyPlan plan) => Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF4FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                color: _blue,
                size: 23,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.course,
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    plan.status,
                    style: const TextStyle(color: _muted, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _scheduleRow(Icons.calendar_month_outlined, plan.formattedDate),
        const SizedBox(height: 10),
        _scheduleRow(Icons.schedule_outlined, plan.formattedTime),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Divider(height: 1, color: Color(0xFFDCE6F2)),
        ),
        const Text(
          'Target Belajar',
          style: TextStyle(
            color: _muted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          plan.target,
          style: const TextStyle(color: _navy, fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: FilledButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SesiBelajarTimerScreen(
                    courseName: plan.course,
                    topic: plan.target,
                    initialMinutes: 45,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.play_arrow_outlined),
            label: const Text('Mulai Study Timer'),
            style: FilledButton.styleFrom(
              backgroundColor: _blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  Widget _scheduleRow(IconData icon, String value) => Row(
    children: [
      Icon(icon, color: _blue, size: 18),
      const SizedBox(width: 10),
      Expanded(
        child: Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: _navy, fontSize: 14),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Column(
        children: [
          _brandHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
              children: [
                _pageHeading(),
                const SizedBox(height: 20),
                if (_showSuccess) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFFAF4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF24714E),
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Rencana belajar berhasil dibuat',
                            style: TextStyle(
                              color: Color(0xFF24714E),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                ],
                if (_plans.isEmpty)
                  _emptyState()
                else ...[
                  Text(
                    'RENCANA MENDATANG · ${_plans.length}',
                    style: const TextStyle(
                      color: _muted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._plans.map(_planCard),
                  OutlinedButton(
                    onPressed: _addPlan,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      foregroundColor: _blue,
                      backgroundColor: Colors.white,
                      side: const BorderSide(color: Color(0xFFDCE6F2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      '+ Tambah Rencana',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
