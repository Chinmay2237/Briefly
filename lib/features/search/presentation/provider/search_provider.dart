import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/services/storage_service.dart';
import '../../../home/domain/entities/article.dart';
import '../../../home/domain/repository/news_repository.dart';

class SearchProvider extends ChangeNotifier {
  SearchProvider(this._repository);

  final NewsRepository _repository;
  final StorageService _storage = StorageService.instance;

  bool _isLoading = false;
  String _query = '';
  AppException? _error;
  final List<Article> _results = <Article>[];
  final List<String> _history = <String>[];

  bool get isLoading => _isLoading;
  String get query => _query;
  AppException? get error => _error;
  List<Article> get results => List.unmodifiable(_results);
  List<String> get history => List.unmodifiable(_history);

  Future<void> init() async {
    await _storage.init();
    if (_history.isNotEmpty) return;
    _history.addAll(_storage.getRecentSearches());
    notifyListeners();
  }

  Future<void> search(String query) async {
    final trimmedQuery = query.trim();
    _query = trimmedQuery;
    _error = null;
    if (trimmedQuery.isEmpty) {
      _results.clear();
      notifyListeners();
      return;
    }

    if (_isLoading) return;
    _isLoading = true;
    _results.clear();
    notifyListeners();
    try {
      final items = await _repository.fetchTopHeadlines(
        query: trimmedQuery,
        country: AppConstants.defaultCountry,
        page: 1,
      );
      _results
        ..clear()
        ..addAll(items);
      if (!_history.contains(trimmedQuery)) {
        _history.insert(0, trimmedQuery);
        if (_history.length > 6) {
          _history.removeLast();
        }
        await _storage.saveRecentSearches(_history);
      }
    } on AppException catch (e) {
      _error = e;
    } catch (e) {
      _error = UnknownException(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearHistory() async {
    _history.clear();
    await _storage.saveRecentSearches(_history);
    notifyListeners();
  }

  Future<void> refresh() async {
    if (_query.isEmpty) {
      await init();
      return;
    }
    await search(_query);
  }
}
