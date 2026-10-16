import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home/home_screen.dart';
import 'jadwal/jadwal_screen.dart';
import 'tugas/tugas_screen.dart';
import 'belajar/belajar_screen.dart';
import 'profil/profil_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final bool showAccountCreatedToast;
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.showAccountCreatedToast = false,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => MainNavigationScreenState();
}

class MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;
  bool _showToast = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    if (widget.showAccountCreatedToast) {
      _showToast = true;
      Future.delayed(const Duration(seconds: 4), () {
        if (mounted) setState(() => _showToast = false);
      });
    }
  }

  void switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateTab: switchTab),
      const JadwalScreen(),
      TugasScreen(onNavigateToStudy: () => switchTab(3)),
      const BelajarScreen(),
      const ProfilScreen(),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: screens,
          ),
          // Toast message: "Akun berhasil dibuat"
          if (_showToast)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Akun berhasil dibuat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: AppTheme.cardBorder, width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              index: 0,
              label: 'Home',
              outlineIcon: Icons.home_outlined,
              activeIcon: Icons.home_rounded,
            ),
            _buildNavItem(
              index: 1,
              label: 'Jadwal',
              outlineIcon: Icons.calendar_today_outlined,
              activeIcon: Icons.calendar_month_rounded,
            ),
            _buildNavItem(
              index: 2,
              label: 'Tugas',
              outlineIcon: Icons.assignment_outlined,
              activeIcon: Icons.assignment_rounded,
            ),
            _buildNavItem(
              index: 3,
              label: 'Belajar',
              outlineIcon: Icons.menu_book_outlined,
              activeIcon: Icons.menu_book_rounded,
            ),
            _buildNavItem(
              index: 4,
              label: 'Profil',
              outlineIcon: Icons.person_outline_rounded,
              activeIcon: Icons.person_rounded,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData outlineIcon,
    required IconData activeIcon,
  }) {
    final isSelected = _currentIndex == index;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Active pill capsule indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                isSelected ? activeIcon : outlineIcon,
                size: 22,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
