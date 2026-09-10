import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/app_exception.dart';
import '../../domain/entities/article.dart';
import '../../domain/repository/news_repository.dart';

class HomeProvider extends ChangeNotifier {
  HomeProvider(this._repository);

  final NewsRepository _repository;

  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _page = 1;
  String _selectedCategory = 'All';
  String _selectedCountry = AppConstants.defaultCountry;
  String _query = '';
  AppException? _error;
  AppException? _loadMoreError;
  final List<Article> _articles = <Article>[];

  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String get selectedCategory => _selectedCategory;
  String get selectedCountry => _selectedCountry;
  String get query => _query;
  AppException? get error => _error;
  AppException? get loadMoreError => _loadMoreError;
  List<Article> get articles => List.unmodifiable(_articles);

  Future<void> loadInitialArticles() async {
    if (_isLoading && _articles.isNotEmpty) return;
    _page = 1;
    _hasMore = true;
    _error = null;
    _loadMoreError = null;
    _isLoading = true;
    notifyListeners();

    try {
      final items = await _repository.fetchTopHeadlines(
        category: _selectedCategory,
        query: _query,
        country: _selectedCountry,
        page: _page,
      );
      _articles
        ..clear()
        ..addAll(items);
      _hasMore = items.length >= 10;
    } on AppException catch (e) {
      _error = e;
    } catch (e) {
      _error = UnknownException(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshArticles() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    notifyListeners();
    try {
      await loadInitialArticles();
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreArticles() async {
    if (_isLoading || _isRefreshing || _isLoadingMore || !_hasMore) return;
    _page += 1;
    _isLoadingMore = true;
    _loadMoreError = null;
    notifyListeners();
    try {
      final items = await _repository.fetchTopHeadlines(
        category: _selectedCategory,
        query: _query,
        country: _selectedCountry,
        page: _page,
      );
      if (items.isEmpty) {
        _hasMore = false;
      } else {
        _articles.addAll(items);
      }
    } on AppException catch (e) {
      _page -= 1;
      _loadMoreError = e;
    } catch (e) {
      _page -= 1;
      _loadMoreError = UnknownException(e.toString());
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void setCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    loadInitialArticles();
  }

  void setCountry(String country) {
    if (_selectedCountry == country) return;
    _selectedCountry = country;
    loadInitialArticles();
  }

  void setQuery(String query) {
    _query = query;
    if (query.isEmpty) {
      loadInitialArticles();
    }
  }
}
