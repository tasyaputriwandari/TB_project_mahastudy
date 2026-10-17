import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/course.dart';
import '../../theme/app_theme.dart';

class FormMataKuliahScreen extends StatefulWidget {
  final Course? courseToEdit;

  const FormMataKuliahScreen({super.key, this.courseToEdit});

  bool get isEditing => courseToEdit != null;

  @override
  State<FormMataKuliahScreen> createState() => _FormMataKuliahScreenState();
}

class _FormMataKuliahScreenState extends State<FormMataKuliahScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _lecturerController;
  late final TextEditingController _roomController;
  int _selectedSks = 3;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      final c = widget.courseToEdit!;
      _codeController = TextEditingController(text: c.code);
      _nameController = TextEditingController(text: c.name);
      _lecturerController = TextEditingController(text: c.lecturer);
      _roomController = TextEditingController(text: c.room);
      _selectedSks = c.sks;
    } else {
      _codeController = TextEditingController();
      _nameController = TextEditingController();
      _lecturerController = TextEditingController();
      _roomController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _lecturerController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    setState(() => _errorMessage = null);

    final name = _nameController.text.trim();
    final lecturer = _lecturerController.text.trim();
    final room = _roomController.text.trim();
    String code = _codeController.text.trim();

    // 1. Error Nama Kosong
    if (name.isEmpty) {
      setState(() => _errorMessage = 'Nama mata kuliah wajib diisi.');
      return;
    }

    if (lecturer.isEmpty) {
      setState(() => _errorMessage = 'Dosen pengampu wajib diisi.');
      return;
    }

    if (room.isEmpty) {
      setState(() => _errorMessage = 'Ruang / kelas wajib diisi.');
      return;
    }

    // 2. Error Nama Duplikat
    final existingCourses = MockData().courses;
    final isDuplicate = existingCourses.any((c) {
      if (widget.isEditing && c.id == widget.courseToEdit!.id) {
        return false;
      }
      return c.name.toLowerCase() == name.toLowerCase();
    });

    if (isDuplicate) {
      setState(() => _errorMessage = 'Mata kuliah dengan nama "$name" sudah terdaftar (duplikat).');
      return;
    }

    if (code.isEmpty) {
      code = name.length >= 2 ? name.substring(0, 2).toUpperCase() : name.toUpperCase();
    }

    final course = Course(
      id: widget.isEditing ? widget.courseToEdit!.id : 'c_${DateTime.now().millisecondsSinceEpoch}',
      code: code,
      name: name,
      lecturer: lecturer,
      room: room,
      sks: _selectedSks,
    );

    if (widget.isEditing) {
      MockData().updateCourse(course);
    } else {
      MockData().addCourse(course);
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
                widget.isEditing ? 'Mata Kuliah Diperbarui!' : 'Mata Kuliah Ditambahkan!',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                '${course.name} (${course.sks} SKS)\n${course.lecturer}',
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
                    Navigator.pop(context, course);
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
                          widget.isEditing ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah',
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
                        ? 'Perbarui detail data mata kuliah semester ini.'
                        : 'Daftarkan mata kuliah baru ke dalam jadwal studimu.',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppTheme.cardBorder),

            // Form
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

                      // Nama Mata Kuliah
                      const Text(
                        'Nama Mata Kuliah *',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration(hintText: 'Contoh: Kecerdasan Buatan'),
                        onChanged: (_) {
                          if (_errorMessage != null) setState(() => _errorMessage = null);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Dosen Pengampu
                      const Text(
                        'Dosen Pengampu *',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _lecturerController,
                        decoration: _buildInputDecoration(hintText: 'Contoh: Prof. Budi Hartono, M.T'),
                        onChanged: (_) {
                          if (_errorMessage != null) setState(() => _errorMessage = null);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Ruang / Kelas & SKS (Side-by-side)
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Ruang / Kelas *',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _roomController,
                                  decoration: _buildInputDecoration(hintText: 'Cth: Lab AI 1'),
                                  onChanged: (_) {
                                    if (_errorMessage != null) setState(() => _errorMessage = null);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'SKS',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<int>(
                                  initialValue: _selectedSks,
                                  decoration: _buildInputDecoration(),
                                  items: [1, 2, 3, 4, 6]
                                      .map((s) => DropdownMenuItem(value: s, child: Text('$s SKS', style: const TextStyle(fontSize: 13))))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setState(() => _selectedSks = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Kode Singkat Mata Kuliah (Opsional)
                      const Text(
                        'Kode Singkat (Opsional)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _codeController,
                        decoration: _buildInputDecoration(hintText: 'Cth: KB (otomatis jika dikosongkan)'),
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
                            widget.isEditing ? 'Simpan Perubahan' : 'Tambahkan Mata Kuliah',
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

  InputDecoration _buildInputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText,
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
