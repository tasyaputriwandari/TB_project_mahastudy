import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class WeeklyRecapScreen extends StatefulWidget {
  const WeeklyRecapScreen({super.key});

  @override
  State<WeeklyRecapScreen> createState() => _WeeklyRecapScreenState();
}

class _WeeklyRecapScreenState extends State<WeeklyRecapScreen> {
  int _selectedWeekIndex = 0; // 0: Minggu Ini, 1: Minggu Lalu

  final List<Map<String, dynamic>> _weekData = [
    {
      'period': '12 – 18 Oktober 2026 (Minggu Ini)',
      'taskOnTime': 85,
      'studyHours': 6.0,
      'targetHours': 10.0,
      'timerSessions': 4,
      'orgAttendance': '1 / 1 Kegiatan',
      'dailyHours': [1.5, 2.0, 1.0, 1.5, 0.0, 0.0, 0.0], // Sen - Min
    },
    {
      'period': '5 – 11 Oktober 2026 (Minggu Lalu)',
      'taskOnTime': 90,
      'studyHours': 9.5,
      'targetHours': 10.0,
      'timerSessions': 7,
      'orgAttendance': '2 / 2 Kegiatan',
      'dailyHours': [2.0, 1.5, 2.0, 1.0, 1.5, 1.5, 0.0],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final current = _weekData[_selectedWeekIndex];
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final dailyHours = current['dailyHours'] as List<double>;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Weekly Productivity Recap'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Selector Rentang Minggu (PRD FR-21)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedWeekIndex = 0),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedWeekIndex == 0 ? AppTheme.primaryLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Minggu Ini',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _selectedWeekIndex == 0 ? AppTheme.primary : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedWeekIndex = 1),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedWeekIndex == 1 ? AppTheme.primaryLight : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Minggu Lalu',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _selectedWeekIndex == 1 ? AppTheme.primary : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              current['period'] as String,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textMuted),
            ),
            const SizedBox(height: 20),

            // Grid 4 Metrik Produktivitas PRD FR-21
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.check_circle_outline,
                    iconColor: AppTheme.success,
                    title: 'Tugas Tepat Waktu',
                    value: '${current['taskOnTime']}%',
                    sub: 'Target: >80%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.timer_outlined,
                    iconColor: AppTheme.primary,
                    title: 'Jam Belajar',
                    value: '${current['studyHours']} / ${current['targetHours']} Jam',
                    sub: '${((current['studyHours'] / current['targetHours']) * 100).toInt()}% Target',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.repeat_rounded,
                    iconColor: const Color(0xFF8B5CF6),
                    title: 'Konsistensi Timer',
                    value: '${current['timerSessions']} Sesi',
                    sub: 'Sesi fokus tuntas',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    icon: Icons.groups_outlined,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Kegiatan Kampus',
                    value: current['orgAttendance'] as String,
                    sub: 'Hadir sesuai jadwal',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bar Chart Jam Belajar Harian
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Distribusi Waktu Belajar Harian (Jam)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 140,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(7, (idx) {
                        final h = dailyHours[idx];
                        final maxH = 2.5;
                        final ratio = (h / maxH).clamp(0.05, 1.0);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              h > 0 ? '$h' : '',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primary),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 24,
                              height: 90 * ratio,
                              decoration: BoxDecoration(
                                color: h > 0 ? AppTheme.primary : AppTheme.cardBorder,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              days[idx],
                              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                            ),
                          ],
                        );
                      }),
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

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const SizedBox(height: 2),
          Text(sub, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
