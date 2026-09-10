import 'package:flutter_test/flutter_test.dart';
import 'package:briefly/features/home/domain/entities/article.dart';

void main() {
  group('Article', () {
    test('parses JSON into a strongly typed article', () {
      final article = Article.fromJson({
        'title': 'AI reshapes newsrooms',
        'description': 'Editors use AI to automate summaries',
        'url': 'https://example.com/article',
        'image': 'https://example.com/image.jpg',
        'publishedAt': '2026-06-29T10:00:00Z',
        'source': {'name': 'Briefly'},
        'content': 'A future-forward story',
      });

      expect(article.title, 'AI reshapes newsrooms');
      expect(article.sourceName, 'Briefly');
      expect(article.readTime, contains('read'));
    });
  });
}
