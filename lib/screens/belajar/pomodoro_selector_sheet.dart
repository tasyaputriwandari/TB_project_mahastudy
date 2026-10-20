import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

Future<int?> showPomodoroSelectorSheet(BuildContext context, {int currentMinutes = 45}) {
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBorder,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Pilih Mode Waktu Belajar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tentukan durasi timer fokus yang cocok dengan target belajarmu.',
                style: TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),
              _buildOption(
                ctx,
                icon: Icons.timer_outlined,
                title: 'Teknik Pomodoro',
                subtitle: '25 Menit fokus belajar + 5 menit istirahat',
                minutes: 25,
                isSelected: currentMinutes == 25,
              ),
              const SizedBox(height: 10),
              _buildOption(
                ctx,
                icon: Icons.psychology_outlined,
                title: 'Deep Work (Standar PRD)',
                subtitle: '45 Menit pemahaman materi mendalam',
                minutes: 45,
                isSelected: currentMinutes == 45,
              ),
              const SizedBox(height: 10),
              _buildOption(
                ctx,
                icon: Icons.fitness_center_outlined,
                title: 'Sesi Intensif',
                subtitle: '60 Menit penyelesaian tugas & latihan soal',
                minutes: 60,
                isSelected: currentMinutes == 60,
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildOption(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  required int minutes,
  required bool isSelected,
}) {
  return InkWell(
    onTap: () => Navigator.pop(context, minutes),
    borderRadius: BorderRadius.circular(14),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryLight : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle, color: AppTheme.primary, size: 20),
        ],
      ),
    ),
  );
}
