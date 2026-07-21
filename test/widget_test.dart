import 'package:flutter_test/flutter_test.dart';
import 'package:nomnom/main.dart';

void main() {
  testWidgets('App starts and displays welcome message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NomNomApp());
    await tester.pump();

    // Verify that the onboarding welcome screen is shown.
    expect(find.text('Welcome to NomNom'), findsOneWidget);
  });
}
