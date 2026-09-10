import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/app_error_view.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_empty_view.dart';
import '../../../../core/widgets/briefly_logo.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../domain/entities/article.dart';
import '../provider/home_provider.dart';
import '../widgets/category_chip.dart';
import '../widgets/news_card.dart';
import '../widgets/news_card_skeleton.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadInitialArticles();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll - 300)) {
      context.read<HomeProvider>().loadMoreArticles();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              AppConstants.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              AppConstants.appTagline,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: BrieflyLogo(size: 36),
        ),
        actions: [
          IconButton.filledTonal(
            tooltip: 'Search',
            onPressed: () => context.push('/home'),
            icon: const Icon(Icons.search),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: provider.refreshArticles,
        child: ResponsiveCenter(
          maxWidth: ResponsiveLayout.maxArticleWidth,
          child: ListView(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                      theme.colorScheme.tertiary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: const [0, 0.62, 1],
                  ),
                  borderRadius: BorderRadius.circular(
                    AppConstants.borderRadius,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      color: theme.colorScheme.onPrimary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today in focus',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimary.withValues(
                                alpha: 0.9,
                              ),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'India-first headlines with quick access to major global editions.',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.08, end: 0),
              const SizedBox(height: 16),
              _SectionHeader(
                title: 'Country-wise news',
                subtitle: _selectedCountryName(provider.selectedCountry),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.newsCountries.length,
                  itemBuilder: (_, index) {
                    final country = AppConstants.newsCountries[index];
                    return CategoryChip(
                      label: country.name,
                      isSelected: provider.selectedCountry == country.code,
                      onTap: () => provider.setCountry(country.code),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const _SectionHeader(title: 'Topics'),
              const SizedBox(height: 8),
              SizedBox(
                height: 48,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppConstants.categories.length,
                  itemBuilder: (_, index) {
                    final category = AppConstants.categories[index];
                    return CategoryChip(
                      label: category,
                      isSelected: provider.selectedCategory == category,
                      onTap: () => provider.setCategory(category),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              if (provider.isLoading && provider.articles.isEmpty)
                const Column(
                  children: [
                    NewsCardSkeleton(),
                    NewsCardSkeleton(),
                    NewsCardSkeleton(),
                  ],
                )
              else if (provider.error != null)
                AppErrorView(
                  error: provider.error!,
                  onRetry: provider.loadInitialArticles,
                )
              else if (provider.articles.isEmpty)
                const AppEmptyView(message: 'No articles found.')
              else
                ...provider.articles.indexed.map(
                  (entry) => NewsCard(
                    article: entry.$2,
                    index: entry.$1,
                    onTap: () => _openDetail(context, entry.$2),
                  ),
                ),
              if (provider.hasMore && provider.articles.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: provider.isLoadingMore
                      ? const AppLoadingView(height: 56)
                      : Column(
                          children: [
                            if (provider.loadMoreError != null) ...[
                              Text(
                                provider.loadMoreError!.message,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            OutlinedButton.icon(
                              onPressed: provider.loadMoreArticles,
                              icon: const Icon(Icons.expand_more_rounded),
                              label: Text(
                                provider.loadMoreError == null
                                    ? 'Load more'
                                    : 'Try again',
                              ),
                            ),
                          ],
                        ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, Article article) {
    context.push('/detail', extra: article);
  }

  String _selectedCountryName(String code) {
    return AppConstants.newsCountries
        .firstWhere(
          (country) => country.code == code,
          orElse: () => AppConstants.newsCountries.first,
        )
        .name;
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
      ],
    );
  }
}
