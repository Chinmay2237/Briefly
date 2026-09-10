import 'package:briefly/features/bookmarks/presentation/provider/bookmark_provider.dart';
import 'package:briefly/features/home/domain/entities/article.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BookmarkProvider', () {
    late BookmarkProvider provider;

    const sampleArticle = Article(
      title: 'Sample Saved Article',
      description: 'Description',
      url: 'https://example.com/saved-1',
      imageUrl: 'https://example.com/saved-1.jpg',
      publishedAt: '2026-09-10T12:00:00Z',
      sourceName: 'Sample Source',
      content: 'Sample Content',
    );

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      provider = BookmarkProvider();
    });

    test('isBookmarked returns false for unsaved article', () {
      expect(provider.isBookmarked(sampleArticle), isFalse);
    });

    test('toggleBookmark adds and removes article', () async {
      await provider.toggleBookmark(sampleArticle);
      expect(provider.isBookmarked(sampleArticle), isTrue);

      await provider.toggleBookmark(sampleArticle);
      expect(provider.isBookmarked(sampleArticle), isFalse);
    });

    test('clearBookmarks removes all articles', () async {
      await provider.toggleBookmark(sampleArticle);
      expect(provider.bookmarks, isNotEmpty);

      await provider.clearBookmarks();
      expect(provider.bookmarks, isEmpty);
    });
  });
}
