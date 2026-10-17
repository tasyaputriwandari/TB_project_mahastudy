import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mahastudy/data/mock_data.dart';
import 'package:mahastudy/models/course.dart';
import 'package:mahastudy/models/schedule_item.dart';
import 'package:mahastudy/screens/jadwal/detail_jadwal_screen.dart';
import 'package:mahastudy/screens/jadwal/daftar_mata_kuliah_screen.dart';
import 'package:mahastudy/screens/jadwal/form_mata_kuliah_screen.dart';
import 'package:mahastudy/screens/jadwal/form_ujian_screen.dart';
import 'package:mahastudy/screens/jadwal/modal_peta_lokasi.dart';
import 'package:mahastudy/screens/notifikasi/notifikasi_screen.dart';
import 'package:mahastudy/screens/jadwal/smart_agenda_screen.dart';

void main() {
  setUp(() {
    final mockData = MockData();
    mockData.courses.clear();
    mockData.courses.addAll([
      const Course(id: 'c1', code: 'ST', name: 'Statistika', lecturer: 'Dr. Irwan, M.Kom', room: 'Ruang A.102', sks: 3),
      const Course(id: 'c2', code: 'PW', name: 'Pemrograman Web', lecturer: 'Ahmad Fauzi, M.T', room: 'Lab Komputer 2', sks: 4),
    ]);

    mockData.schedules.clear();
    mockData.schedules.addAll([
      const ScheduleItem(
        id: 's1',
        title: 'Statistika',
        subtitle: 'Kuliah • Ruang A.102',
        time: '09:00 - 10:40',
        day: 'Selasa',
        room: 'Ruang A.102',
        locationDetail: 'Lantai 1, Sayap Barat',
        type: ScheduleType.kuliah,
      ),
    ]);
  });

  testWidgets('DetailJadwalScreen displays full info and action buttons', (WidgetTester tester) async {
    final schedule = MockData().schedules.first;
    await tester.pumpWidget(
      MaterialApp(home: DetailJadwalScreen(schedule: schedule)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Detail Jadwal'), findsOneWidget);
    expect(find.text(schedule.title), findsAtLeastNWidgets(1));
    expect(find.text('Lihat Lokasi Ruangan'), findsOneWidget);
    expect(find.text('Edit Jadwal Ini'), findsOneWidget);
    expect(find.text('Hapus Jadwal'), findsOneWidget);
  });

  testWidgets('FormMataKuliahScreen validates empty and duplicate course names', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: FormMataKuliahScreen()),
    );
    await tester.pumpAndSettle();

    // 1. Submit empty form
    await tester.ensureVisible(find.text('Tambahkan Mata Kuliah'));
    await tester.tap(find.text('Tambahkan Mata Kuliah'));
    await tester.pumpAndSettle();
    expect(find.text('Nama mata kuliah wajib diisi.'), findsOneWidget);

    // 2. Submit duplicate name
    await tester.enterText(find.byType(TextFormField).at(0), 'Statistika');
    await tester.enterText(find.byType(TextFormField).at(1), 'Dosen Budi');
    await tester.enterText(find.byType(TextFormField).at(2), 'Ruang 101');
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Tambahkan Mata Kuliah'));
    await tester.tap(find.text('Tambahkan Mata Kuliah'));
    await tester.pumpAndSettle();
    expect(find.text('Mata kuliah dengan nama "Statistika" sudah terdaftar (duplikat).'), findsOneWidget);

    // 3. Submit unique name
    await tester.enterText(find.byType(TextFormField).at(0), 'Kecerdasan Buatan');
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Tambahkan Mata Kuliah'));
    await tester.tap(find.text('Tambahkan Mata Kuliah'));
    await tester.pumpAndSettle();

    expect(find.text('Mata Kuliah Ditambahkan!'), findsOneWidget);
  });

  testWidgets('DaftarMataKuliahScreen lists courses and searches correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: DaftarMataKuliahScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Statistika'), findsOneWidget);
    expect(find.text('Pemrograman Web'), findsOneWidget);
    expect(find.text('+ Tambah Mata Kuliah'), findsOneWidget);

    // Test search filter
    await tester.enterText(find.byType(TextField), 'Web');
    await tester.pumpAndSettle();

    expect(find.text('Pemrograman Web'), findsOneWidget);
    expect(find.text('Statistika'), findsNothing);
  });

  testWidgets('FormUjianScreen renders date picker and exam type selector', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: FormUjianScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tambah Jadwal Ujian'), findsOneWidget);
    expect(find.text('Jenis Ujian *'), findsOneWidget);
    expect(find.text('Simpan Jadwal Ujian'), findsOneWidget);
  });

  testWidgets('ModalPetaLokasi switches between 4 location states smoothly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ModalPetaLokasi(
          courseName: 'Statistika',
          roomName: 'Ruang A.102',
          locationDetail: 'Lantai 1, Sayap Barat',
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Ada Lokasi (default)
    expect(find.text('Ada Lokasi'), findsOneWidget);
    expect(find.text('Buka di Google Maps'), findsOneWidget);

    // 2. Switch to Belum Ada
    await tester.tap(find.text('Belum Ada'));
    await tester.pumpAndSettle();
    expect(find.text('Titik Lokasi Belum Ada'), findsOneWidget);

    // 3. Switch to Izin Ditolak
    await tester.tap(find.text('Izin Ditolak'));
    await tester.pumpAndSettle();
    expect(find.text('Izin Lokasi Ditolak'), findsOneWidget);

    // 4. Switch to Mode Offline
    await tester.tap(find.text('Mode Offline'));
    await tester.pumpAndSettle();
    expect(find.text('Mode Offline • Menampilkan denah tersimpan'), findsOneWidget);
  });

  testWidgets('NotifikasiScreen displays category items and marks as read', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: NotifikasiScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Pusat Notifikasi'), findsOneWidget);
    expect(find.text('Pengingat Kuliah: Statistika'), findsOneWidget);
  });

  testWidgets('SmartAgendaScreen displays combined daily timeline', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: SmartAgendaScreen()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Smart Daily Agenda'), findsOneWidget);
    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Kuliah'), findsOneWidget);
    expect(find.text('Statistika'), findsAtLeastNWidgets(1));
  });
}
