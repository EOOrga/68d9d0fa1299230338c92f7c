import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peterson_christopher_ops/main.dart';

void main() {
  testWidgets('navigates through the operations workspace', (tester) async {
    final controller = OperationsController.memory(
      records: screenshotRecords(),
    );

    await tester.pumpWidget(PetersonChristopherApp(controller: controller));

    expect(find.text(AppText.appName), findsOneWidget);
    expect(find.text('Operations queue'), findsNothing);

    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();

    expect(find.text('Operations queue'), findsOneWidget);
    expect(find.text('Sterilizer calibration request'), findsOneWidget);

    await tester.tap(find.text('Patients'));
    await tester.pumpAndSettle();

    expect(find.text('Patient records'), findsOneWidget);
    expect(find.text('Jordan Lee intake review'), findsOneWidget);
  });

  testWidgets('creates a local operations record', (tester) async {
    final controller = OperationsController.memory();

    await tester.pumpWidget(PetersonChristopherApp(controller: controller));

    await tester.tap(find.text('Requests'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('create-record')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('title-field')),
      'Generator filter replacement',
    );
    await tester.enterText(
      find.byKey(const ValueKey('contact-field')),
      'Morgan Lee',
    );
    await tester.enterText(
      find.byKey(const ValueKey('department-field')),
      'Facilities',
    );
    await tester.enterText(
      find.byKey(const ValueKey('date-field')),
      '2026-05-20',
    );
    await tester.enterText(
      find.byKey(const ValueKey('notes-field')),
      'Replace filters and log the service window.',
    );
    await tester.drag(find.byType(ListView).last, const Offset(0, -520));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-record')));
    await tester.pumpAndSettle();

    expect(controller.records, hasLength(1));
    expect(find.text('Generator filter replacement'), findsOneWidget);
  });
}
