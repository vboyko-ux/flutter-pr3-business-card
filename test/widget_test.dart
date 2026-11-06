import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/app.dart';
import 'package:business_card/widgets/contact_card.dart';

void main() {
  testWidgets('Візитівка показує дані та перемикає тему', (tester) async {
    // Екран телефонної висоти, щоб ListView побудував усі елементи.
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const BusinessCardApp());

    expect(find.text('Вадим Бойко'), findsOneWidget);
    expect(find.byType(ContactCard), findsNWidgets(4));

    MaterialApp app() => tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app().themeMode, ThemeMode.light);

    await tester.tap(find.text('Змінити тему'));
    await tester.pumpAndSettle();
    expect(app().themeMode, ThemeMode.dark);

    await tester.tap(find.text('Змінити тему'));
    await tester.pumpAndSettle();
    expect(app().themeMode, ThemeMode.light);
  });
}
