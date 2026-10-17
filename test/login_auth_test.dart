import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mahastudy/data/mock_data.dart';
import 'package:mahastudy/screens/auth/login_screen.dart';
import 'package:mahastudy/screens/auth/register_screen.dart';

void main() {
  setUp(() {
    // Reset registered users
    final mock = MockData();
    mock.registeredUsers; // Access mock instance
  });

  testWidgets('displays error and directs to create account when user is not registered',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    final emailField = find.widgetWithText(TextField, 'nadia@mahasiswa.ac.id');
    expect(emailField, findsOneWidget);

    // Enter an unregistered name or email
    await tester.enterText(emailField, 'Budi Santoso');
    await tester.pumpAndSettle();

    // Tap Login button
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.tap(loginButton);
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pumpAndSettle();

    // Verify error message and redirection button appear
    expect(find.text('Akun Belum Terdaftar'), findsOneWidget);
    expect(find.text('Buat Akun Terlebih Dahulu'), findsOneWidget);

    // Tap 'Buat Akun Terlebih Dahulu' button and verify it navigates to RegisterScreen
    await tester.tap(find.text('Buat Akun Terlebih Dahulu'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text('Buat akun'), findsOneWidget);
  });
}
