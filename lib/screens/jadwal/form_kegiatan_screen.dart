import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/schedule_item.dart';
import '../../theme/app_theme.dart';

class FormKegiatanScreen extends StatefulWidget {
  final ScheduleItem? activityToEdit;

  const FormKegiatanScreen({super.key, this.activityToEdit});

  bool get isEditing => activityToEdit != null;

  @override
  State<FormKegiatanScreen> createState() => _FormKegiatanScreenState();
}

class _FormKegiatanScreenState extends State<FormKegiatanScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _organizerController;
  late final TextEditingController _locationController;
  late final TextEditingController _notesController;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));
  TimeOfDay _startTime = const TimeOfDay(hour: 16, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 17, minute: 30);
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      final a = widget.activityToEdit!;
      _nameController = TextEditingController(text: a.title);
      _organizerController = TextEditingController(text: a.organizer ?? 'BEM FTI');
      _locationController = TextEditingController(text: a.room);
      _notesController = TextEditingController(text: a.notes ?? '');
      if (a.date != null) _selectedDate = a.date!;

      final parts = a.time.replaceAll('–', '-').split('-');
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
      _nameController = TextEditingController();
      _organizerController = TextEditingController(text: 'BEM FTI');
      _locationController = TextEditingController(text: 'Sekretariat BEM');
      _notesController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _organizerController.dispose();
    _locationController.dispose();
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
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
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

    final name = _nameController.text.trim();
    final organizer = _organizerController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Nama kegiatan organisasi wajib diisi.');
      return;
    }

    if (location.isEmpty) {
      setState(() => _errorMessage = 'Lokasi / ruangan kegiatan wajib diisi.');
      return;
    }

    final formattedTime = '${_formatTime(_startTime)} - ${_formatTime(_endTime)}';
    const dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
    final dayName = dayNames[_selectedDate.weekday - 1];

    final item = ScheduleItem(
      id: widget.isEditing ? widget.activityToEdit!.id : 'org_${DateTime.now().millisecondsSinceEpoch}',
      title: name,
      subtitle: '${organizer.isEmpty ? "Kegiatan Kampus" : organizer} • $location',
      time: formattedTime,
      day: dayName,
      room: location,
      locationDetail: 'Gedung Pusat Kegiatan Mahasiswa Lt. 1',
      type: ScheduleType.organisasi,
      date: _selectedDate,
      dateFormatted: _formatDate(_selectedDate),
      organizer: organizer,
      notes: _notesController.text.trim(),
    );

    if (widget.isEditing) {
      MockData().updateSchedule(item);
    } else {
      MockData().addSchedule(item);
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
                widget.isEditing ? 'Kegiatan Diperbarui!' : 'Kegiatan Ditambahkan!',
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 6),
              Text(
                '${item.title}\n${item.dateFormatted}\n${item.time} • ${item.room}',
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
                    Navigator.pop(context, item);
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
                          widget.isEditing ? 'Edit Kegiatan Organisasi' : 'Tambah Kegiatan Organisasi',
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
                        ? 'Perbarui informasi agenda rapat atau kegiatan organisasi.'
                        : 'Catat rapat, kepanitiaan, atau event kampus agar terjadwal rapi.',
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

                      // Nama Kegiatan
                      const Text(
                        'Nama Kegiatan *',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _nameController,
                        decoration: _buildInputDecoration(hintText: 'Cth: Rapat Pleno BEM FTI'),
                        onChanged: (_) {
                          if (_errorMessage != null) setState(() => _errorMessage = null);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Nama Organisasi / Divisi
                      const Text(
                        'Organisasi / Lembaga (Opsional)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _organizerController,
                        decoration: _buildInputDecoration(hintText: 'Cth: BEM FTI, HIMATIF, DPM'),
                      ),
                      const SizedBox(height: 14),

                      // Tanggal Kegiatan
                      const Text(
                        'Tanggal Kegiatan *',
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

                      // Waktu Mulai & Selesai
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

                      // Lokasi
                      const Text(
                        'Lokasi / Ruangan *',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _locationController,
                        decoration: _buildInputDecoration(hintText: 'Cth: Sekretariat BEM / Selasar Gedung A'),
                        onChanged: (_) {
                          if (_errorMessage != null) setState(() => _errorMessage = null);
                        },
                      ),
                      const SizedBox(height: 14),

                      // Catatan (Opsional)
                      const Text(
                        'Catatan / Agenda (Opsional)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 2,
                        decoration: _buildInputDecoration(hintText: 'Cth: Membawa rancangan anggaran program kerja.'),
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
                            widget.isEditing ? 'Simpan Perubahan' : 'Simpan Kegiatan',
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
