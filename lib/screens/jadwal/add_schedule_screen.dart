import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/schedule_item.dart';
import '../../theme/app_theme.dart';

class AddScheduleScreen extends StatefulWidget {
  final List<ScheduleItem>? existingSchedules;
  final ScheduleItem? scheduleToEdit;

  const AddScheduleScreen({
    super.key,
    this.existingSchedules,
    this.scheduleToEdit,
  });

  bool get isEditing => scheduleToEdit != null;

  @override
  State<AddScheduleScreen> createState() => _AddScheduleScreenState();
}

class _AddScheduleScreenState extends State<AddScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _roomController;
  late final TextEditingController _mapsLinkController;

  String? _selectedCourse = 'Pemrograman Web';
  String _selectedDay = 'Senin';
  ScheduleType _selectedType = ScheduleType.kuliah;
  TimeOfDay _startTime = const TimeOfDay(hour: 13, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 14, minute: 40);

  bool _isMapLocationSelected = false;
  String? _conflictMessage;

  final List<String> _dayOptions = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.scheduleToEdit != null) {
      final s = widget.scheduleToEdit!;
      _selectedCourse = s.title;
      _selectedDay = s.day;
      _selectedType = s.type;
      _roomController = TextEditingController(text: s.room);

      if (s.locationDetail.startsWith('Titik Peta:')) {
        _isMapLocationSelected = true;
        _mapsLinkController = TextEditingController(text: 'maps.app.goo.gl/kampusA');
      } else {
        _isMapLocationSelected = false;
        _mapsLinkController = TextEditingController(text: s.locationDetail);
      }

      final parts = s.time.replaceAll('–', '-').split('-');
      if (parts.length == 2) {
        final startParts = parts[0].trim().split(':');
        final endParts = parts[1].trim().split(':');
        if (startParts.length == 2 && endParts.length == 2) {
          final sh = int.tryParse(startParts[0]);
          final sm = int.tryParse(startParts[1]);
          final eh = int.tryParse(endParts[0]);
          final em = int.tryParse(endParts[1]);
          if (sh != null && sm != null) {
            _startTime = TimeOfDay(hour: sh, minute: sm);
          }
          if (eh != null && em != null) {
            _endTime = TimeOfDay(hour: eh, minute: em);
          }
        }
      }
    } else {
      _roomController = TextEditingController(text: 'Lab Komputer 2');
      _mapsLinkController = TextEditingController(text: 'maps.app.goo.gl/kampusA');
    }
    _checkConflict();
  }

  @override
  void dispose() {
    _roomController.dispose();
    _mapsLinkController.dispose();
    super.dispose();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  int _timeToMinutes(TimeOfDay time) => time.hour * 60 + time.minute;

  void _checkConflict() {
    final existing = widget.existingSchedules ?? MockData().schedules;
    final newStart = _timeToMinutes(_startTime);
    final newEnd = _timeToMinutes(_endTime);

    String? foundConflict;

    for (final item in existing) {
      // Don't conflict with itself when in edit mode
      if (widget.scheduleToEdit != null && item.id == widget.scheduleToEdit!.id) {
        continue;
      }
      if (item.day == _selectedDay && item.type == _selectedType) {
        final parts = item.time.replaceAll('–', '-').split('-');
        if (parts.length == 2) {
          final startParts = parts[0].trim().split(':');
          final endParts = parts[1].trim().split(':');
          if (startParts.length == 2 && endParts.length == 2) {
            final existStart = int.tryParse(startParts[0])! * 60 + int.tryParse(startParts[1])!;
            final existEnd = int.tryParse(endParts[0])! * 60 + int.tryParse(endParts[1])!;

            if (newStart < existEnd && newEnd > existStart) {
              foundConflict = 'Bentrok dengan jadwal ${item.title}, ${item.day} ${item.time}';
              break;
            }
          }
        }
      }
    }

    setState(() {
      _conflictMessage = foundConflict;
    });
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
      _checkConflict();
    }
  }

  bool get _isLocationFilled {
    if (_isMapLocationSelected) return true;
    return _mapsLinkController.text.trim().isNotEmpty;
  }

  bool get _canSave {
    final hasCourse = _selectedCourse != null && _selectedCourse!.isNotEmpty;
    final hasRoom = _roomController.text.trim().isNotEmpty;
    final noConflict = _conflictMessage == null;
    return hasCourse && hasRoom && _isLocationFilled && noConflict;
  }

  void _onSavePressed() {
    if (!_canSave) return;

    final formattedTime = '${_formatTime(_startTime)} - ${_formatTime(_endTime)}';
    final locationDetail = _isMapLocationSelected
        ? 'Titik Peta: Kampus Utama'
        : _mapsLinkController.text.trim();

    final isEdit = widget.isEditing;
    final savedSchedule = isEdit
        ? widget.scheduleToEdit!.copyWith(
            title: _selectedCourse!,
            subtitle: '${_selectedType == ScheduleType.kuliah ? "Kuliah" : "Kegiatan"} • ${_roomController.text.trim()}',
            time: formattedTime,
            day: _selectedDay,
            room: _roomController.text.trim(),
            locationDetail: locationDetail,
            type: _selectedType,
          )
        : ScheduleItem(
            id: 's_${DateTime.now().millisecondsSinceEpoch}',
            title: _selectedCourse!,
            subtitle: '${_selectedType == ScheduleType.kuliah ? "Kuliah" : "Kegiatan"} • ${_roomController.text.trim()}',
            time: formattedTime,
            day: _selectedDay,
            room: _roomController.text.trim(),
            locationDetail: locationDetail,
            type: _selectedType,
            isNew: true,
          );

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppTheme.successLight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: AppTheme.success, size: 34),
                ),
                const SizedBox(height: 18),
                Text(
                  isEdit ? 'Jadwal berhasil diperbarui!' : 'Jadwal berhasil ditambahkan!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '${savedSchedule.title}\n${savedSchedule.day}, ${savedSchedule.time}\n${savedSchedule.room}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      Navigator.pop(context, savedSchedule);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                    child: const Text('OK', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Hapus Jadwal',
            style: TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: AppTheme.textPrimary,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menghapus jadwal "${_selectedCourse ?? widget.scheduleToEdit?.title}"?',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
                Navigator.pop(context, {'deleted': true, 'id': widget.scheduleToEdit!.id}); // Return delete flag
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Ya, Hapus',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
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
            // Page header based on Figma specs
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          size: 12,
                          color: Colors.white,
                        ),
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
                  // Title row with Back button
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
                          widget.isEditing ? 'Edit Jadwal Kuliah' : 'Tambah Jadwal Kuliah',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF172C46),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Supporting text
                  Text(
                    widget.isEditing
                        ? 'Perbarui informasi jadwal kuliahmu.'
                        : 'Isi detail kuliah yang ingin ditambahkan.',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: Color(0xFF52657D),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppTheme.cardBorder),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('* Wajib diisi', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
                      const SizedBox(height: 16),

                      // Mata Kuliah Field
                      const Text(
                        'Mata Kuliah *',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCourse,
                        isExpanded: true,
                        decoration: _buildInputDecoration(hintText: 'Pilih mata kuliah'),
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
                        items: availableCourses
                            .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 14))))
                            .toList(),
                        onChanged: (val) {
                          setState(() => _selectedCourse = val);
                          _checkConflict();
                        },
                      ),

                      const SizedBox(height: 14),

                      // Hari Field
                      const Text(
                        'Hari *',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDay,
                        isExpanded: true,
                        decoration: _buildInputDecoration(hintText: 'Pilih hari'),
                        icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textSecondary),
                        items: _dayOptions
                            .map((d) => DropdownMenuItem(value: d, child: Text(d, style: const TextStyle(fontSize: 14))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedDay = val);
                            _checkConflict();
                          }
                        },
                      ),

                      const SizedBox(height: 14),

                      // Waktu Mulai & Waktu Selesai (Side-by-Side)
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
                                      hintText: 'Pilih jam',
                                      suffixIcon: const Icon(Icons.access_time_outlined, size: 20, color: AppTheme.textSecondary),
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
                                      hintText: 'Pilih jam',
                                      suffixIcon: const Icon(Icons.access_time_outlined, size: 20, color: AppTheme.textSecondary),
                                    ),
                                    child: Text(_formatTime(_endTime), style: const TextStyle(fontSize: 14)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Banner Bentrok
                      if (_conflictMessage != null) ...[
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                  _conflictMessage!,
                                  style: const TextStyle(
                                    color: AppTheme.danger,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 14),

                      // Ruang Field
                      const Text(
                        'Ruang *',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                      ),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _roomController,
                        style: const TextStyle(fontSize: 14),
                        decoration: _buildInputDecoration(
                          hintText: 'Contoh: Lab Komputer 2',
                          suffixIcon: const Icon(Icons.meeting_room_outlined, size: 20, color: AppTheme.textSecondary),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),

                      const SizedBox(height: 14),

                      // Lokasi Field (Toggle Peta vs Tempel Link)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Lokasi *',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
                          ),
                          Text(
                            _isLocationFilled ? 'Lokasi terpilih' : 'Belum diisi',
                            style: TextStyle(
                              fontSize: 11,
                              color: _isLocationFilled ? AppTheme.primary : AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _isMapLocationSelected = true),
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: _isMapLocationSelected ? AppTheme.surface : Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: _isMapLocationSelected
                                        ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.location_on_outlined, size: 16, color: _isMapLocationSelected ? AppTheme.primary : AppTheme.textSecondary),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Pilih titik di peta',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: _isMapLocationSelected ? FontWeight.w600 : FontWeight.normal,
                                          color: _isMapLocationSelected ? AppTheme.primary : AppTheme.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => setState(() => _isMapLocationSelected = false),
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: !_isMapLocationSelected ? AppTheme.surface : Colors.transparent,
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: !_isMapLocationSelected
                                        ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.check_rounded, size: 16, color: !_isMapLocationSelected ? AppTheme.primary : AppTheme.textSecondary),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Tempel link',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: !_isMapLocationSelected ? FontWeight.w600 : FontWeight.normal,
                                          color: !_isMapLocationSelected ? AppTheme.primary : AppTheme.textSecondary,
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

                      const SizedBox(height: 10),

                      if (!_isMapLocationSelected)
                        TextFormField(
                          controller: _mapsLinkController,
                          style: const TextStyle(fontSize: 14),
                          decoration: _buildInputDecoration(
                            labelText: 'Link Google Maps',
                            hintText: 'Tempel link lokasi kampus',
                            suffixIcon: const Icon(Icons.link_rounded, size: 20, color: AppTheme.textSecondary),
                          ),
                          onChanged: (_) => setState(() {}),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.5)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.map_rounded, color: AppTheme.primary, size: 22),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Titik kampus utama terpilih (Gedung A)',
                                  style: TextStyle(fontSize: 12, color: AppTheme.primaryDark, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                        ),

                      const SizedBox(height: 6),
                      const Text(
                        'Wajib diisi. Pilih titik di peta atau tempel link.',
                        style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          _conflictMessage != null
                              ? 'Perbaiki isian sebelum menyimpan.'
                              : _canSave
                                  ? (widget.isEditing ? 'Perubahan siap disimpan' : 'Lokasi valid • Siap disimpan')
                                  : 'Lengkapi isian untuk mengaktifkan Simpan.',
                          style: TextStyle(
                            fontSize: 11,
                            color: _conflictMessage != null ? AppTheme.danger : AppTheme.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Save action button (Figma spec: height 48px, radius 100px, #2563EB)
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: _canSave ? _onSavePressed : null,
                          style: FilledButton.styleFrom(
                            backgroundColor: _canSave ? AppTheme.primary : const Color(0xFFCBD5E1),
                            disabledBackgroundColor: const Color(0xFFE2E8F0),
                            shape: const StadiumBorder(),
                          ),
                          child: Text(
                            widget.isEditing ? 'Simpan Perubahan' : 'Simpan Jadwal',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: _canSave ? Colors.white : const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),

                      // Delete action button (Figma spec: height 38px, text #DC2626)
                      if (widget.isEditing) ...[
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 38,
                          child: TextButton(
                            onPressed: _showDeleteConfirmationDialog,
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFDC2626),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Hapus Jadwal',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: Color(0xFFDC2626),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  InputDecoration _buildInputDecoration({
    String? labelText,
    String? hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      filled: true,
      fillColor: AppTheme.surface,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.cardBorder, width: 1.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
      ),
    );
  }
}
