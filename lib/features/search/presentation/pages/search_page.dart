import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../home/presentation/widgets/news_card.dart';
import '../../../home/presentation/widgets/news_card_skeleton.dart';
import '../provider/search_provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchProvider>().init();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      context.read<SearchProvider>().search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SearchProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Search News')),
      body: RefreshIndicator(
        onRefresh: provider.refresh,
        child: ResponsiveCenter(
          maxWidth: ResponsiveLayout.maxArticleWidth,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            slivers: [
              SliverToBoxAdapter(
                child:
                    Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: TextField(
                            controller: _controller,
                            onChanged: _onQueryChanged,
                            decoration: InputDecoration(
                              hintText: 'Search stories, topics, keywords',
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.borderRadius,
                                ),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  _controller.clear();
                                  provider.search('');
                                },
                                icon: const Icon(Icons.clear),
                              ),
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              _debounceTimer?.cancel();
                              provider.search(value);
                            },
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 240.ms)
                        .slideY(begin: 0.08, end: 0),
              ),
              if (provider.history.isNotEmpty) ...[
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent searches',
                          style: theme.textTheme.titleMedium,
                        ),
                        TextButton(
                          onPressed: provider.clearHistory,
                          child: const Text('Clear all'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: provider.history
                          .map(
                            (item) => ActionChip(
                              avatar: const Icon(
                                Icons.history_rounded,
                                size: 16,
                              ),
                              label: Text(
                                item,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onPressed: () {
                                _controller.text = item;
                                provider.search(item);
                              },
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ],
              if (provider.isLoading)
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(const [
                      NewsCardSkeleton(compact: true),
                      NewsCardSkeleton(compact: true),
                      NewsCardSkeleton(compact: true),
                    ]),
                  ),
                )
              else if (provider.error != null)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppErrorView(
                    error: provider.error!,
                    onRetry: () => provider.search(provider.query),
                  ),
                )
              else if (provider.results.isEmpty && provider.query.isNotEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyView(
                    message: 'No stories found matching your query.',
                  ),
                )
              else if (provider.results.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: AppEmptyView(
                    message: 'Search for a topic to find fresh stories.',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  sliver: SliverList.builder(
                    itemCount: provider.results.length,
                    itemBuilder: (_, index) {
                      final article = provider.results[index];
                      return NewsCard(
                        article: article,
                        index: index,
                        compact: true,
                        onTap: () => context.push('/detail', extra: article),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
