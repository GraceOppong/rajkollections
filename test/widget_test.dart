import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rajkollections/features/auth/staff_login_screen.dart';
import 'package:rajkollections/main.dart';

void main() {
  testWidgets('App flows splash to login to signing in', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const RajKollectionsApp());
    await tester.pump();

    expect(find.text('Loading your workspace...'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump();
    expect(find.text('Welcome back!'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Staff Login'), findsOneWidget);
    await tester.pump();
    await tester.pump();

    final fields = find.byType(TextField);
    expect(fields, findsNWidgets(2));
    await tester.enterText(fields.at(0), 'staff@rajkollections.com');
    await tester.enterText(fields.at(1), 'secret');
    expect(find.text('staff@rajkollections.com'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('sign-in-button')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('sign-in-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Signing you in...'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 1100));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 450));

    expect(find.textContaining('Kwame!'), findsOneWidget);
    expect(find.text('Today’s Priorities'), findsOneWidget);
    expect(find.text('Pick. Pack.'), findsOneWidget);
    expect(find.text('Deliver.'), findsOneWidget);
  });

  testWidgets('Staff Login builds on iPhone 17 Pro Max size', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(440, 956);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: StaffLoginScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('Staff Login'), findsOneWidget);
    expect(find.byKey(const ValueKey('sign-in-button')), findsOneWidget);
  });
}
