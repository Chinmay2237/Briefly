import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';

class ShareBottomSheet extends StatelessWidget {
  const ShareBottomSheet({super.key, required this.url, this.title});

  final String url;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shareText = _shareText;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.ios_share_rounded,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title != null && title!.trim().isNotEmpty
                        ? 'Share "${title!.trim()}"'
                        : 'Share news',
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...[
                _ShareRow(
                  icon: Icons.share_outlined,
                  label: 'System share',
                  subtitle: 'Send through any installed app',
                  onTap: () async {
                    Navigator.of(context).pop();
                    await Share.share(shareText, subject: title);
                  },
                ),
                _ShareRow(
                  icon: Icons.chat_rounded,
                  label: 'WhatsApp',
                  subtitle: 'Share as a message',
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.of(context).pop();
                    try {
                      final encoded = Uri.encodeComponent(shareText);
                      final waUrl = Uri.parse('https://wa.me/?text=$encoded');
                      final launched = await launchUrl(
                        waUrl,
                        mode: LaunchMode.externalApplication,
                      );
                      if (!launched) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Could not open WhatsApp'),
                          ),
                        );
                      }
                    } catch (_) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Unable to share to WhatsApp'),
                        ),
                      );
                    }
                  },
                ),
                _ShareRow(
                  icon: Icons.mail_outline,
                  label: 'Email',
                  subtitle: 'Compose with subject and link',
                  onTap: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.of(context).pop();
                    try {
                      final subject = Uri.encodeComponent(
                        title?.trim().isNotEmpty == true
                            ? title!.trim()
                            : AppConstants.appName,
                      );
                      final body = Uri.encodeComponent(shareText);
                      final mailto = Uri.parse(
                        'mailto:?subject=$subject&body=$body',
                      );
                      final launched = await launchUrl(mailto);
                      if (!launched) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Could not open email client'),
                          ),
                        );
                      }
                    } catch (_) {
                      messenger.showSnackBar(
                        const SnackBar(
                          content: Text('Unable to open email client'),
                        ),
                      );
                    }
                  },
                ),
                _ShareRow(
                  icon: Icons.link_outlined,
                  label: 'Copy link',
                  subtitle: 'Save it to clipboard',
                  onTap: () async {
                    Navigator.of(context).pop();
                    await _copyToClipboard(context, url);
                  },
                ),
              ]
              .animate(interval: 45.ms)
              .fadeIn(duration: 180.ms)
              .slideY(
                begin: 0.08,
                end: 0,
                duration: 180.ms,
                curve: Curves.easeOutCubic,
              ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  String get _shareText {
    final trimmedTitle = title?.trim();
    if (trimmedTitle == null || trimmedTitle.isEmpty) {
      return url;
    }
    return '$trimmedTitle\n$url';
  }

  Future<void> _copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(const SnackBar(content: Text('Link copied')));
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: theme.colorScheme.secondaryContainer,
        child: Icon(icon, color: theme.colorScheme.onSecondaryContainer),
      ),
      title: Text(label),
      subtitle: Text(subtitle),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
    );
  }
}
