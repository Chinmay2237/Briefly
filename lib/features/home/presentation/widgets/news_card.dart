import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/article_image.dart';
import '../../domain/entities/article.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.article,
    required this.onTap,
    this.index = 0,
    this.compact = false,
  });

  final Article article;
  final VoidCallback onTap;
  final int index;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final publishedAt = article.publishedAt.length >= 10
        ? article.publishedAt.substring(0, 10)
        : 'Now';

    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = (constraints.maxWidth * 0.56)
            .clamp(160.0, 220.0)
            .toDouble();

        return Padding(
              padding: EdgeInsets.only(bottom: compact ? 10 : 16),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                clipBehavior: Clip.antiAlias,
                elevation: theme.brightness == Brightness.dark ? 0 : 2,
                shadowColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                child: InkWell(
                  onTap: onTap,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.surface,
                          theme.colorScheme.surfaceContainerLow.withValues(
                            alpha: 0.82,
                          ),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.72,
                        ),
                      ),
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadius,
                      ),
                    ),
                    child: compact
                        ? _CompactCardBody(
                            article: article,
                            publishedAt: publishedAt,
                          )
                        : _FullCardBody(
                            article: article,
                            imageHeight: imageHeight,
                            publishedAt: publishedAt,
                          ),
                  ),
                ),
              ),
            )
            .animate(delay: ((index % 5) * 40).ms)
            .fadeIn(duration: 220.ms)
            .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}

class _FullCardBody extends StatelessWidget {
  const _FullCardBody({
    required this.article,
    required this.imageHeight,
    required this.publishedAt,
  });

  final Article article;
  final double imageHeight;
  final String publishedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ArticleImage(
              imageUrl: article.imageUrl,
              height: imageHeight,
              borderRadius: 0,
              heroTag: article.url.isNotEmpty ? 'img_${article.url}' : null,
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: _SourcePill(sourceName: article.sourceName),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: _ArticleTextBlock(
            article: article,
            publishedAt: publishedAt,
            titleStyle: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            titleMaxLines: 3,
          ),
        ),
      ],
    );
  }
}

class _CompactCardBody extends StatelessWidget {
  const _CompactCardBody({required this.article, required this.publishedAt});

  final Article article;
  final String publishedAt;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: 96,
            child: ArticleImage(
              imageUrl: article.imageUrl,
              height: 82,
              borderRadius: 12,
              heroTag: article.url.isNotEmpty ? 'img_${article.url}' : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _ArticleTextBlock(
              article: article,
              publishedAt: publishedAt,
              titleStyle: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
              titleMaxLines: 2,
              compact: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _ArticleTextBlock extends StatelessWidget {
  const _ArticleTextBlock({
    required this.article,
    required this.publishedAt,
    required this.titleStyle,
    required this.titleMaxLines,
    this.compact = false,
  });

  final Article article;
  final String publishedAt;
  final TextStyle? titleStyle;
  final int titleMaxLines;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (compact)
          Text(
            article.sourceName.isEmpty ? 'Briefly' : article.sourceName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        if (compact) const SizedBox(height: 5),
        Text(
          article.title,
          maxLines: titleMaxLines,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        if (!compact) const SizedBox(height: 8),
        if (!compact)
          Text(
            article.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.schedule_rounded,
              size: 15,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                '${article.readTime} · $publishedAt',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SourcePill extends StatelessWidget {
  const _SourcePill({required this.sourceName});

  final String sourceName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.94),
            theme.colorScheme.tertiaryContainer.withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          sourceName.isEmpty ? 'Briefly' : sourceName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
