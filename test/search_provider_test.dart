import 'package:briefly/features/home/domain/entities/article.dart';
import 'package:briefly/features/home/domain/repository/news_repository.dart';
import 'package:briefly/features/search/presentation/provider/search_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSearchNewsRepository implements NewsRepository {
  @override
  Future<List<Article>> fetchTopHeadlines({
    String? category,
    String? query,
    String? country,
    int page = 1,
  }) async {
    if (query == null || query.isEmpty) return [];
    return [
      Article(
        title: 'Result for $query',
        description: 'Description',
        url: 'https://example.com/search',
        imageUrl: 'https://example.com/img.jpg',
        publishedAt: '2026-09-10T12:00:00Z',
        sourceName: 'Search Source',
        content: 'Content',
      ),
    ];
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SearchProvider', () {
    late MockSearchNewsRepository repository;
    late SearchProvider provider;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = MockSearchNewsRepository();
      provider = SearchProvider(repository);
    });

    test('initial state has no query and empty results', () {
      expect(provider.query, isEmpty);
      expect(provider.results, isEmpty);
      expect(provider.isLoading, isFalse);
    });

    test('search updates query and results', () async {
      await provider.search('Flutter');

      expect(provider.query, equals('Flutter'));
      expect(provider.results.length, equals(1));
      expect(provider.results.first.title, contains('Flutter'));
    });

    test('search with empty query clears results', () async {
      await provider.search('Flutter');
      expect(provider.results, isNotEmpty);

      await provider.search('');
      expect(provider.query, isEmpty);
      expect(provider.results, isEmpty);
    });
  });
}
