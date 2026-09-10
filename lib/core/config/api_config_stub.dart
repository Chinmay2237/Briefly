import 'env_loader.dart';

String newsApiKey() {
  const dartDefineKey = String.fromEnvironment(
    'NEWS_API_KEY',
    defaultValue: '',
  );
  if (dartDefineKey.trim().isNotEmpty) {
    return dartDefineKey.trim();
  }

  return AppEnv.get('NEWS_API_KEY');
}

String newsApiBaseUrl() {
  const dartDefineUrl = String.fromEnvironment(
    'NEWS_API_BASE_URL',
    defaultValue: '',
  );
  return dartDefineUrl.trim().isNotEmpty
      ? dartDefineUrl.trim()
      : AppEnv.get('NEWS_API_BASE_URL');
}
