import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_demo/main.dart';

void main() {
  testWidgets('App loads splash screen', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const SejiwaApp());

    // Cek apakah teks Sejiwa muncul
    expect(find.text('Sejiwa'), findsOneWidget);
  });
}
