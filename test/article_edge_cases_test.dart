import 'package:briefly/features/home/domain/entities/article.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Article Edge Cases & Safety', () {
    test('handles missing or empty fields with clean defaults', () {
      final article = Article.fromJson({
        'title': '',
        'description': null,
        'url': '   https://example.com/clean-url   ',
        'image': null,
        'publishedAt': 'invalid-date-string',
        'source': null,
        'content': null,
      });

      expect(article.title, equals('Untitled story'));
      expect(article.description, equals('No description available.'));
      expect(article.url, equals('https://example.com/clean-url'));
      expect(article.imageUrl, isEmpty);
      expect(article.sourceName, equals('Briefly'));
      expect(article.content, isEmpty);
      expect(article.readTime, equals('1 min read'));
    });

    test('calculates accurate read time based on word count', () {
      final longContent = List.generate(500, (index) => 'word').join(' ');
      final article = Article.fromJson({
        'title': 'Long Story',
        'description': 'Description',
        'url': 'https://example.com',
        'content': longContent,
      });

      expect(article.readTime, equals('3 min read'));
    });

    test('toJson and fromJson produce identical round-trip data', () {
      const original = Article(
        title: 'Roundtrip Title',
        description: 'Roundtrip Description',
        url: 'https://example.com/roundtrip',
        imageUrl: 'https://example.com/image.jpg',
        publishedAt: '2026-09-10T15:00:00Z',
        sourceName: 'Roundtrip Publisher',
        content: 'Full story text body',
      );

      final jsonMap = original.toJson();
      final reconstructed = Article.fromJson(jsonMap);

      expect(reconstructed.title, equals(original.title));
      expect(reconstructed.description, equals(original.description));
      expect(reconstructed.url, equals(original.url));
      expect(reconstructed.imageUrl, equals(original.imageUrl));
      expect(reconstructed.sourceName, equals(original.sourceName));
      expect(reconstructed.content, equals(original.content));
    });
  });
}
