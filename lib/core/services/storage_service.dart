import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home/domain/entities/article.dart';

class StorageService {
  StorageService._();

  static final StorageService instance = StorageService._();

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    await init();
    await _prefs!.setString(key, value);
  }

  String? getString(String key) => _prefs?.getString(key);

  Future<void> setBool(String key, bool value) async {
    await init();
    await _prefs!.setBool(key, value);
  }

  bool getBool(String key) => _prefs?.getBool(key) ?? false;

  Future<void> setDouble(String key, double value) async {
    await init();
    await _prefs!.setDouble(key, value);
  }

  double getDouble(String key) => _prefs?.getDouble(key) ?? 1.0;

  Future<void> setStringList(String key, List<String> values) async {
    await init();
    await _prefs!.setStringList(key, values);
  }

  List<String> getStringList(String key) =>
      _prefs?.getStringList(key) ?? <String>[];

  Future<void> saveBookmarks(List<Article> articles) async {
    final values = articles
        .map((article) => jsonEncode(article.toJson()))
        .toList(growable: false);
    await setStringList('bookmarks', values);
  }

  List<Article> getBookmarks() {
    final values = getStringList('bookmarks');
    final articles = <Article>[];
    for (final value in values) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) {
          articles.add(Article.fromJson(decoded));
        }
      } catch (_) {
        continue;
      }
    }
    return List.unmodifiable(articles);
  }

  Future<void> saveRecentSearches(List<String> searches) async {
    await setStringList('recent_searches', searches);
  }

  List<String> getRecentSearches() => getStringList('recent_searches');

  Future<void> clearCache() async {
    await init();
    await _prefs!.clear();
  }
}
