import 'package:flutter/services.dart';

String parseEnvValue(String content, String key) {
  for (final line in content.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) {
      continue;
    }

    final separatorIndex = trimmed.indexOf('=');
    if (separatorIndex <= 0) {
      continue;
    }

    final parsedKey = trimmed.substring(0, separatorIndex).trim();
    if (parsedKey != key) {
      continue;
    }

    return _unquote(trimmed.substring(separatorIndex + 1).trim());
  }

  return '';
}

String _unquote(String value) {
  if (value.length < 2) {
    return value;
  }

  final first = value[0];
  final last = value[value.length - 1];
  if ((first == '"' && last == '"') || (first == "'" && last == "'")) {
    return value.substring(1, value.length - 1).trim();
  }

  return value;
}

class AppEnv {
  AppEnv._();

  static final Map<String, String> _values = {};
  static bool _initialized = false;

  static Future<void> load() async {
    if (_initialized) {
      return;
    }

    final values = <String, String>{};

    // Flutter Web does not support runtime usage of `String.fromEnvironment`.
    // Load environment values from the `.env` asset instead.
    final assetValues = await _readFromAsset();
    for (final key in const ['NEWS_API_KEY', 'NEWS_API_BASE_URL']) {
      final value = assetValues[key];
      if (value != null && value.isNotEmpty) {
        values[key] = value;
      }
    }

    _values.addAll(values);
    _initialized = true;
  }

  static String get(String key) {
    return (_values[key] ?? '').trim();
  }

  static Future<Map<String, String>> _readFromAsset() async {
    try {
      final contents = await rootBundle.loadString('.env');
      return {
        for (final key in const ['NEWS_API_KEY', 'NEWS_API_BASE_URL'])
          key: parseEnvValue(contents, key),
      };
    } on Exception {
      return {};
    }
  }
}
