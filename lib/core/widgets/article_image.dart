import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constants/app_constants.dart';

class ArticleImage extends StatelessWidget {
  const ArticleImage({
    super.key,
    required this.imageUrl,
    required this.height,
    this.borderRadius = AppConstants.borderRadius,
    this.heroTag,
  });

  final String imageUrl;
  final double height;
  final double borderRadius;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = imageUrl.trim().isEmpty
        ? 'https://picsum.photos/seed/briefly/900/600'
        : imageUrl.trim();

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: resolvedUrl,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 220),
        memCacheHeight: (height * MediaQuery.devicePixelRatioOf(context))
            .round(),
        placeholder: (_, _) =>
            _ImageFallback(height: height, icon: Icons.image_search_rounded),
        errorWidget: (_, _, _) =>
            _ImageFallback(height: height, icon: Icons.newspaper_outlined),
      ),
    );

    if (heroTag != null && heroTag!.isNotEmpty) {
      return Hero(tag: heroTag!, child: imageWidget);
    }

    return imageWidget;
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback({required this.height, required this.icon});

  final double height;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      width: double.infinity,
      alignment: Alignment.center,
      color: theme.colorScheme.surfaceContainerHighest,
      child: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
    );
  }
}
