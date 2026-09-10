class Article {
  const Article({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.sourceName,
    required this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    final rawTitle = (json['title'] ?? '').toString().trim();
    final rawDescription = (json['description'] ?? json['content'] ?? '')
        .toString()
        .trim();
    final rawUrl = (json['url'] ?? '').toString().trim();
    final rawImage = (json['image'] ?? json['urlToImage'] ?? '')
        .toString()
        .trim();
    final source = json['source'];
    final rawSource = source is Map
        ? (source['name'] ?? '').toString().trim()
        : '';

    return Article(
      title: rawTitle.isEmpty ? 'Untitled story' : rawTitle,
      description: rawDescription.isEmpty
          ? 'No description available.'
          : rawDescription,
      url: rawUrl,
      imageUrl: rawImage,
      publishedAt: (json['publishedAt'] ?? json['pubDate'] ?? '')
          .toString()
          .trim(),
      sourceName: rawSource.isEmpty ? 'Briefly' : rawSource,
      content: (json['content'] ?? '').toString().trim(),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'url': url,
    'image': imageUrl,
    'publishedAt': publishedAt,
    'source': {'name': sourceName},
    'content': content,
  };

  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String publishedAt;
  final String sourceName;
  final String content;

  String get readTime {
    final words = (content.isEmpty ? description : content)
        .split(RegExp(r'\s+'))
        .length;
    final minutes = (words / 200).ceil();
    return minutes < 1 ? '1 min read' : '$minutes min read';
  }
}
