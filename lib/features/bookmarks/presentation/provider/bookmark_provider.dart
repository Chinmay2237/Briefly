import 'package:flutter/foundation.dart';

import '../../../../core/services/storage_service.dart';
import '../../../home/domain/entities/article.dart';

class BookmarkProvider extends ChangeNotifier {
  BookmarkProvider() {
    _loadBookmarks();
  }

  final StorageService _storage = StorageService.instance;
  final List<Article> _bookmarks = <Article>[];

  List<Article> get bookmarks => List.unmodifiable(_bookmarks);

  Future<void> _loadBookmarks() async {
    await _storage.init();
    _bookmarks
      ..clear()
      ..addAll(_storage.getBookmarks());
    notifyListeners();
  }

  Future<void> toggleBookmark(Article article) async {
    final exists = _bookmarks.any((item) => item.url == article.url);
    if (exists) {
      _bookmarks.removeWhere((item) => item.url == article.url);
    } else {
      _bookmarks.insert(0, article);
    }
    await _storage.saveBookmarks(_bookmarks);
    notifyListeners();
  }

  Future<void> removeBookmark(Article article) async {
    _bookmarks.removeWhere((item) => item.url == article.url);
    await _storage.saveBookmarks(_bookmarks);
    notifyListeners();
  }

  Future<void> insertBookmark(Article article, int index) async {
    final safeIndex = index.clamp(0, _bookmarks.length);
    _bookmarks.insert(safeIndex, article);
    await _storage.saveBookmarks(_bookmarks);
    notifyListeners();
  }

  Future<void> clearBookmarks() async {
    _bookmarks.clear();
    await _storage.saveBookmarks(_bookmarks);
    notifyListeners();
  }

  bool isBookmarked(Article article) =>
      _bookmarks.any((item) => item.url == article.url);
}
