import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/schedule_item.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import 'modal_peta_lokasi.dart';
import 'add_schedule_screen.dart';
import 'detail_jadwal_screen.dart';
import 'daftar_mata_kuliah_screen.dart';
import 'form_ujian_screen.dart';
import 'form_kegiatan_screen.dart';

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  final MockData _mockData = MockData();
  ScheduleType _selectedType = ScheduleType.kuliah;
  String _selectedDay = 'Selasa';

  final List<String> _days = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  @override
  void initState() {
    super.initState();
    _mockData.addListener(_onDataChanged);
  }

  @override
  void dispose() {
    _mockData.removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // Filter items based on selected type and day
    final filteredSchedules = _mockData.schedules.where((item) {
      if (item.type != _selectedType) return false;
      if (_selectedType == ScheduleType.kuliah) {
        return item.day == _selectedDay;
      }
      return true;
    }).toList();

    // Sort exams and activities by nearest date
    if (_selectedType == ScheduleType.ujian) {
      filteredSchedules.sort((a, b) {
        if (a.date != null && b.date != null) {
          return a.date!.compareTo(b.date!);
        }
        return 0;
      });
    } else if (_selectedType == ScheduleType.organisasi) {
      filteredSchedules.sort((a, b) {
        if (a.date != null && b.date != null) {
          return a.date!.compareTo(b.date!);
        }
        return 0;
      });
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Brand & Mata Kuliah Action
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              Icons.school_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Mahastudy',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                      // Button to navigate to Daftar Mata Kuliah
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DaftarMataKuliahScreen(),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.menu_book_rounded, size: 14, color: AppTheme.primary),
                              SizedBox(width: 6),
                              Text(
                                'Mata Kuliah',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Jadwal Akademik',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Pantau kuliah, ujian, dan kegiatan kampusmu.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Type filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTypeChip('Jadwal Kuliah', ScheduleType.kuliah),
                        const SizedBox(width: 8),
                        _buildTypeChip('Jadwal Ujian', ScheduleType.ujian),
                        const SizedBox(width: 8),
                        _buildTypeChip('Kegiatan Organisasi', ScheduleType.organisasi),
                      ],
                    ),
                  ),
                  if (_selectedType == ScheduleType.kuliah) ...[
                    const SizedBox(height: 14),
                    // Day Selector chips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _days.map((day) {
                        final isSelected = day == _selectedDay;
                        return InkWell(
                          onTap: () => setState(() => _selectedDay = day),
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? AppTheme.primary : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
                              ),
                            ),
                            child: Text(
                              day,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? Colors.white : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
            // Subtitle indicating active day and count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                _selectedType == ScheduleType.kuliah
                    ? '$_selectedDay, 13 Oktober • ${filteredSchedules.length} mata kuliah'
                    : _selectedType == ScheduleType.ujian
                        ? '${filteredSchedules.length} jadwal ujian terurut tanggal terdekat'
                        : '${filteredSchedules.length} agenda kegiatan terdaftar',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Schedule List
            Expanded(
              child: filteredSchedules.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _selectedType == ScheduleType.kuliah
                                    ? Icons.calendar_today_outlined
                                    : _selectedType == ScheduleType.ujian
                                        ? Icons.assignment_late_outlined
                                        : Icons.groups_outlined,
                                size: 36,
                                color: AppTheme.primary,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              _selectedType == ScheduleType.kuliah
                                  ? 'Tidak ada jadwal pada hari $_selectedDay'
                                  : _selectedType == ScheduleType.ujian
                                      ? 'Belum ada jadwal ujian terdaftar'
                                      : 'Belum ada kegiatan organisasi terdaftar',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.textPrimary),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Gunakan tombol di bawah untuk menambahkan.',
                              style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: filteredSchedules.length,
                      itemBuilder: (context, index) {
                        final item = filteredSchedules[index];
                        return _buildScheduleCard(item);
                      },
                    ),
            ),

            // Bottom Action Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(
                text: _selectedType == ScheduleType.kuliah
                    ? '+ Tambah Jadwal Kuliah'
                    : _selectedType == ScheduleType.ujian
                        ? '+ Tambah Jadwal Ujian'
                        : '+ Tambah Kegiatan Organisasi',
                onPressed: () {
                  _showAddScheduleDialog();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(String label, ScheduleType type) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () => setState(() => _selectedType = type),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.cardBorder,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleItem item) {
    final code = item.title.length > 2 ? item.title.substring(0, 2).toUpperCase() : item.title;

    Color badgeColor = AppTheme.primary;
    if (item.type == ScheduleType.ujian) {
      badgeColor = const Color(0xFFEA580C);
    } else if (item.type == ScheduleType.organisasi) {
      badgeColor = const Color(0xFF7C3AED);
    }

    return InkWell(
      onTap: () => _openDetail(item),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.cardBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Course code avatar
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: badgeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    code,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Info column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            item.dateFormatted != null ? Icons.calendar_month_outlined : Icons.access_time,
                            size: 13,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.dateFormatted != null
                                  ? '${item.dateFormatted} • ${item.time}'
                                  : item.time,
                              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.room_outlined, size: 13, color: AppTheme.textSecondary),
                          const SizedBox(width: 4),
                          Text(
                            item.room,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
                          ),
                        ],
                      ),
                      if (item.notes != null && item.notes!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.notes_rounded, size: 13, color: AppTheme.textMuted),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                item.notes!,
                                style: const TextStyle(fontSize: 11, color: AppTheme.textMuted, fontStyle: FontStyle.italic),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (item.isNew)
                  Container(
                    margin: const EdgeInsets.only(left: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Text(
                      'Baru',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Button: Edit
                OutlinedButton.icon(
                  onPressed: () => _editSchedule(item),
                  icon: const Icon(Icons.edit_outlined, size: 14),
                  label: const Text('Edit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Button: Peta Ruang
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ModalPetaLokasi(
                          courseName: item.title,
                          roomName: item.room,
                          locationDetail: item.locationDetail,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.location_on_outlined, size: 14),
                  label: const Text('Peta Ruang', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    side: const BorderSide(color: AppTheme.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDetail(ScheduleItem item) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) => DetailJadwalScreen(schedule: item),
      ),
    );

    if (!mounted || result == null) return;

    if (result is Map && result['deleted'] == true) {
      setState(() {
        _mockData.schedules.removeWhere((s) => s.id == item.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🗑️ Jadwal ${item.title} berhasil dihapus'),
          backgroundColor: AppTheme.danger,
        ),
      );
    } else if (result is ScheduleItem) {
      setState(() {
        final index = _mockData.schedules.indexWhere((s) => s.id == result.id);
        if (index != -1) {
          _mockData.schedules[index] = result;
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Jadwal ${result.title} berhasil diperbarui!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  Future<void> _editSchedule(ScheduleItem item) async {
    dynamic result;
    if (item.type == ScheduleType.ujian) {
      result = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(builder: (_) => FormUjianScreen(examToEdit: item)),
      );
    } else if (item.type == ScheduleType.organisasi) {
      result = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(builder: (_) => FormKegiatanScreen(activityToEdit: item)),
      );
    } else {
      result = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(
          builder: (_) => AddScheduleScreen(
            scheduleToEdit: item,
            existingSchedules: _mockData.schedules,
          ),
        ),
      );
    }

    if (!mounted || result == null) return;

    if (result is Map && result['deleted'] == true) {
      setState(() {
        _mockData.schedules.removeWhere((s) => s.id == item.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🗑️ Jadwal ${item.title} berhasil dihapus'),
          backgroundColor: AppTheme.danger,
        ),
      );
    } else if (result is ScheduleItem) {
      setState(() {
        final index = _mockData.schedules.indexWhere((s) => s.id == result.id);
        if (index != -1) {
          _mockData.schedules[index] = result;
        }
        _selectedDay = result.day;
        _selectedType = result.type;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Jadwal ${result.title} berhasil diperbarui!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }

  Future<void> _showAddScheduleDialog() async {
    dynamic result;
    if (_selectedType == ScheduleType.ujian) {
      result = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(builder: (_) => const FormUjianScreen()),
      );
    } else if (_selectedType == ScheduleType.organisasi) {
      result = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(builder: (_) => const FormKegiatanScreen()),
      );
    } else {
      result = await Navigator.push<dynamic>(
        context,
        MaterialPageRoute(
          builder: (_) => AddScheduleScreen(existingSchedules: _mockData.schedules),
        ),
      );
    }

    if (result != null && result is ScheduleItem && mounted) {
      setState(() {
        _mockData.schedules.add(result);
        _selectedDay = result.day;
        _selectedType = result.type;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 ${result.title} berhasil ditambahkan!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }
}
