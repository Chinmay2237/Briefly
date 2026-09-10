import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../home/presentation/widgets/news_card.dart';
import '../provider/bookmark_provider.dart';

class BookmarksPage extends StatelessWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookmarkProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        actions: [
          if (provider.bookmarks.isNotEmpty)
            IconButton(
              tooltip: 'Clear all bookmarks',
              onPressed: () => _confirmClearAll(context, provider),
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: provider.bookmarks.isEmpty
          ? AppEmptyView(
              message:
                  'No saved stories yet.\nTap the bookmark icon on any article to read later.',
              icon: Icon(
                Icons.bookmark_outline_rounded,
                size: 56,
                color: theme.colorScheme.primary,
              ),
            )
          : ResponsiveCenter(
              maxWidth: ResponsiveLayout.maxArticleWidth,
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                itemCount: provider.bookmarks.length,
                itemBuilder: (context, index) {
                  final article = provider.bookmarks[index];
                  return Dismissible(
                    key: Key(article.url),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.delete_outline_rounded,
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                    onDismissed: (_) {
                      provider.removeBookmark(article);
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Article removed from bookmarks'),
                          action: SnackBarAction(
                            label: 'Undo',
                            onPressed: () =>
                                provider.insertBookmark(article, index),
                          ),
                        ),
                      );
                    },
                    child: NewsCard(
                      article: article,
                      index: index,
                      onTap: () => context.push('/detail', extra: article),
                    ),
                  );
                },
              ),
            ),
    );
  }

  void _confirmClearAll(BuildContext context, BookmarkProvider provider) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear all bookmarks?'),
        content: const Text(
          'This will remove all saved articles from your local storage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              provider.clearBookmarks();
            },
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }
}
