import 'package:flutter_test/flutter_test.dart';
import 'package:mahastudy/main.dart';

void main() {
  testWidgets('Mahastudy app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MahastudyApp());
    expect(find.text('Mahastudy'), findsWidgets);

    // Advance timer past splash duration
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Verify login screen appears
    expect(find.text('Selamat datang'), findsOneWidget);
  });
}
