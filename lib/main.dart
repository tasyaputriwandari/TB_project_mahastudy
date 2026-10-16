import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MahastudyApp());
}

class MahastudyApp extends StatelessWidget {
  const MahastudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahastudy',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      builder: (context, child) {
        if (!kIsWeb) return child ?? const SizedBox.shrink();

        final mediaQuery = MediaQuery.of(context);
        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth.isFinite
                ? constraints.maxWidth.clamp(0.0, 430.0).toDouble()
                : 430.0;
            final height = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : mediaQuery.size.height;
            final isWideLayout = constraints.maxWidth > width;
            final borderRadius = isWideLayout
                ? BorderRadius.circular(24)
                : BorderRadius.zero;

            return ColoredBox(
              color: isWideLayout ? const Color(0xFFE2E8F0) : Colors.white,
              child: Center(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: MediaQuery(
                    data: mediaQuery.copyWith(size: Size(width, height)),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadius,
                        border: isWideLayout
                            ? Border.all(color: const Color(0xFFCBD5E1))
                            : null,
                        boxShadow: isWideLayout
                            ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.12),
                                  blurRadius: 32,
                                  offset: const Offset(0, 12),
                                ),
                              ]
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: child ?? const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
