import 'dart:io';

import 'env_loader.dart';

String newsApiKey() {
  const dartDefineKey = String.fromEnvironment(
    'NEWS_API_KEY',
    defaultValue: '',
  );
  if (dartDefineKey.trim().isNotEmpty) {
    return dartDefineKey.trim();
  }

  final processKey = Platform.environment['NEWS_API_KEY'];
  if (processKey != null && processKey.trim().isNotEmpty) {
    return processKey.trim();
  }

  return AppEnv.get('NEWS_API_KEY');
}

String newsApiBaseUrl() {
  const dartDefineUrl = String.fromEnvironment(
    'NEWS_API_BASE_URL',
    defaultValue: '',
  );
  if (dartDefineUrl.trim().isNotEmpty) {
    return dartDefineUrl.trim();
  }

  final processUrl = Platform.environment['NEWS_API_BASE_URL'];
  if (processUrl != null && processUrl.trim().isNotEmpty) {
    return processUrl.trim();
  }

  return AppEnv.get('NEWS_API_BASE_URL');
}
