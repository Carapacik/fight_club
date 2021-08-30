import 'package:fightclub/main.dart';
import 'package:fightclub/pages/main_page.dart';
import 'package:fightclub/pages/statistics_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_helpers.dart';

void module3() {
  testWidgets('module3', (WidgetTester tester) async {
    await tester.pumpWidget(App());

    final gestureDetectorFinder = findTypeByTextOnlyInParentType(GestureDetector, "Statistics".toUpperCase(), Column);
    expect(
      gestureDetectorFinder,
      findsOneWidget,
      reason: "There  should be a GestureDetector with text 'STATISTICS' in Column",
    );

    final GestureDetector gestureDetector = tester.widget(gestureDetectorFinder);
    expect(
      gestureDetector.onTap,
      isNotNull,
      reason: "GestureDetector should have not null onTap method",
    );

    await tester.tap(gestureDetectorFinder);
    await tester.pumpAndSettle();

    expect(
      find.byType(StatisticsPage),
      findsOneWidget,
      reason: "StatisticsPage should be opened after tap on 'STATISTICS' button",
    );

    expect(
      find.byType(MainPage, skipOffstage: false),
      findsOneWidget,
      reason: "MainPage should be in a tree but offstage",
    );
  });
}
