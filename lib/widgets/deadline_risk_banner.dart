import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class DeadlineRiskBanner extends StatelessWidget {
  final String title;
  final String deadlineText;
  final String statusText;
  final VoidCallback onTap;
  final VoidCallback? onScheduleStudy;

  const DeadlineRiskBanner({
    super.key,
    required this.title,
    required this.deadlineText,
    required this.statusText,
    required this.onTap,
    this.onScheduleStudy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F7), // Soft reddish surface
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.danger.withValues(alpha: 0.3),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Deadline terdekat',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.dangerLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Berisiko telat',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.danger,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$deadlineText • $statusText',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.danger,
                  ),
                ),
              ],
            ),
          ),
          if (onScheduleStudy != null) ...[
            const SizedBox(height: 10),
            InkWell(
              onTap: onScheduleStudy,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, size: 14, color: AppTheme.primary),
                  SizedBox(width: 4),
                  Text(
                    'Jadwalkan Belajar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
