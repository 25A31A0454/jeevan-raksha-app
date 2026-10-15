
import 'package:flutter_test/flutter_test.dart';
import 'package:jeevan_raksha_app/main.dart';

void main() {
  testWidgets('Splash screen displays correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JeevanRakshaApp());

    expect(find.text('JEEVAN RAKSHA'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(
      find.text('Made for a safer community'),
      findsOneWidget,
    );
  });

  testWidgets('Get Started opens the dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JeevanRakshaApp());

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    expect(
      find.text('Your safety, our priority.'),
      findsOneWidget,
    );
    expect(find.text('Emergency SOS'), findsOneWidget);
    expect(find.text('First Aid Guide'), findsOneWidget);
    expect(find.text('Emergency Contacts'), findsOneWidget);
    expect(find.text('Emergency Resources'), findsOneWidget);
  });

  testWidgets('First Aid Guide opens correctly', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JeevanRakshaApp());

    await tester.tap(find.text('Get Started'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('First Aid Guide'));
    await tester.pumpAndSettle();

    expect(find.text('CPR and cardiac emergencies'), findsOneWidget);
    expect(find.text('Severe bleeding'), findsOneWidget);
    expect(find.text('Burns'), findsOneWidget);
  });
}