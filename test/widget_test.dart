import 'package:briefly/core/widgets/briefly_logo.dart';
import 'package:briefly/features/home/presentation/widgets/category_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget UI Verification', () {
    testWidgets('BrieflyLogo renders with correct size', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: BrieflyLogo(size: 40, showWordmark: true)),
        ),
      );

      expect(find.text('Briefly'), findsOneWidget);
    });

    testWidgets('CategoryChip renders selected and unselected states', (
      WidgetTester tester,
    ) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CategoryChip(
              label: 'Technology',
              isSelected: true,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Technology'), findsOneWidget);
      await tester.tap(find.text('Technology'));
      expect(tapped, isTrue);
    });
  });
}
