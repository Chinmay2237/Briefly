import 'package:briefly/features/home/domain/entities/article.dart';
import 'package:briefly/features/home/domain/repository/news_repository.dart';
import 'package:briefly/features/home/presentation/provider/home_provider.dart';
import 'package:flutter_test/flutter_test.dart';

class MockNewsRepository implements NewsRepository {
  List<Article> mockArticles = [
    const Article(
      title: 'Test Headline 1',
      description: 'Description 1',
      url: 'https://example.com/1',
      imageUrl: 'https://example.com/1.jpg',
      publishedAt: '2026-09-10T10:00:00Z',
      sourceName: 'Mock Source',
      content: 'Content 1',
    ),
    const Article(
      title: 'Test Headline 2',
      description: 'Description 2',
      url: 'https://example.com/2',
      imageUrl: 'https://example.com/2.jpg',
      publishedAt: '2026-09-10T11:00:00Z',
      sourceName: 'Mock Source',
      content: 'Content 2',
    ),
  ];

  bool shouldThrowError = false;

  @override
  Future<List<Article>> fetchTopHeadlines({
    String? category,
    String? query,
    String? country,
    int page = 1,
  }) async {
    if (shouldThrowError) {
      throw Exception('Network mock failure');
    }
    return mockArticles;
  }
}

void main() {
  group('HomeProvider', () {
    late MockNewsRepository repository;
    late HomeProvider provider;

    setUp(() {
      repository = MockNewsRepository();
      provider = HomeProvider(repository);
    });

    test('initial state is loading with empty articles', () {
      expect(provider.isLoading, isTrue);
      expect(provider.articles, isEmpty);
      expect(provider.error, isNull);
    });

    test('loadInitialArticles fetches articles successfully', () async {
      await provider.loadInitialArticles();

      expect(provider.isLoading, isFalse);
      expect(provider.articles.length, equals(2));
      expect(provider.articles.first.title, equals('Test Headline 1'));
      expect(provider.error, isNull);
    });

    test(
      'loadInitialArticles updates error state when repository throws',
      () async {
        repository.shouldThrowError = true;
        await provider.loadInitialArticles();

        expect(provider.isLoading, isFalse);
        expect(provider.articles, isEmpty);
        expect(provider.error, isNotNull);
      },
    );

    test('setCategory triggers article reload', () async {
      provider.setCategory('Technology');
      expect(provider.selectedCategory, equals('Technology'));
    });
  });
}
