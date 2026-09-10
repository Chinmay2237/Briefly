import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../provider/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SettingsProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ResponsiveCenter(
        maxWidth: ResponsiveLayout.maxArticleWidth,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Dark Mode'),
              subtitle: const Text(
                'Switch between light and dark visual themes',
              ),
              value: provider.isDarkMode,
              onChanged: (value) => provider.toggleTheme(value),
            ),
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Text Scale', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    'Adjust typography size across stories',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<double>(
                    segments: const [
                      ButtonSegment(value: 0.9, label: Text('Small')),
                      ButtonSegment(value: 1.0, label: Text('Normal')),
                      ButtonSegment(value: 1.15, label: Text('Large')),
                      ButtonSegment(value: 1.30, label: Text('X-Large')),
                    ],
                    selected: {provider.fontScale},
                    onSelectionChanged: (newSelection) {
                      if (newSelection.isNotEmpty) {
                        provider.updateFontScale(newSelection.first);
                      }
                    },
                  ),
                ],
              ),
            ),
            const Divider(height: 24),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.language_rounded),
              title: const Text('Primary News Country'),
              subtitle: Text(_countryName(provider.country)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _showCountryPicker(context, provider),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.cleaning_services_rounded),
              title: const Text('Clear Storage & Cache'),
              subtitle: const Text('Reset search history and local settings'),
              onTap: () async {
                await provider.clearCache();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cache and settings reset successfully'),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.newspaper_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Briefly News',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Briefly is a production-oriented news application built with Flutter, Provider, Dio, and Material 3 design principles.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Version 0.1.0+1 · Powered by GNews',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context, SettingsProvider provider) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                'Select News Country',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: AppConstants.newsCountries.length,
                itemBuilder: (context, index) {
                  final country = AppConstants.newsCountries[index];
                  final isSelected = provider.country == country.code;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Theme.of(context).colorScheme.surfaceContainerHigh,
                      child: Text(
                        country.code.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimaryContainer
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    title: Text(country.name),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle_rounded)
                        : null,
                    onTap: () {
                      provider.updateCountry(country.code);
                      Navigator.of(ctx).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _countryName(String code) {
    return AppConstants.newsCountries
        .firstWhere(
          (country) => country.code == code,
          orElse: () => AppConstants.newsCountries.first,
        )
        .name;
  }
}
