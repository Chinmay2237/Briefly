import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = 'Briefly';
  static const String appTagline = 'Smart news at a glance';
  // A calm blue system supports long reading sessions and retains clear
  // hierarchy in both bright and low-light environments.
  static const Color primaryColor = Color(0xFF1557B0);
  static const Color accentColor = Color(0xFF9C4200);
  static const Color mintColor = Color(0xFF006B5E);
  static const Color inkColor = Color(0xFF171C25);
  static const Color backgroundLight = Color(0xFFF8F9FF);
  static const Color backgroundDark = Color(0xFF10131A);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1A1E27);
  static const double borderRadius = 16;
  static const double spacing = 8;
  static const String defaultCountry = 'in';
  static const String defaultLanguage = 'en';
  static const double defaultFontScale = 1.0;
  static const List<NewsCountry> newsCountries = [
    NewsCountry(code: 'in', name: 'India'),
    NewsCountry(code: 'us', name: 'United States'),
    NewsCountry(code: 'gb', name: 'United Kingdom'),
    NewsCountry(code: 'au', name: 'Australia'),
    NewsCountry(code: 'ca', name: 'Canada'),
    NewsCountry(code: 'sg', name: 'Singapore'),
    NewsCountry(code: 'jp', name: 'Japan'),
    NewsCountry(code: 'de', name: 'Germany'),
    NewsCountry(code: 'fr', name: 'France'),
  ];
  static const List<String> categories = [
    'All',
    'Business',
    'Technology',
    'Sports',
    'Health',
    'Science',
    'Entertainment',
    'Politics',
    'World',
    'Crypto',
    'AI',
  ];
}

class NewsCountry {
  const NewsCountry({required this.code, required this.name});

  final String code;
  final String name;
}
