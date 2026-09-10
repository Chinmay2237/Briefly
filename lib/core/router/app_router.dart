import 'package:go_router/go_router.dart';

import '../../features/home/domain/entities/article.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/news_detail_page.dart';
import '../../features/home/presentation/pages/splash_page.dart';
import '../widgets/app_shell.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/home', builder: (context, state) => const AppShell()),
      GoRoute(
        path: '/detail',
        builder: (context, state) {
          final article = state.extra as Article?;
          return article == null
              ? const HomePage()
              : NewsDetailPage(article: article);
        },
      ),
    ],
  );
}
