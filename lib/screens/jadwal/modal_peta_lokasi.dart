import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';

enum MapLocationState {
  adaLokasi,
  belumAda,
  izinDitolak,
  offline,
}

class ModalPetaLokasi extends StatefulWidget {
  final String courseName;
  final String roomName;
  final String locationDetail;
  final MapLocationState initialState;

  const ModalPetaLokasi({
    super.key,
    required this.courseName,
    required this.roomName,
    required this.locationDetail,
    this.initialState = MapLocationState.adaLokasi,
  });

  @override
  State<ModalPetaLokasi> createState() => _ModalPetaLokasiState();
}

class _ModalPetaLokasiState extends State<ModalPetaLokasi> {
  late MapLocationState _currentState;

  @override
  void initState() {
    super.initState();
    _currentState = widget.initialState;
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
        title: const Text('Lokasi Ruang Kelas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Temukan ruang kelasmu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Lihat lokasi, denah, dan panduan ruangan sebelum kuliah.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // State Selector Chips for FR 11 requirement (Ada Lokasi, Belum Ada, Izin Ditolak, Offline)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildStateChip('Ada Lokasi', MapLocationState.adaLokasi, Icons.check_circle_outline),
                        const SizedBox(width: 8),
                        _buildStateChip('Belum Ada', MapLocationState.belumAda, Icons.help_outline),
                        const SizedBox(width: 8),
                        _buildStateChip('Izin Ditolak', MapLocationState.izinDitolak, Icons.location_disabled_outlined),
                        const SizedBox(width: 8),
                        _buildStateChip('Mode Offline', MapLocationState.offline, Icons.cloud_off_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Map Area / State Views
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _buildStateContent(),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Room Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.apartment_rounded, color: AppTheme.primary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.courseName} • ${widget.roomName}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _currentState == MapLocationState.belumAda
                                ? 'Lokasi belum dipetakan'
                                : widget.locationDetail,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Action button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildBottomButton(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStateChip(String label, MapLocationState state, IconData icon) {
    final isSelected = _currentState == state;
    return InkWell(
      onTap: () => setState(() => _currentState = state),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.primary : AppTheme.cardBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: isSelected ? Colors.white : AppTheme.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStateContent() {
    switch (_currentState) {
      case MapLocationState.adaLokasi:
        return Stack(
          children: [
            CustomPaint(size: Size.infinite, painter: _CampusMapPainter()),
            Positioned(
              top: 140,
              left: 50,
              right: 50,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_on, size: 16, color: AppTheme.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Gedung FTI, ${widget.roomName}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );

      case MapLocationState.belumAda:
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: const Icon(Icons.map_outlined, size: 36, color: AppTheme.textMuted),
              ),
              const SizedBox(height: 12),
              const Text(
                'Titik Lokasi Belum Ada',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 4),
              Text(
                'Lokasi ruangan ${widget.roomName} belum dipetakan pada sistem kampus.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Laporan permintaan denah ruangan telah terkirim ke admin.')),
                  );
                },
                icon: const Icon(Icons.add_location_alt_outlined, size: 16),
                label: const Text('Laporkan / Minta Pemetaan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  side: const BorderSide(color: AppTheme.primary),
                ),
              ),
            ],
          ),
        );

      case MapLocationState.izinDitolak:
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.location_disabled_rounded, size: 36, color: Color(0xFFDC2626)),
              ),
              const SizedBox(height: 12),
              const Text(
                'Izin Lokasi Ditolak',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 4),
              const Text(
                'Aplikasi tidak dapat menampilkan panduan arah GPS karena izin akses lokasi dimatikan.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  setState(() => _currentState = MapLocationState.adaLokasi);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Izin lokasi diaktifkan. Memuat peta kampus...')),
                  );
                },
                icon: const Icon(Icons.settings_outlined, size: 16),
                label: const Text('Aktifkan Izin Lokasi', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                ),
              ),
            ],
          ),
        );

      case MapLocationState.offline:
        return Stack(
          children: [
            CustomPaint(size: Size.infinite, painter: _CampusMapPainter()),
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.cloud_off_rounded, size: 16, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mode Offline • Menampilkan denah tersimpan',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.directions_walk_rounded, color: AppTheme.primary, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Petunjuk offline: Naik tangga timur ke Lantai 2, belok kiri 10 meter.',
                        style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  Widget _buildBottomButton() {
    if (_currentState == MapLocationState.belumAda) {
      return OutlinedButton.icon(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back, size: 16),
        label: const Text('Kembali ke Jadwal'),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: const StadiumBorder(),
        ),
      );
    }

    return PrimaryButton(
      text: _currentState == MapLocationState.offline ? 'Buka Denah Offline' : 'Buka di Google Maps',
      icon: Icons.map_outlined,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_currentState == MapLocationState.offline
                ? 'Denah ruangan offline ${widget.roomName} aktif.'
                : 'Membuka rute ${widget.roomName} di peta GPS kampus...'),
            backgroundColor: AppTheme.primary,
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}

class _CampusMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final buildingPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..style = PaintingStyle.fill;

    final highlightPaint = Paint()
      ..color = const Color(0xFFDBEAFE)
      ..style = PaintingStyle.fill;

    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke;

    final dashPaint = Paint()
      ..color = AppTheme.primary
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    final roadPath = Path()
      ..moveTo(0, size.height * 0.65)
      ..lineTo(size.width, size.height * 0.65)
      ..moveTo(size.width * 0.55, 0)
      ..lineTo(size.width * 0.55, size.height);
    canvas.drawPath(roadPath, roadPaint);

    final r1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(20, 30, size.width * 0.4, 70),
      const Radius.circular(8),
    );
    canvas.drawRRect(r1, buildingPaint);
    _drawLabel(canvas, textPainter, 'Perpustakaan', 40, 55);

    final r2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.65, 40, size.width * 0.28, 80),
      const Radius.circular(8),
    );
    canvas.drawRRect(r2, buildingPaint);
    _drawLabel(canvas, textPainter, 'Gedung D', size.width * 0.68, 70);

    final rTarget = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.35, 175, 100, 80),
      const Radius.circular(10),
    );
    canvas.drawRRect(rTarget, highlightPaint);

    final r3 = RRect.fromRectAndRadius(
      Rect.fromLTWH(30, size.height * 0.73, 110, 60),
      const Radius.circular(8),
    );
    canvas.drawRRect(r3, buildingPaint);
    _drawLabel(canvas, textPainter, 'Auditorium', 45, size.height * 0.76);

    _drawLabel(canvas, textPainter, 'Jl. Kampus Utama', 15, size.height * 0.63, isSmall: true);

    final path = Path()
      ..moveTo(size.width * 0.55, size.height * 0.65)
      ..lineTo(size.width * 0.55, 230)
      ..lineTo(size.width * 0.5, 230);
    canvas.drawPath(path, dashPaint);
  }

  void _drawLabel(Canvas canvas, TextPainter tp, String text, double x, double y, {bool isSmall = false}) {
    tp.text = TextSpan(
      text: text,
      style: TextStyle(
        color: const Color(0xFF64748B),
        fontSize: isSmall ? 10 : 11,
        fontWeight: FontWeight.w600,
      ),
    );
    tp.layout();
    tp.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
