import 'package:flutter/material.dart';

import '../../models/study_plan_model.dart';

class AddStudyPlanScreen extends StatefulWidget {
  final dynamic initialPlan;
  const AddStudyPlanScreen({super.key, this.initialPlan});

  @override
  State<AddStudyPlanScreen> createState() => _AddStudyPlanScreenState();
}

class _AddStudyPlanScreenState extends State<AddStudyPlanScreen> {
  static const _navy = Color(0xFF182C46);
  static const _blue = Color(0xFF2563EB);
  static const _muted = Color(0xFF657890);
  static const _border = Color(0xFFDCE6F2);
  static const _error = Color(0xFFD53443);

  final _formKey = GlobalKey<FormState>();
  final _courseController = TextEditingController();
  final _targetController = TextEditingController();

  // STATE: input tanggal dan waktu dikelola sebagai tipe native Flutter.
  late DateTime _selectedDate = _tomorrow();
  TimeOfDay _startTime = const TimeOfDay(hour: 19, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 20, minute: 0);
  String? _dateError;

  DateTime _tomorrow() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + 1);
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialPlan != null) {
      final p = widget.initialPlan;
      _courseController.text = p.courseName ?? '';
      _targetController.text = p.topic ?? '';
    }
  }

  @override
  void dispose() {
    _courseController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}';

  // INPUT/EVENT: membuka date picker bawaan dan memperbarui state setelah dipilih.
  Future<void> _pickDate() async {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isBefore(todayOnly)
          ? todayOnly
          : _selectedDate,
      firstDate: todayOnly,
      lastDate: DateTime(today.year + 5),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: _blue),
        ),
        child: child!,
      ),
    );
    if (!mounted || picked == null) return;
    setState(() {
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
      _dateError = null;
    });
  }

  // INPUT/EVENT: pilih waktu mulai lalu waktu selesai melalui picker native.
  Future<void> _pickTime() async {
    final start = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (!mounted || start == null) return;

    final end = await showTimePicker(context: context, initialTime: _endTime);
    if (!mounted || end == null) return;

    setState(() {
      _startTime = start;
      _endTime = end;
    });
  }

  // VALIDATION: seluruh isian wajib dan tanggal harus hari ini atau setelahnya.
  void _save() {
    final fieldsValid = _formKey.currentState!.validate();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateValid = !_selectedDate.isBefore(today);

    setState(() {
      _dateError = dateValid ? null : 'Tanggal tidak boleh di masa lalu';
    });
    if (!fieldsValid || !dateValid) return;

    final plan = StudyPlan(
      course: _courseController.text.trim(),
      date: _selectedDate,
      startTime: _startTime,
      endTime: _endTime,
      target: _targetController.text.trim(),
    );

    // NAVIGATION: kembalikan data baru ke daftar; daftar menampilkan feedback sukses.
    Navigator.pop(context, plan);
  }

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: _muted, fontSize: 14),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _border),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _blue, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: _error, width: 1.5),
    ),
  );

  Widget _fieldLabel(String label) => Padding(
    padding: const EdgeInsets.only(bottom: 7),
    child: Text(
      '$label *',
      style: const TextStyle(
        color: _navy,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  Widget _dateField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _fieldLabel('Tanggal'),
      InkWell(
        key: const Key('study-plan-date'),
        borderRadius: BorderRadius.circular(12),
        onTap: _pickDate,
        child: InputDecorator(
          decoration: _inputDecoration().copyWith(
            errorText: _dateError,
            suffixIcon: const Icon(
              Icons.calendar_month_outlined,
              color: _muted,
            ),
          ),
          child: Text(
            StudyPlan.formatDate(_selectedDate),
            style: const TextStyle(color: _navy, fontSize: 14),
          ),
        ),
      ),
    ],
  );

  Widget _timeField() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _fieldLabel('Waktu'),
      InkWell(
        key: const Key('study-plan-time'),
        borderRadius: BorderRadius.circular(12),
        onTap: _pickTime,
        child: InputDecorator(
          decoration: _inputDecoration().copyWith(
            suffixIcon: const Icon(Icons.schedule_outlined, color: _muted),
          ),
          child: Text(
            '${_formatTime(_startTime)} – ${_formatTime(_endTime)}',
            style: const TextStyle(color: _navy, fontSize: 14),
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 64,
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Kembali',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: _navy),
                  ),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.initialPlan != null
                            ? 'Edit Rencana Belajar'
                            : 'Tambah Rencana Belajar',
                        style: const TextStyle(
                          color: _navy,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  children: [
                    const Text(
                      'Atur waktu dan target belajarmu. Mulai dari satu rencana kecil.',
                      style: TextStyle(
                        color: _muted,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_outlined,
                          size: 14,
                          color: _blue,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Hari ini: ${StudyPlan.formatDate(today)}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: _blue,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    _fieldLabel('Mata Kuliah'),
                    TextFormField(
                      key: const Key('study-plan-course'),
                      controller: _courseController,
                      textCapitalization: TextCapitalization.words,
                      decoration: _inputDecoration(hint: 'Nama mata kuliah'),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Mata kuliah wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 18),
                    _dateField(),
                    const SizedBox(height: 18),
                    _timeField(),
                    const SizedBox(height: 18),
                    _fieldLabel('Target Belajar'),
                    TextFormField(
                      key: const Key('study-plan-target'),
                      controller: _targetController,
                      minLines: 3,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: _inputDecoration(
                        hint:
                            'Contoh: Memahami materi dan mengerjakan latihan.',
                      ),
                      validator: (value) =>
                          value == null || value.trim().isEmpty
                          ? 'Target belajar wajib diisi'
                          : null,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '* Semua field wajib diisi',
                    style: TextStyle(color: _muted, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      key: const Key('save-study-plan'),
                      onPressed: _save,
                      style: FilledButton.styleFrom(
                        backgroundColor: _blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        widget.initialPlan != null
                            ? 'Simpan Perubahan'
                            : 'Simpan Rencana',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
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
}
