import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    _load();
  }

  final StorageService _storage = StorageService.instance;
  bool _isDarkMode = false;
  double _fontScale = AppConstants.defaultFontScale;
  String _country = AppConstants.defaultCountry;
  String _language = AppConstants.defaultLanguage;

  bool get isDarkMode => _isDarkMode;
  double get fontScale => _fontScale;
  String get country => _country;
  String get language => _language;

  Future<void> _load() async {
    await _storage.init();
    _isDarkMode = _storage.getBool('dark_mode');
    _fontScale = _storage.getDouble('font_scale');
    _country = _storage.getString('country') ?? AppConstants.defaultCountry;
    _language = _storage.getString('language') ?? AppConstants.defaultLanguage;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDarkMode = value;
    await _storage.setBool('dark_mode', value);
    notifyListeners();
  }

  Future<void> updateFontScale(double value) async {
    final clampedValue = value.clamp(0.85, 1.35).toDouble();
    _fontScale = clampedValue;
    await _storage.setDouble('font_scale', clampedValue);
    notifyListeners();
  }

  Future<void> updateCountry(String value) async {
    _country = value;
    await _storage.setString('country', value);
    notifyListeners();
  }

  Future<void> updateLanguage(String value) async {
    _language = value;
    await _storage.setString('language', value);
    notifyListeners();
  }

  Future<void> clearCache() async {
    await _storage.clearCache();
    notifyListeners();
  }
}
