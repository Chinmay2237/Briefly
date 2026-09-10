import 'package:flutter/material.dart';

import '../error/app_exception.dart';

class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.error, required this.onRetry});

  final dynamic error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = _messageFor(error);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 58,
              width: 58,
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                _iconFor(error),
                color: theme.colorScheme.onErrorContainer,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Something went wrong',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _messageFor(Object error) {
    if (error is AppException) {
      return error.message;
    }
    return error.toString().replaceFirst('Exception: ', '');
  }

  IconData _iconFor(Object error) {
    if (error is TimeoutException) return Icons.timer_off_rounded;
    if (error is NoInternetException || error is NetworkException) {
      return Icons.wifi_off_rounded;
    }
    if (error is ServerException) return Icons.cloud_off_rounded;
    return Icons.error_outline_rounded;
  }
}
