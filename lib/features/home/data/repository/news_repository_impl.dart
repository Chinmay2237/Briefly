import '../../domain/entities/article.dart';
import '../../domain/repository/news_repository.dart';
import '../datasource/news_remote_datasource.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl(this._remoteDataSource);

  final NewsRemoteDataSource _remoteDataSource;

  @override
  Future<List<Article>> fetchTopHeadlines({
    String? category,
    String? query,
    String? country,
    int page = 1,
  }) async {
    final response = await _remoteDataSource.fetchTopHeadlines(
      category: category,
      query: query,
      country: country,
      page: page,
    );
    return response.articles;
  }
}
