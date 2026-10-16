import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/task_item.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';

class DetailTugasScreen extends StatefulWidget {
  final TaskItem task;

  const DetailTugasScreen({
    super.key,
    required this.task,
  });

  @override
  State<DetailTugasScreen> createState() => _DetailTugasScreenState();
}

class _DetailTugasScreenState extends State<DetailTugasScreen> {
  final MockData _mockData = MockData();
  late TaskItem _task;
  String? _uploadedFileName;
  String? _uploadedFileSize;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _uploadedFileName = _task.proofFileName ?? 'Bukti_Statistika.jpg';
    _uploadedFileSize = _task.proofFileSize ?? '1.2 MB • Foto dokumen';
  }

  void _simulatePickFile() {
    setState(() => _isUploading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (!mounted) return;
      setState(() {
        _isUploading = false;
        _uploadedFileName = 'Bukti_${_task.courseName.replaceAll(' ', '_')}.jpg';
        _uploadedFileSize = '1.2 MB • Foto dokumen';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File bukti pengerjaan berhasil dipilih (1.2 MB)'),
          backgroundColor: AppTheme.primary,
        ),
      );
    });
  }

  void _submitProof() {
    if (_uploadedFileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap unggah bukti pengerjaan terlebih dahulu!'),
          backgroundColor: AppTheme.danger,
        ),
      );
      return;
    }

    _mockData.markTaskComplete(_task.id, _uploadedFileName!, _uploadedFileSize!);
    setState(() {
      _task.status = TaskStatus.selesai;
      _task.proofFileName = _uploadedFileName;
      _task.proofFileSize = _uploadedFileSize;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tugas berhasil diselesaikan dengan bukti pengerjaan!'),
        backgroundColor: AppTheme.success,
      ),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDone = _task.status == TaskStatus.selesai;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Tugas'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Container(
                padding: const EdgeInsets.all(16),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _task.courseName.length > 2
                                ? _task.courseName.substring(0, 2).toUpperCase()
                                : _task.courseName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _task.courseName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _task.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                            const SizedBox(width: 4),
                            Text(
                              _task.deadlineText,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _task.priority == TaskPriority.tinggi
                                ? AppTheme.dangerLight
                                : AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _task.priorityLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _task.priority == TaskPriority.tinggi
                                  ? AppTheme.danger
                                  : AppTheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_task.notes.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(color: AppTheme.cardBorder),
                      const SizedBox(height: 8),
                      Text(
                        _task.notes,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Upload Section Title
              const Text(
                'Unggah Bukti Pengerjaan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Foto dokumen atau screenshot hasil tugas (Maks. 5 MB)',
                style: TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              // Upload Button / Card
              InkWell(
                onTap: isDone ? null : _simulatePickFile,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.5),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          shape: BoxShape.circle,
                        ),
                        child: _isUploading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(
                                Icons.camera_alt_outlined,
                                size: 28,
                                color: AppTheme.primary,
                              ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _isUploading
                            ? 'Memproses file...'
                            : 'Unggah foto / screenshot bukti selesai (Maks. 5 MB)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // File Preview Card (if file uploaded)
              if (_uploadedFileName != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.cardBorder),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.image_outlined, color: AppTheme.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _uploadedFileName!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _uploadedFileSize ?? '1.2 MB',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!isDone)
                        IconButton(
                          icon: const Icon(Icons.close, size: 18, color: AppTheme.textMuted),
                          onPressed: () {
                            setState(() {
                              _uploadedFileName = null;
                              _uploadedFileSize = null;
                            });
                          },
                        )
                      else
                        const Icon(Icons.check_circle, size: 20, color: AppTheme.success),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pastikan bukti terlihat jelas sebelum dikirim.',
                  style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                ),
              ],
              const SizedBox(height: 32),
              // Submit Button
              PrimaryButton(
                text: isDone ? 'Tugas Selesai Dikumpulkan' : 'Kirim Bukti & Tandai Selesai',
                icon: isDone ? Icons.check_circle : Icons.send_rounded,
                onPressed: isDone ? null : _submitProof,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
