import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class StatSummaryCard extends StatelessWidget {
  final int classCount;
  final int taskCount;
  final int activityCount;

  const StatSummaryCard({
    super.key,
    required this.classCount,
    required this.taskCount,
    required this.activityCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hari ini, tetap terarah',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildItem('$classCount', 'Kelas'),
              _buildDivider(),
              _buildItem('$taskCount', 'Tugas'),
              _buildDivider(),
              _buildItem('$activityCount', 'Kegiatan'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 28,
      width: 1,
      color: AppTheme.cardBorder,
    );
  }
}
