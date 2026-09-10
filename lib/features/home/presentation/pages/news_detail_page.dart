import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/article_image.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../core/widgets/share_bottom_sheet.dart';
import '../../../bookmarks/presentation/provider/bookmark_provider.dart';
import '../../domain/entities/article.dart';

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookmarks = context.watch<BookmarkProvider>();
    final isBookmarked = bookmarks.isBookmarked(article);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Story'),
        actions: [
          IconButton(
            tooltip: isBookmarked ? 'Remove bookmark' : 'Bookmark',
            onPressed: () => bookmarks.toggleBookmark(article),
            icon: Icon(
              isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_border,
            ),
          ),
          IconButton(
            tooltip: 'Share',
            onPressed: () => _showShareSheet(context),
            icon: const Icon(Icons.share_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: ResponsiveCenter(
          maxWidth: ResponsiveLayout.maxArticleWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              LayoutBuilder(
                    builder: (context, constraints) {
                      final imageHeight = (constraints.maxWidth * 0.52)
                          .clamp(190.0, 340.0)
                          .toDouble();

                      return ArticleImage(
                        imageUrl: article.imageUrl,
                        height: imageHeight,
                        heroTag: article.url.isNotEmpty
                            ? 'img_${article.url}'
                            : null,
                      );
                    },
                  )
                  .animate()
                  .fadeIn(duration: 300.ms)
                  .scale(
                    begin: const Offset(0.98, 0.98),
                    end: const Offset(1, 1),
                    curve: Curves.easeOutCubic,
                  ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  article.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.08,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MetaPill(
                      icon: Icons.public_rounded,
                      label: article.sourceName.isEmpty
                          ? 'Briefly'
                          : article.sourceName,
                    ),
                    _MetaPill(
                      icon: Icons.schedule_rounded,
                      label: article.readTime,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  article.description,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  article.content.isEmpty
                      ? 'Read the full article in the original source.'
                      : article.content,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.45),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () =>
                            _openOriginalArticle(context, article.url),
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Open original'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filledTonal(
                      tooltip: 'Share',
                      onPressed: () => _showShareSheet(context),
                      icon: const Icon(Icons.ios_share_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ).animate().fadeIn(duration: 260.ms),
        ),
      ),
    );
  }

  void _showShareSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => ShareBottomSheet(url: article.url, title: article.title),
    );
  }

  Future<void> _openOriginalArticle(BuildContext context, String url) async {
    final trimmedUrl = url.trim();
    final uri = Uri.tryParse(trimmedUrl);
    if (trimmedUrl.isEmpty || uri == null || !uri.hasScheme) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid story URL')));
      return;
    }

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch original article')),
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to open web browser')),
      );
    }
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: theme.colorScheme.onSecondaryContainer),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
