import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../../../core/config/api_config.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/news_response_model.dart';

class NewsRemoteDataSource {
  NewsRemoteDataSource(this._client);

  final DioClient _client;

  Future<NewsResponseModel> fetchTopHeadlines({
    String? category,
    String? query,
    String? country,
    int page = 1,
  }) async {
    final apiKey = newsApiKey();
    if (_isMissingApiKey(apiKey)) {
      throw ServerException(
        'Missing NEWS_API_KEY. Replace the placeholder in .env with your real GNews key, or run with --dart-define-from-file=.env.',
      );
    }

    final selectedCategory = category ?? 'All';
    final selectedCountry = _supportedCountry(country);
    final gnewsCategory = _gnewsCategory(selectedCategory);
    final requestQuery = _requestQuery(
      category: selectedCategory,
      query: query,
    );
    final queryParameters = <String, Object>{
      'apikey': apiKey,
      'lang': 'en',
      'country': selectedCountry,
      'max': 10,
      'page': page,
      'category': gnewsCategory,
    };
    if (requestQuery != null) {
      queryParameters['q'] = requestQuery;
    }

    try {
      final response = await _client.dio.get<Map<String, dynamic>>(
        _headlinesEndpoint(),
        queryParameters: queryParameters,
      );

      if (response.statusCode == 200 && response.data != null) {
        return NewsResponseModel.fromJson(response.data!);
      }
      throw ServerException(
        _errorMessage(response.data) ?? 'Unable to load headlines',
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw TimeoutException('Request timed out');
      }
      if (e.type == DioExceptionType.connectionError) {
        if (kIsWeb) {
          throw NoInternetException(
            'The browser blocked the GNews request. Run on localhost with --dart-define-from-file=.env, use Android/desktop, or put GNews behind your own backend proxy for deployed web.',
          );
        }
        throw NoInternetException(
          'Could not reach GNews. Check your device internet, VPN, DNS, or rebuild the app if you just changed Android permissions.',
        );
      }
      throw ServerException(
        _errorMessage(e.response?.data) ?? _redactSensitiveValues(e.message),
      );
    } catch (e) {
      throw UnknownException(_redactSensitiveValues(e.toString()));
    }
  }

  String _headlinesEndpoint() {
    final configuredBaseUrl = newsApiBaseUrl().replaceFirst(RegExp(r'/+$'), '');
    if (configuredBaseUrl.isEmpty) {
      return 'https://gnews.io/api/v4/top-headlines';
    }
    return '$configuredBaseUrl/top-headlines';
  }

  bool _isMissingApiKey(String apiKey) {
    final normalized = apiKey.trim().toLowerCase();
    return normalized.isEmpty ||
        normalized == 'your_real_gnews_key' ||
        normalized == 'your_gnews_api_key' ||
        normalized == 'your_gnews_api_key_here';
  }

  String _gnewsCategory(String category) {
    return switch (category.toLowerCase()) {
      'business' => 'business',
      'technology' => 'technology',
      'sports' => 'sports',
      'health' => 'health',
      'science' => 'science',
      'entertainment' => 'entertainment',
      'world' => 'world',
      _ => 'general',
    };
  }

  String _supportedCountry(String? country) {
    final normalized = country?.trim().toLowerCase();
    final supportedCodes = AppConstants.newsCountries.map((item) => item.code);
    if (normalized != null && supportedCodes.contains(normalized)) {
      return normalized;
    }
    return AppConstants.defaultCountry;
  }

  String? _requestQuery({required String category, String? query}) {
    final trimmedQuery = query?.trim();
    if (trimmedQuery != null && trimmedQuery.isNotEmpty) {
      return trimmedQuery;
    }

    return switch (category.toLowerCase()) {
      'politics' => 'politics',
      'crypto' => 'crypto',
      'ai' => 'artificial intelligence',
      _ => null,
    };
  }

  String? _errorMessage(Object? data) {
    if (data is! Map) {
      return null;
    }

    final errors = data['errors'];
    if (errors is List && errors.isNotEmpty) {
      return errors.map((error) => error.toString()).join('\n');
    }
    if (errors is Map && errors.isNotEmpty) {
      return errors.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join('\n');
    }

    return null;
  }

  String _redactSensitiveValues(String? message) {
    if (message == null || message.isEmpty) {
      return 'Unexpected error';
    }

    return message.replaceAllMapped(
      RegExp(r'([?&]apikey=)[^&\s]+', caseSensitive: false),
      (match) => '${match.group(1)}***redacted***',
    );
  }
}
