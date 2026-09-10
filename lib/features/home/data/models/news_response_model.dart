import '../../domain/entities/article.dart';

class NewsResponseModel {
  const NewsResponseModel({required this.articles});

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) {
    final items = json['articles'] as List<dynamic>? ?? const <dynamic>[];
    return NewsResponseModel(
      articles: items
          .whereType<Map<String, dynamic>>()
          .map(Article.fromJson)
          .toList(growable: false),
    );
  }

  final List<Article> articles;
}
