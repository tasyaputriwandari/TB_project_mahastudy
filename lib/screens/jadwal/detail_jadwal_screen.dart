import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/schedule_item.dart';
import '../../theme/app_theme.dart';
import 'add_schedule_screen.dart';
import 'modal_peta_lokasi.dart';

class DetailJadwalScreen extends StatefulWidget {
  final ScheduleItem schedule;

  const DetailJadwalScreen({
    super.key,
    required this.schedule,
  });

  @override
  State<DetailJadwalScreen> createState() => _DetailJadwalScreenState();
}

class _DetailJadwalScreenState extends State<DetailJadwalScreen> {
  late ScheduleItem _currentSchedule;

  @override
  void initState() {
    super.initState();
    _currentSchedule = widget.schedule;
  }

  Color _getTypeColor(ScheduleType type) {
    switch (type) {
      case ScheduleType.kuliah:
        return AppTheme.primary;
      case ScheduleType.ujian:
        return const Color(0xFFEA580C); // Warm Orange
      case ScheduleType.organisasi:
        return const Color(0xFF7C3AED); // Vibrant Purple
    }
  }

  String _getTypeLabel(ScheduleType type) {
    switch (type) {
      case ScheduleType.kuliah:
        return 'Perkuliahan';
      case ScheduleType.ujian:
        return _currentSchedule.examType ?? 'Ujian Kampus';
      case ScheduleType.organisasi:
        return _currentSchedule.organizer ?? 'Organisasi Mahasiswa';
    }
  }

  Future<void> _handleEdit() async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) => AddScheduleScreen(
          scheduleToEdit: _currentSchedule,
          existingSchedules: MockData().schedules,
        ),
      ),
    );

    if (!mounted || result == null) return;

    if (result is Map && result['deleted'] == true) {
      Navigator.pop(context, result);
    } else if (result is ScheduleItem) {
      setState(() {
        _currentSchedule = result;
      });
      Navigator.pop(context, result);
    }
  }

  void _confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Jadwal',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus jadwal "${_currentSchedule.title}"?',
          style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Batal', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              Navigator.pop(context, {'deleted': true, 'id': _currentSchedule.id});
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Ya, Hapus', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor(_currentSchedule.type);
    final code = _currentSchedule.title.length > 2
        ? _currentSchedule.title.substring(0, 2).toUpperCase()
        : _currentSchedule.title;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header
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
                      const Expanded(
                        child: Text(
                          'Detail Jadwal',
                          style: TextStyle(
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
                  const Text(
                    'Informasi lengkap jadwal akademik & kampusmu.',
                    style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppTheme.cardBorder),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Hero Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: typeColor.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  code,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: typeColor,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _currentSchedule.title,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currentSchedule.subtitle,
                                      style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: typeColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text(
                                  _getTypeLabel(_currentSchedule.type),
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: typeColor,
                                  ),
                                ),
                              ),
                              if (_currentSchedule.isNew)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Text(
                                    'Baru',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Information details card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.cardBorder),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Informasi Waktu & Tempat',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 14),

                          _buildDetailRow(
                            icon: Icons.calendar_today_rounded,
                            iconColor: AppTheme.primary,
                            title: 'Hari / Tanggal',
                            value: _currentSchedule.dateFormatted ?? '${_currentSchedule.day}, Terjadwal Mingguan',
                          ),
                          const Divider(height: 20, color: AppTheme.cardBorder),

                          _buildDetailRow(
                            icon: Icons.access_time_rounded,
                            iconColor: const Color(0xFFD97706),
                            title: 'Waktu Pelaksanaan',
                            value: '${_currentSchedule.time} WIB',
                          ),
                          const Divider(height: 20, color: AppTheme.cardBorder),

                          _buildDetailRow(
                            icon: Icons.meeting_room_rounded,
                            iconColor: const Color(0xFF059669),
                            title: 'Ruang / Kelas',
                            value: _currentSchedule.room,
                          ),
                          const Divider(height: 20, color: AppTheme.cardBorder),

                          _buildDetailRow(
                            icon: Icons.location_on_rounded,
                            iconColor: const Color(0xFFDC2626),
                            title: 'Titik Lokasi Kampus',
                            value: _currentSchedule.locationDetail,
                          ),

                          if (_currentSchedule.lecturer != null && _currentSchedule.lecturer!.isNotEmpty) ...[
                            const Divider(height: 20, color: AppTheme.cardBorder),
                            _buildDetailRow(
                              icon: Icons.person_rounded,
                              iconColor: const Color(0xFF7C3AED),
                              title: 'Dosen Pengampu',
                              value: _currentSchedule.lecturer!,
                            ),
                          ],

                          if (_currentSchedule.notes != null && _currentSchedule.notes!.isNotEmpty) ...[
                            const Divider(height: 20, color: AppTheme.cardBorder),
                            _buildDetailRow(
                              icon: Icons.notes_rounded,
                              iconColor: const Color(0xFF475569),
                              title: 'Catatan Khusus',
                              value: _currentSchedule.notes!,
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Primary Action: Lihat Lokasi Peta
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ModalPetaLokasi(
                                courseName: _currentSchedule.title,
                                roomName: _currentSchedule.room,
                                locationDetail: _currentSchedule.locationDetail,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.map_rounded, size: 18),
                        label: const Text(
                          'Lihat Lokasi Ruangan',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Secondary Action: Edit Jadwal
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: _handleEdit,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text(
                          'Edit Jadwal Ini',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primary,
                          side: const BorderSide(color: AppTheme.primary),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Destructive Action: Hapus Jadwal
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: TextButton(
                        onPressed: _confirmDelete,
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFFDC2626),
                        ),
                        child: const Text(
                          'Hapus Jadwal',
                          style: TextStyle(
                            color: Color(0xFFDC2626),
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
