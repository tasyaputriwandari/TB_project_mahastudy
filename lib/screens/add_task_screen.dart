import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../utils/date_formatter.dart';

/// Screen Form Tambah Tugas Baru.
/// Menjalankan 5 tahap workflow:
/// [INPUT/EVENT] -> [STATE] -> [VALIDATION] -> [FEEDBACK] -> [NAVIGATION]
/// Didesain full-screen mobile dengan background #EAF4FF yang konsisten.
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // ==========================================
  // [STATE] - Deklarasi Controller & Nilai Form
  // ==========================================
  late final TextEditingController _titleController;
  late final TextEditingController _notesController;

  final List<String> _courseList = const [
    'Basis Data',
    'Interaksi Manusia & Komputer',
    'Aljabar Linear',
    'Pemrograman Web',
    'Pemrograman Teknologi Bergerak',
    'Kecerdasan Buatan',
  ];

  String? _selectedCourse;
  DateTime _selectedDeadline = DateTime(2026, 10, 24, 23, 59);
  TaskPriority _selectedPriority = TaskPriority.tinggi;

  bool _titleTouched = false;
  bool _deadlineTouched = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: 'Laporan Praktikum Basis Data');
    _notesController = TextEditingController(
      text: 'Analisis relasi query SQL dan lampirkan screenshot',
    );
    _selectedCourse = _courseList.first; // Default: 'Basis Data'
    _titleController.addListener(_onInputChanged);
  }

  @override
  void dispose() {
    _titleController.removeListener(_onInputChanged);
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // ==========================================
  // [INPUT/EVENT] - Listener Input
  // ==========================================
  void _onInputChanged() {
    setState(() {
      _titleTouched = true;
    });
  }

  // ==========================================
  // [VALIDATION] - Logika Pengecekan Validitas
  // ==========================================
  bool get _isTitleValid => _titleController.text.trim().isNotEmpty;
  bool get _isDeadlineValid => _selectedDeadline.isAfter(DateTime.now());
  bool get _isCourseValid => _selectedCourse != null && _selectedCourse!.isNotEmpty;
  bool get _isFormValid => _isTitleValid && _isDeadlineValid && _isCourseValid;

  // ==========================================
  // [INPUT/EVENT] - Pemilihan Deadline Tanggal & Jam
  // ==========================================
  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline.isAfter(now) ? _selectedDeadline : now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2867E8),
              onPrimary: Colors.white,
              onSurface: Color(0xFF172B4D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null || !mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDeadline),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2867E8),
              onPrimary: Colors.white,
              onSurface: Color(0xFF172B4D),
            ),
          ),
          child: child!,
        );
      },
    );

    if (!mounted) return;

    final selectedHour = pickedTime?.hour ?? _selectedDeadline.hour;
    final selectedMinute = pickedTime?.minute ?? _selectedDeadline.minute;

    setState(() {
      _deadlineTouched = true;
      _selectedDeadline = DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        selectedHour,
        selectedMinute,
      );
    });
  }

  // ==========================================
  // [FEEDBACK] & [NAVIGATION] - Submit Form
  // ==========================================
  void _submitForm() {
    setState(() {
      _titleTouched = true;
      _deadlineTouched = true;
    });

    if (!_isFormValid) return;

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      course: _selectedCourse!,
      deadline: _selectedDeadline,
      priority: _selectedPriority,
      notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      status: TaskStatus.aktif,
      isNew: true, // Flag penanda tugas baru
    );

    _showSuccessDialog(newTask);
  }

  /// [FEEDBACK] Modal Dialog Sukses
  /// Menggunakan batas lebar maksimal 320 px agar tampil proporsional sebagai dialog mobile
  void _showSuccessDialog(Task task) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          backgroundColor: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ikon centang hijau (#16A34A)
                  Container(
                    width: 58,
                    height: 58,
                    decoration: const BoxDecoration(
                      color: Color(0xFFDCFCE7),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF16A34A),
                        size: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Tugas Berhasil Ditambahkan!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF172B4D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Tugas telah tersimpan ke dalam daftar tugas aktifmu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64758D),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Ringkasan Tugas Baru
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryRow(
                          icon: Icons.assignment_outlined,
                          label: 'Judul',
                          value: task.title,
                          isBold: true,
                        ),
                        const Divider(height: 14, thickness: 0.8, color: Color(0xFFE2E8F0)),
                        _buildSummaryRow(
                          icon: Icons.school_outlined,
                          label: 'Mata Kuliah',
                          value: task.course,
                        ),
                        const Divider(height: 14, thickness: 0.8, color: Color(0xFFE2E8F0)),
                        _buildSummaryRow(
                          icon: Icons.access_time_rounded,
                          label: 'Deadline',
                          value: IndonesianDateFormatter.formatShortWithTime(task.deadline),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // [NAVIGATION/RESULT] Tombol "Lihat Daftar Tugas"
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2867E8),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(dialogContext); // Tutup dialog
                        if (mounted) {
                          Navigator.pop(context, task); // Kembalikan task ke TaskScreen
                        }
                      },
                      child: const Text(
                        'Lihat Daftar Tugas',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
    bool isBold = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: const Color(0xFF2867E8)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 10, color: Color(0xFF64758D)),
              ),
              const SizedBox(height: 1),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
                  color: const Color(0xFF172B4D),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final showTitleError = _titleTouched && !_isTitleValid;
    final showDeadlineError = _deadlineTouched && !_isDeadlineValid;

    return Scaffold(
      backgroundColor: const Color(0xFFEAF4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF4FF),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF172B4D), size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Tugas',
          style: TextStyle(
            color: Color(0xFF172B4D),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Isi rincian tugas baru yang ingin dicatat',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64758D),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Container Form Card Putih
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Field 1: Judul Tugas *
                          _buildFieldLabel('Judul Tugas *'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _titleController,
                            onChanged: (val) {
                              setState(() {
                                _titleTouched = true;
                              });
                            },
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF172B4D),
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Contoh: Laporan Praktikum Basis Data',
                              hintStyle: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 12,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: showTitleError
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFFCBD5E1),
                                  width: showTitleError ? 1.5 : 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: showTitleError
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFF2867E8),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                          if (showTitleError) ...[
                            const SizedBox(height: 4),
                            const Text(
                              '⚠️ Judul tugas wajib diisi!',
                              style: TextStyle(
                                color: Color(0xFFDC2626),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],

                          const SizedBox(height: 14),

                          // Field 2: Mata Kuliah *
                          _buildFieldLabel('Mata Kuliah *'),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFFCBD5E1)),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCourse,
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Color(0xFF64758D),
                                  size: 20,
                                ),
                                style: const TextStyle(
                                  color: Color(0xFF172B4D),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedCourse = value;
                                    });
                                  }
                                },
                                items: _courseList.map((course) {
                                  return DropdownMenuItem<String>(
                                    value: course,
                                    child: Text(course),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Field 3: Batas Waktu (Deadline) *
                          _buildFieldLabel('Batas Waktu (Deadline) *'),
                          const SizedBox(height: 6),
                          InkWell(
                            onTap: _pickDeadline,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 11,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: showDeadlineError
                                      ? const Color(0xFFDC2626)
                                      : const Color(0xFFCBD5E1),
                                  width: showDeadlineError ? 1.5 : 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month_rounded,
                                    size: 16,
                                    color: showDeadlineError
                                        ? const Color(0xFFDC2626)
                                        : const Color(0xFF2867E8),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      IndonesianDateFormatter.formatFullWithTime(
                                        _selectedDeadline,
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: showDeadlineError
                                            ? const Color(0xFFDC2626)
                                            : const Color(0xFF172B4D),
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.edit_calendar_outlined,
                                    size: 15,
                                    color: Color(0xFF64758D),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (showDeadlineError) ...[
                            const SizedBox(height: 4),
                            const Text(
                              '⚠️ Deadline tidak boleh di masa lalu!',
                              style: TextStyle(
                                color: Color(0xFFDC2626),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],

                          const SizedBox(height: 14),

                          // Field 4: Prioritas Chip Selector
                          _buildFieldLabel('Prioritas'),
                          const SizedBox(height: 6),
                          Row(
                            children: TaskPriority.values.map((priority) {
                              final isSelected = _selectedPriority == priority;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 2.5),
                                  child: _buildPriorityChip(priority, isSelected),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 14),

                          // Field 5: Catatan Tambahan (Opsional)
                          _buildFieldLabel('Catatan Tambahan (Opsional)'),
                          const SizedBox(height: 6),
                          TextField(
                            controller: _notesController,
                            maxLines: 3,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF172B4D),
                            ),
                            decoration: InputDecoration(
                              hintText: 'Analisis relasi query SQL...',
                              hintStyle: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                              contentPadding: const EdgeInsets.all(10),
                              filled: true,
                              fillColor: const Color(0xFFF8FAFC),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Color(0xFF2867E8),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          const Text(
                            '* Kolom bertanda * wajib diisi',
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF64758D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tombol Simpan Tugas di Bagian Bawah
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF4FF),
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormValid
                        ? const Color(0xFF2867E8)
                        : const Color(0xFFCBD5E1),
                    foregroundColor: Colors.white,
                    elevation: _isFormValid ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isFormValid ? _submitForm : null,
                  child: const Text(
                    'Simpan Tugas',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Color(0xFF172B4D),
      ),
    );
  }

  Widget _buildPriorityChip(TaskPriority priority, bool isSelected) {
    String label;
    switch (priority) {
      case TaskPriority.tinggi:
        label = 'Tinggi';
        break;
      case TaskPriority.sedang:
        label = 'Sedang';
        break;
      case TaskPriority.rendah:
        label = 'Rendah';
        break;
    }

    return InkWell(
      onTap: () {
        setState(() {
          _selectedPriority = priority;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDFEBFF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF2867E8) : const Color(0xFFCBD5E1),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSelected) ...[
              const Icon(Icons.check_rounded, size: 14, color: Color(0xFF2867E8)),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? const Color(0xFF2867E8) : const Color(0xFF64758D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
