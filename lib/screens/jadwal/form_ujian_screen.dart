import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/schedule_item.dart';
import '../../theme/app_theme.dart';

class FormUjianScreen extends StatefulWidget {
  final ScheduleItem? examToEdit;

  const FormUjianScreen({super.key, this.examToEdit});

  bool get isEditing => examToEdit != null;

  @override
  State<FormUjianScreen> createState() => _FormUjianScreenState();
}

class _FormUjianScreenState extends State<FormUjianScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCourse = 'Statistika';
  String _selectedExamType = 'UTS';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 3));
  TimeOfDay _startTime = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  late final TextEditingController _roomController;
  late final TextEditingController _notesController;
  String? _errorMessage;

  final List<String> _examTypes = ['UTS', 'UAS', 'Kuis', 'Responsi'];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      final e = widget.examToEdit!;
      _selectedCourse = e.title.replaceAll(RegExp(r'^(UTS|UAS|Kuis|Responsi)\s+'), '');
      _selectedExamType = e.examType ?? 'UTS';
      if (e.date != null) _selectedDate = e.date!;
      _roomController = TextEditingController(text: e.room);
      _notesController = TextEditingController(text: e.notes ?? '');

      final parts = e.time.replaceAll('–', '-').split('-');
      if (parts.length == 2) {
        final startParts = parts[0].trim().split(':');
        final endParts = parts[1].trim().split(':');
        if (startParts.length == 2 && endParts.length == 2) {
          final sh = int.tryParse(startParts[0]);
          final sm = int.tryParse(startParts[1]);
          final eh = int.tryParse(endParts[0]);
          final em = int.tryParse(endParts[1]);
          if (sh != null && sm != null) _startTime = TimeOfDay(hour: sh, minute: sm);
          if (eh != null && em != null) _endTime = TimeOfDay(hour: eh, minute: em);
        }
      }
    } else {
      _roomController = TextEditingController(text: 'Ruang B.201');
      _notesController = TextEditingController(text: 'Wajib membawa kartu ujian dan kalkulator.');
    }
  }

  @override
  void dispose() {
    _roomController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _formatDate(DateTime date) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    const days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final dayName = days[date.weekday - 1];
    return '$dayName, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(today) ? today : _selectedDate,
      firstDate: today, // Cegah tanggal lampau
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _errorMessage = null;
      });
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _validateAndSave() {
    setState(() => _errorMessage = null);

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final examDay = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);

    // Validasi Tanggal Tidak Boleh Lampau
    if (examDay.isBefore(today)) {
      setState(() => _errorMessage = 'Tanggal ujian tidak boleh di masa lampau.');
      return;
    }

    final room = _roomController.text.trim();
    if (room.isEmpty) {
      setState(() => _errorMessage = 'Ruang ujian wajib diisi.');
      return;
    }

    final formattedTime = '${_formatTime(_startTime)} - ${_formatTime(_endTime)}';
    const dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final dayName = dayNames[_selectedDate.weekday - 1];

    final title = '$_selectedExamType $_selectedCourse';
    final examItem = ScheduleItem(
      id: widget.isEditing ? widget.examToEdit!.id : 'u_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subtitle: '$_selectedExamType • $room',
      time: formattedTime,
      day: dayName,
      room: room,
      locationDetail: 'Lantai 2, Sayap Timur',
      type: ScheduleType.ujian,
      date: _selectedDate,
      dateFormatted: _formatDate(_selectedDate),
      examType: _selectedExamType,
      notes: _notesController.text.trim(),
    );

    if (widget.isEditing) {
      MockData().updateSchedule(examItem);
    } else {
      MockData().addSchedule(examItem);
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogCtx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: AppTheme.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: AppTheme.success, size: 30),
              ),
              const SizedBox(height: 16),
              Text(
                widget.isEditing ? 'Jadwal Ujian Diperbarui!' : 'Jadwal Ujian Tersimpan!',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                '${examItem.title}\n${examItem.dateFormatted}\n${examItem.time} • ${examItem.room}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(dialogCtx);
                    Navigator.pop(context, examItem);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableCourses = MockData().courses.map((c) => c.name).toList();
    if (_selectedCourse != null && !availableCourses.contains(_selectedCourse)) {
      availableCourses.add(_selectedCourse!);
    }

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(Icons.school_rounded, size: 12, color: Colors.white),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'Mahastudy',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(8),
                        child: const Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(Icons.arrow_back, size: 22, color: Color(0xFF172C46)),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.isEditing ? 'Edit Jadwal Ujian' : 'Tambah Jadwal Ujian',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF172C46),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.isEditing
                        ? 'Perbarui detail tanggal, jam, dan ruangan ujian.'
                        : 'Atur jadwal UTS, UAS, atau kuis agar tidak terlewat.',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppTheme.cardBorder),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.dangerLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFDA4AF)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline_rounded, color: AppTheme.danger, size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: AppTheme.danger,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Jenis Ujian & Mata Kuliah
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Jenis Ujian *',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedExamType,
                                  decoration: _buildInputDecoration(),
                                  items: _examTypes
                                      .map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13))))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedExamType = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Mata Kuliah *',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedCourse,
                                  isExpanded: true,
                                  decoration: _buildInputDecoration(),
                                  items: availableCourses
                                      .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13))))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedCourse = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Tanggal Ujian (Dengan Validasi Tidak Boleh Lampau)
                      const Text(
                        'Tanggal Ujian * (Tidak boleh masa lampau)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      InkWell(
                        onTap: _pickDate,
                        borderRadius: BorderRadius.circular(12),
                        child: InputDecorator(
                          decoration: _buildInputDecoration(
                            suffixIcon: const Icon(Icons.calendar_month_outlined, size: 20, color: AppTheme.textSecondary),
                          ),
                          child: Text(_formatDate(_selectedDate), style: const TextStyle(fontSize: 14)),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Waktu Mulai & Waktu Selesai
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Waktu Mulai *',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                ),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () => _pickTime(isStart: true),
                                  borderRadius: BorderRadius.circular(12),
                                  child: InputDecorator(
                                    decoration: _buildInputDecoration(
                                      suffixIcon: const Icon(Icons.access_time, size: 18, color: AppTheme.textSecondary),
                                    ),
                                    child: Text(_formatTime(_startTime), style: const TextStyle(fontSize: 14)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Waktu Selesai *',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                ),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: () => _pickTime(isStart: false),
                                  borderRadius: BorderRadius.circular(12),
                                  child: InputDecorator(
                                    decoration: _buildInputDecoration(
                                      suffixIcon: const Icon(Icons.access_time, size: 18, color: AppTheme.textSecondary),
                                    ),
                                    child: Text(_formatTime(_endTime), style: const TextStyle(fontSize: 14)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Ruang Ujian
                      const Text(
                        'Ruang / Kelas Ujian *',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _roomController,
                        decoration: _buildInputDecoration(hintText: 'Contoh: Ruang B.201'),
                        onChanged: (_) {
                          if (_errorMessage != null) setState(() => _errorMessage = null);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Catatan Ujian (Opsional)
                      const Text(
                        'Catatan Ujian (Opsional)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: _buildInputDecoration(hintText: 'Cth: Bawa kalkulator scientific, open 1 lembar rumus.'),
                      ),

                      const SizedBox(height: 32),

                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: _validateAndSave,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.primary,
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            widget.isEditing ? 'Simpan Perubahan' : 'Simpan Jadwal Ujian',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({Widget? suffixIcon, String? hintText}) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: Colors.white,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
      ),
    );
  }
}
