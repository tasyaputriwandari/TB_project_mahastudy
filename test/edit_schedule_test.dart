import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mahastudy/data/mock_data.dart';
import 'package:mahastudy/models/schedule_item.dart';
import 'package:mahastudy/screens/jadwal/jadwal_screen.dart';
import 'package:mahastudy/screens/jadwal/edit_schedule_screen.dart';

void main() {
  setUp(() {
    // Reset mock schedules before each test
    final mockData = MockData();
    mockData.schedules.clear();
    mockData.schedules.addAll([
      const ScheduleItem(
        id: 's1',
        title: 'Statistika',
        subtitle: 'Kuliah • Ruang A.101',
        time: '10:00 - 11:40',
        day: 'Selasa',
        room: 'Ruang A.101',
        locationDetail: 'Lantai 1, Gedung FTI',
        type: ScheduleType.kuliah,
      ),
      const ScheduleItem(
        id: 's2',
        title: 'Pemrograman Web',
        subtitle: 'Kuliah • Lab Komputer 2',
        time: '13:00 - 14:40',
        day: 'Selasa',
        room: 'Lab Komputer 2',
        locationDetail: 'Lantai 2, Gedung FTI Barat',
        type: ScheduleType.kuliah,
      ),
    ]);
  });

  testWidgets('JadwalScreen displays Edit button on schedule cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: JadwalScreen(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Edit buttons exist
    final editButtons = find.widgetWithText(OutlinedButton, 'Edit');
    expect(editButtons, findsAtLeastNWidgets(1));

    // Verify Peta Ruang buttons exist alongside
    final petaButtons = find.widgetWithText(OutlinedButton, 'Peta Ruang');
    expect(petaButtons, findsAtLeastNWidgets(1));
  });

  testWidgets('AddScheduleScreen in edit mode pre-populates fields and shows Edit UI', (WidgetTester tester) async {
    final schedule = MockData().schedules.first;

    await tester.pumpWidget(
      MaterialApp(
        home: EditScheduleScreen(
          scheduleToEdit: schedule,
          existingSchedules: MockData().schedules,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Title and Subtitle match Figma specs
    expect(find.text('Edit Jadwal Kuliah'), findsOneWidget);
    expect(find.text('Perbarui informasi jadwal kuliahmu.'), findsOneWidget);

    // Verify pre-populated fields
    expect(find.text(schedule.title), findsAtLeastNWidgets(1));
    expect(find.text(schedule.room), findsOneWidget);

    // Verify action buttons
    await tester.ensureVisible(find.text('Simpan Perubahan'));
    expect(find.text('Simpan Perubahan'), findsOneWidget);
    await tester.ensureVisible(find.text('Hapus Jadwal'));
    expect(find.text('Hapus Jadwal'), findsOneWidget);
  });

  testWidgets('Tapping Hapus Jadwal displays confirmation dialog and can cancel', (WidgetTester tester) async {
    final schedule = MockData().schedules.first;

    await tester.pumpWidget(
      MaterialApp(
        home: EditScheduleScreen(
          scheduleToEdit: schedule,
          existingSchedules: MockData().schedules,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Scroll to Hapus Jadwal and tap
    await tester.ensureVisible(find.text('Hapus Jadwal'));
    await tester.tap(find.text('Hapus Jadwal'));
    await tester.pumpAndSettle();

    // Confirmation dialog appears
    expect(find.text('Apakah Anda yakin ingin menghapus jadwal "${schedule.title}"?'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(find.text('Ya, Hapus'), findsOneWidget);

    // Tap Batal
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    // Dialog dismissed and still on Edit screen
    expect(find.text('Edit Jadwal Kuliah'), findsOneWidget);
  });

  testWidgets('Editing schedule in JadwalScreen updates list item', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: JadwalScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Statistika'), findsOneWidget);

    // Tap the first Edit button
    await tester.tap(find.widgetWithText(OutlinedButton, 'Edit').first);
    await tester.pumpAndSettle();

    // In Edit Schedule screen
    expect(find.text('Edit Jadwal Kuliah'), findsOneWidget);

    // Change room name
    final roomField = find.widgetWithText(TextFormField, 'Ruang A.101');
    expect(roomField, findsOneWidget);
    await tester.enterText(roomField, 'Ruang B.305');
    await tester.pumpAndSettle();

    // Scroll to and tap Simpan Perubahan
    await tester.ensureVisible(find.text('Simpan Perubahan'));
    await tester.tap(find.text('Simpan Perubahan'));
    await tester.pumpAndSettle();

    // Success dialog shown
    expect(find.text('Jadwal berhasil diperbarui!'), findsOneWidget);

    // Tap OK
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Back on JadwalScreen with updated room
    expect(find.text('Ruang B.305'), findsOneWidget);
  });

  testWidgets('Deleting schedule via Edit screen removes item from JadwalScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: JadwalScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Statistika'), findsOneWidget);

    // Tap the first Edit button
    await tester.tap(find.widgetWithText(OutlinedButton, 'Edit').first);
    await tester.pumpAndSettle();

    // Scroll to and tap Hapus Jadwal
    await tester.ensureVisible(find.text('Hapus Jadwal'));
    await tester.tap(find.text('Hapus Jadwal'));
    await tester.pumpAndSettle();

    // Confirm deletion
    await tester.tap(find.text('Ya, Hapus'));
    await tester.pumpAndSettle();

    // Statistika is now deleted
    expect(find.text('Statistika'), findsNothing);
  });
}

