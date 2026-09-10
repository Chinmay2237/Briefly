import '../entities/article.dart';

abstract class NewsRepository {
  Future<List<Article>> fetchTopHeadlines({
    String? category,
    String? query,
    String? country,
    int page = 1,
  });
}
