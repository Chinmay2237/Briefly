import 'package:briefly/core/error/app_exception.dart';
import 'package:briefly/core/network/dio_client.dart';
import 'package:briefly/features/home/data/datasource/news_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NewsRemoteDataSource Security & Exception Tests', () {
    late DioClient client;
    late NewsRemoteDataSource dataSource;

    setUp(() {
      client = DioClient();
      dataSource = NewsRemoteDataSource(client);
    });

    test(
      'throws ServerException when NEWS_API_KEY is placeholder or missing',
      () {
        expect(
          () => dataSource.fetchTopHeadlines(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
}
