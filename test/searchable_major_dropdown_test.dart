import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mahastudy/data/indonesia_majors.dart';
import 'package:mahastudy/screens/auth/register_screen.dart';
import 'package:mahastudy/widgets/searchable_major_dropdown.dart';

void main() {
  group('IndonesiaMajors search logic tests', () {
    test('Empty query returns all majors', () {
      final results = IndonesiaMajors.search('');
      expect(results.isNotEmpty, true);
      expect(results.any((m) => m.name == 'Teknik Informatika'), true);
      expect(results.any((m) => m.name == 'Kedokteran (Pendidikan Dokter)'), true);
    });

    test('Query "tek" predicts engineering & tech majors with high score', () {
      final results = IndonesiaMajors.search('tek');
      expect(results.isNotEmpty, true);
      // Top items should start with "Tek"
      expect(results.first.name.toLowerCase().startsWith('tek'), true);
    });

    test('Query "dkv" predicts "Desain Komunikasi Visual (DKV)" via alias', () {
      final results = IndonesiaMajors.search('dkv');
      expect(results.any((m) => m.name.contains('DKV')), true);
    });

    test('Query "pgsd" predicts "Pendidikan Guru Sekolah Dasar (PGSD)"', () {
      final results = IndonesiaMajors.search('pgsd');
      expect(results.first.name.contains('PGSD'), true);
    });

    test('Query "hukum" predicts "Ilmu Hukum"', () {
      final results = IndonesiaMajors.search('hukum');
      expect(results.any((m) => m.name == 'Ilmu Hukum'), true);
    });
  });

  group('SearchableMajorDropdown widget tests', () {
    testWidgets('renders properly with initial value', (WidgetTester tester) async {
      String selected = 'Teknik Informatika';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SearchableMajorDropdown(
              initialValue: selected,
              onSelected: (val) => selected = val,
            ),
          ),
        ),
      );

      expect(find.text('Program studi'), findsOneWidget);
      expect(find.text('Teknik Informatika'), findsOneWidget);
    });

    testWidgets('typing updates predictions and selecting one triggers onSelected', (WidgetTester tester) async {
      String selected = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: SearchableMajorDropdown(
                initialValue: '',
                onSelected: (val) => selected = val,
              ),
            ),
          ),
        ),
      );

      // Tap on textfield to open dropdown
      final textField = find.byType(TextField);
      await tester.tap(textField);
      await tester.pumpAndSettle();

      // Enter 'Akuntan'
      await tester.enterText(textField, 'Akuntan');
      await tester.pumpAndSettle();

      // Expect to see Akuntansi in the overlay list
      final akuntansiFinder = find.text('Akuntansi', findRichText: true);
      expect(akuntansiFinder, findsWidgets);

      // Tap Akuntansi
      await tester.tap(akuntansiFinder.first);
      await tester.pumpAndSettle();

      expect(selected, 'Akuntansi');
    });

    testWidgets('RegisterScreen contains Program Studi with predictive autocomplete', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: RegisterScreen(),
        ),
      );

      expect(find.text('Program studi'), findsOneWidget);
      expect(find.byType(SearchableMajorDropdown), findsOneWidget);
      expect(find.text('Daftar'), findsOneWidget);
    });
  });
}
