# TODO - Cross-resolution UX + API/UI consistency

## 1) Global text scaling (mobile/tablet/desktop)
- [x] Apply `SettingsProvider.fontScale` to `MediaQuery.textScaler` in `lib/main.dart`.

## 2) Safe-area consistency
- [x] Ensure `ResponsiveCenter` wraps content in `SafeArea` by default in `lib/core/widgets/responsive_layout.dart`.

## 3) Unified loading/empty/error UX patterns
- [x] Add reusable widgets:
  - [x] `lib/core/widgets/app_loading_view.dart`
  - [x] `lib/core/widgets/app_empty_view.dart`
  - [x] `lib/core/widgets/app_error_view.dart`
- [x] Update `HomePage` to use unified widgets instead of ad-hoc states.
- [x] Update `SearchPage` to use unified widgets instead of ad-hoc states.

## 4) Validation
- [ ] Run `flutter analyze`.
- [ ] Run `flutter test` (if tests exist).
- [ ] Manual smoke test across breakpoints (<600, ~800, >=900).

