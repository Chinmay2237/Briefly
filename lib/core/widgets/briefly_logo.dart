import 'package:flutter/material.dart';

class BrieflyLogo extends StatelessWidget {
  const BrieflyLogo({super.key, this.size = 44, this.showWordmark = false});

  final double size;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/briefly_logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
          semanticLabel: 'Briefly logo',
        ),
        if (showWordmark) ...[
          const SizedBox(width: 10),
          Text(
            'Briefly',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ],
    );
  }
}
