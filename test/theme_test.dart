import 'package:briefly/core/constants/app_constants.dart';
import 'package:briefly/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTheme', () {
    test(
      'provides distinct light and dark surfaces with readable sheet backgrounds',
      () {
        expect(
          AppTheme.lightTheme.colorScheme.surface,
          isNot(equals(AppTheme.darkTheme.colorScheme.surface)),
        );
        expect(
          AppTheme.lightTheme.colorScheme.onSurface,
          isNot(equals(AppTheme.darkTheme.colorScheme.onSurface)),
        );
        expect(AppTheme.lightTheme.bottomSheetTheme.backgroundColor, isNotNull);
        expect(AppTheme.darkTheme.bottomSheetTheme.backgroundColor, isNotNull);
        expect(
          AppTheme.lightTheme.colorScheme.primary,
          AppConstants.primaryColor,
        );
      },
    );
  });
}
