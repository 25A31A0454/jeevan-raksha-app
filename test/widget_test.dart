import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jeevan_raksha/main.dart';

void main() {
  testWidgets('shows emergency information and available resources', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JeevanRakshaApp());

    expect(find.text('JEEVAN RAKSHA'), findsOneWidget);
    expect(find.text('Emergency help, even offline.'), findsOneWidget);
    expect(find.text('Need emergency help?'), findsOneWidget);
    expect(find.text('Open dialer for 112'), findsOneWidget);
    expect(find.byIcon(Icons.call), findsOneWidget);

    expect(
      find.text(
        'For immediate danger, contact your local emergency services. '
        'In India, dial 112.',
      ),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('CPR and cardiac emergencies'),
      300,
    );
    expect(find.text('CPR and cardiac emergencies'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Severe bleeding'), 300);
    expect(find.text('Severe bleeding'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Burns'), 300);
    expect(find.text('Burns'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Other emergencies'), 300);
    expect(find.text('Other emergencies'), findsOneWidget);
  });

  testWidgets('shows a placeholder when a resource is selected', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JeevanRakshaApp());

    await tester.scrollUntilVisible(find.text('Burns'), 300);
    await tester.tap(find.text('Burns'));
    await tester.pump();

    expect(
      find.text(
        'Emergency guide content will be added '
        'in the next development stage.',
      ),
      findsOneWidget,
    );
  });
}
