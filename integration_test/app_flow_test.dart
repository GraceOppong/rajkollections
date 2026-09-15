import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:rajkollections/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('splash runs, login accepts input, Sign In advances', (
    tester,
  ) async {
    await tester.pumpWidget(const RajKollectionsApp());

    // Splash sequence is purely timed, so wait it out on the real device.
    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Staff Login'), findsOneWidget);

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));

    // Tapping must focus the field: this is what dies when the platform
    // thread is blocked, since focus round-trips through the text input
    // channel.
    await tester.tap(fields.first);
    await tester.pumpAndSettle();
    expect(
      FocusManager.instance.primaryFocus?.hasPrimaryFocus,
      isTrue,
      reason: 'email field did not take focus after tap',
    );

    await tester.enterText(fields.first, 'staff@rajkollections.com');
    await tester.pumpAndSettle();
    expect(find.text('staff@rajkollections.com'), findsOneWidget);

    await tester.tap(fields.last);
    await tester.pumpAndSettle();
    await tester.enterText(fields.last, 'secret123');
    await tester.pumpAndSettle();

    // Password is obscured, so assert on the controller-backed value.
    expect(
      tester.widget<TextField>(fields.last).controller?.text,
      'secret123',
    );

    // Toggle visibility - proves the suffix IconButton is hit-testable.
    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('sign-in-button')));

    // The signing-in screen spins a CircularProgressIndicator forever, so it
    // never settles; pump fixed durations instead.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Staff Login'), findsNothing);
    expect(find.text('Signing you in...'), findsOneWidget);
    expect(find.text('Verifying credentials'), findsOneWidget);

    // Let the simulated steps advance and confirm the isolate stays alive.
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 1200));
    expect(find.byIcon(Icons.check), findsNWidgets(2));

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.text('Signing you in...'), findsNothing);
    expect(find.text('Today’s Priorities'), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);
    expect(find.textContaining('Kwame!'), findsOneWidget);
  });
}
