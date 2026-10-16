import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_button.dart';

class ModalPetaLokasi extends StatelessWidget {
  final String courseName;
  final String roomName;
  final String locationDetail;

  const ModalPetaLokasi({
    super.key,
    required this.courseName,
    required this.roomName,
    required this.locationDetail,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Lokasi Ruang Kelas'),
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
                    'Lihat lokasi dan detail ruang sebelum kuliah.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Map Canvas Simulation
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9), // Map background
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.cardBorder),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // Simulated campus floorplan / map graphic
                      CustomPaint(
                        size: Size.infinite,
                        painter: _CampusMapPainter(),
                      ),
                      // Target Room Callout
                      Positioned(
                        top: 140,
                        left: 60,
                        right: 60,
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
                              Text(
                                'Gedung FTI, $roomName',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Pin Marker
                      Positioned(
                        top: 190,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.school, size: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Bottom Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(16),
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
                            '$courseName • $roomName',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            locationDetail,
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
            const SizedBox(height: 16),
            // Action button: Buka di Google Maps
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: PrimaryButton(
                text: 'Buka di Google Maps',
                icon: Icons.map_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Membuka rute $roomName di peta GPS kampus...'),
                      backgroundColor: AppTheme.primary,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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

    // Draw campus roads
    final roadPath = Path()
      ..moveTo(0, size.height * 0.65)
      ..lineTo(size.width, size.height * 0.65)
      ..moveTo(size.width * 0.55, 0)
      ..lineTo(size.width * 0.55, size.height);
    canvas.drawPath(roadPath, roadPaint);

    // Building: Perpustakaan
    final r1 = RRect.fromRectAndRadius(
      Rect.fromLTWH(20, 30, size.width * 0.4, 70),
      const Radius.circular(8),
    );
    canvas.drawRRect(r1, buildingPaint);
    _drawLabel(canvas, textPainter, 'Perpustakaan', 40, 55);

    // Building: Gedung D
    final r2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.65, 40, size.width * 0.28, 80),
      const Radius.circular(8),
    );
    canvas.drawRRect(r2, buildingPaint);
    _drawLabel(canvas, textPainter, 'Gedung D', size.width * 0.68, 70);

    // Target Building: Gedung FTI (Highlighted)
    final rTarget = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.35, 175, 100, 80),
      const Radius.circular(10),
    );
    canvas.drawRRect(rTarget, highlightPaint);

    // Building: Auditorium
    final r3 = RRect.fromRectAndRadius(
      Rect.fromLTWH(30, size.height * 0.73, 110, 60),
      const Radius.circular(8),
    );
    canvas.drawRRect(r3, buildingPaint);
    _drawLabel(canvas, textPainter, 'Auditorium', 45, size.height * 0.76);

    // Label Road: Jl. Kampus Utama
    _drawLabel(canvas, textPainter, 'Jl. Kampus Utama', 15, size.height * 0.63, isSmall: true);

    // Dotted Walking Path
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
