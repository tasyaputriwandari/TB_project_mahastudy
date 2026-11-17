import 'package:flutter/material.dart';
import '../models/task_item.dart';
import '../theme/app_theme.dart';

class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onTap;
  final VoidCallback? onScheduleStudy;
  final ValueChanged<bool?>? onStatusToggle;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onScheduleStudy,
    this.onStatusToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == TaskStatus.selesai;
    final isRisk = task.isRiskAlert && !isDone;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRisk ? const Color(0xFFFFF9F9) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRisk ? AppTheme.danger.withValues(alpha: 0.4) : AppTheme.cardBorder,
          width: isRisk ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isRisk) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 16, color: AppTheme.danger),
                        SizedBox(width: 4),
                        Text(
                          'Berisiko Telat',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.danger,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.dangerLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Berisiko telat',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.danger),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status indicator (circle or check)
                  Container(
                    width: 22,
                    height: 22,
                    margin: const EdgeInsets.only(top: 2, right: 12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDone ? AppTheme.success : AppTheme.textMuted,
                        width: 2,
                      ),
                      color: isDone ? AppTheme.success : Colors.transparent,
                    ),
                    child: isDone
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDone ? AppTheme.textMuted : AppTheme.textPrimary,
                                  decoration: isDone ? TextDecoration.lineThrough : null,
                                ),
                              ),
                            ),
                            _buildPriorityBadge(task.priority),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: task.deadlineText,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isRisk ? AppTheme.danger : AppTheme.textSecondary,
                                  fontWeight: isRisk ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                              if (isRisk) ...[
                                const TextSpan(
                                  text: ' • Sisa 8 jam & belum ada rencana belajar!',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppTheme.danger,
                                  ),
                                ),
                              ] else ...[
                                TextSpan(
                                  text: ' • ${task.statusLabel}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (isRisk && onScheduleStudy != null) ...[
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: onScheduleStudy,
                            child: const Text(
                              '+ Jadwalkan Belajar',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityBadge(TaskPriority priority) {
    Color bgColor;
    Color textColor;
    String label;

    switch (priority) {
      case TaskPriority.tinggi:
        bgColor = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        label = 'Tinggi';
        break;
      case TaskPriority.sedang:
        bgColor = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFD97706);
        label = 'Sedang';
        break;
      case TaskPriority.rendah:
        bgColor = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF16A34A);
        label = 'Rendah';
        break;
    }

    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}
