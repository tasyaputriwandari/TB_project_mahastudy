import 'package:flutter/material.dart';
import '../../data/mock_data.dart';
import '../../models/schedule_item.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';
import 'modal_peta_lokasi.dart';
import 'add_schedule_screen.dart';

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
  Widget build(BuildContext context) {
    // Filter items based on selected type and day
    final filteredSchedules = _mockData.schedules.where((item) {
      if (item.type != _selectedType) return false;
      if (_selectedType == ScheduleType.kuliah) {
        return item.day == _selectedDay;
      }
      return true;
    }).toList();

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
                  // Top Brand
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
                    : '${filteredSchedules.length} jadwal terdaftar',
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
                      child: Text(
                        'Tidak ada jadwal pada hari ini',
                        style: TextStyle(color: AppTheme.textMuted),
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
            // Bottom Action Button: + Tambah Jadwal
            Padding(
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(
                text: '+ Tambah Jadwal',
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

    return Container(
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
                  color: AppTheme.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  code,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
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
                        const Icon(Icons.access_time, size: 13, color: AppTheme.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          item.time,
                          style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
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
    );
  }

  Future<void> _editSchedule(ScheduleItem item) async {
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) => AddScheduleScreen(
          scheduleToEdit: item,
          existingSchedules: _mockData.schedules,
        ),
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
    final result = await Navigator.push<dynamic>(
      context,
      MaterialPageRoute(
        builder: (_) => AddScheduleScreen(existingSchedules: _mockData.schedules),
      ),
    );

    if (result != null && result is ScheduleItem && mounted) {
      setState(() {
        _mockData.schedules.add(result);
        _selectedDay = result.day;
        _selectedType = result.type;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 Jadwal ${result.title} berhasil ditambahkan!'),
          backgroundColor: AppTheme.success,
        ),
      );
    }
  }
}
