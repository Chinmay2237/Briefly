import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import 'core/config/env_loader.dart';
import 'core/constants/app_constants.dart';
import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'features/bookmarks/presentation/provider/bookmark_provider.dart';
import 'features/home/data/datasource/news_remote_datasource.dart';
import 'features/home/data/repository/news_repository_impl.dart';
import 'features/home/presentation/provider/home_provider.dart';
import 'features/search/presentation/provider/search_provider.dart';
import 'features/settings/presentation/provider/settings_provider.dart';

final sl = GetIt.instance;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppEnv.load();
  await StorageService.instance.init();

  sl.registerLazySingleton<DioClient>(() => DioClient());
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSource(sl<DioClient>()),
  );
  sl.registerLazySingleton<NewsRepositoryImpl>(
    () => NewsRepositoryImpl(sl<NewsRemoteDataSource>()),
  );

  final repository = sl<NewsRepositoryImpl>();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: repository),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => HomeProvider(repository)),
        ChangeNotifierProvider(create: (_) => SearchProvider(repository)),
        ChangeNotifierProvider(create: (_) => BookmarkProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const BrieflyApp(),
    ),
  );
}

class BrieflyApp extends StatelessWidget {
  const BrieflyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: TextScaler.linear(settings.fontScale)),
      child: MaterialApp.router(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
