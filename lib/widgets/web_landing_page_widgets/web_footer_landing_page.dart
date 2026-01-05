import 'package:flutter/material.dart';


class WebFooter extends StatelessWidget {
  const WebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.onPrimary,
      padding: const EdgeInsets.fromLTRB(100, 100, 100, 40),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EthioWorks',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Empowering Ethiopia\'s workforce by connecting the right talent with the right opportunities. Join us and build your future today.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.6),
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        _SocialIcon(Icons.business), // LinkedIn placeholder
                        const SizedBox(width: 12),
                        _SocialIcon(Icons.facebook),
                        const SizedBox(width: 12),
                        _SocialIcon(Icons.send), // Telegram placeholder
                        const SizedBox(width: 12),
                        _SocialIcon(Icons.camera_alt),
                      ],
                    ),
                  ],
                ),
              ),
              _FooterColumn(
                title: 'Platform',
                links: [
                  'Browse Jobs',
                  'Companies',
                  'Post a Job',
                  'Success Stories'
                ],
              ),
              _FooterColumn(
                title: 'Company',
                links: ['About Us', 'Contact', 'Careers', 'Press'],
              ),
              _FooterColumn(
                title: 'Support',
                links: [
                  'Help Center',
                  'Safety Center',
                  'Terms of Service',
                  'Privacy Policy'
                ],
              ),
            ],
          ),
          const SizedBox(height: 80),
          const Divider(color: Colors.white10),
          const SizedBox(height: 40),
          Text(
            '© 2026 EthioWorks. All rights reserved.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> links;

  const _FooterColumn({required this.title, required this.links});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        ...links.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                link,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
            )),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  const _SocialIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}