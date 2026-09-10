import 'package:briefly/core/config/api_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('env parsing', () {
    test('extracts NEWS_API_KEY from .env content', () {
      const envContent = '''
# comment
NEWS_API_KEY="demo-key"
OTHER=value
''';

      expect(parseEnvValue(envContent, 'NEWS_API_KEY'), 'demo-key');
    });

    test('returns empty when the key is missing', () {
      expect(parseEnvValue('OTHER=value', 'NEWS_API_KEY'), isEmpty);
    });
  });
}
