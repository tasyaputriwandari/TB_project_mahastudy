import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/task_item.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class FormTambahTugasScreen extends StatefulWidget {
  const FormTambahTugasScreen({super.key});

  @override
  State<FormTambahTugasScreen> createState() => _FormTambahTugasScreenState();
}

class _FormTambahTugasScreenState extends State<FormTambahTugasScreen> {
  final MockData _mockData = MockData();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  String? _selectedCourseId = 'c1';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 23, minute: 59);
  TaskPriority _selectedPriority = TaskPriority.sedang;
  
  String? _titleError;

  void _pickDateTime() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && mounted) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );
      if (pickedTime != null && mounted) {
        setState(() {
          _selectedDate = pickedDate;
          _selectedTime = pickedTime;
        });
      }
    }
  }

  void _saveTask() {
    setState(() => _titleError = null);
    if (_titleController.text.trim().isEmpty) {
      setState(() => _titleError = 'Judul tugas wajib diisi');
      return;
    }

    final course = _mockData.courses.firstWhere((c) => c.id == _selectedCourseId);
    final deadlineDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final newTask = TaskItem(
      id: 't_${DateTime.now().millisecondsSinceEpoch}',
      courseId: course.id,
      courseName: course.name,
      title: _titleController.text.trim(),
      deadlineText: '${_selectedDate.day}/${_selectedDate.month}, ${_selectedTime.format(context)}',
      deadline: deadlineDateTime,
      priority: _selectedPriority,
      status: TaskStatus.belum,
      notes: _notesController.text.trim(),
    );

    _mockData.addTask(newTask);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tugas berhasil ditambahkan!'),
        backgroundColor: AppTheme.success,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Tambah Tugas'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Isi data tugas yang ingin dicatat.',
                style: TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              // Judul Tugas
              CustomTextField(
                label: 'Judul Tugas *',
                hint: 'Contoh: Laporan Modul 2',
                controller: _titleController,
                errorText: _titleError,
              ),
              const SizedBox(height: 16),
              // Mata Kuliah Dropdown
              const Text(
                'Mata Kuliah *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCourseId,
                icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.cardBorder, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
                  ),
                ),
                items: _mockData.courses.map((c) {
                  return DropdownMenuItem(
                    value: c.id,
                    child: Text(c.name, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedCourseId = val),
              ),
              const SizedBox(height: 16),
              // Batas Waktu Picker
              const Text(
                'Batas Waktu (Deadline) *',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: _pickDateTime,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.cardBorder, width: 1.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year} pukul ${_selectedTime.format(context)}',
                        style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary),
                      ),
                      const Icon(Icons.calendar_today_outlined, size: 18, color: AppTheme.textSecondary),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Prioritas Selector
              const Text(
                'Prioritas',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPriorityChip('Tinggi', TaskPriority.tinggi),
                  const SizedBox(width: 10),
                  _buildPriorityChip('Sedang', TaskPriority.sedang),
                  const SizedBox(width: 10),
                  _buildPriorityChip('Rendah', TaskPriority.rendah),
                ],
              ),
              const SizedBox(height: 18),
              // Catatan Tambahan
              CustomTextField(
                label: 'Catatan Tambahan (Opsional)',
                hint: 'Tuliskan detail atau instruksi tugas...',
                controller: _notesController,
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              const Text(
                '* Kolom bertanda * wajib diisi.',
                style: TextStyle(fontSize: 11, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 32),
              PrimaryButton(
                text: 'Simpan Tugas',
                onPressed: _saveTask,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityChip(String label, TaskPriority priority) {
    final isSelected = _selectedPriority == priority;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedPriority = priority),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryLight : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected) ...[
                const Icon(Icons.check, size: 14, color: AppTheme.primary),
                const SizedBox(width: 4),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppTheme.primary : AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
