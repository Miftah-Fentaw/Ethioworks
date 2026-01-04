import 'package:flutter/material.dart';

enum AvatarType { jobSeeker, employer, company }

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double size;
  final AvatarType? avatarType;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 40,
    this.avatarType,
  });

  String _getInitials(String name) {
    final words = name.trim().split(' ');
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String? asset;
    if (avatarType != null) {
      switch (avatarType!) {
        case AvatarType.jobSeeker:
          asset = 'assets/images/user_circled.png';
          break;
        case AvatarType.employer:
          asset = 'assets/images/employer.png';
          break;
        case AvatarType.company:
          asset = 'assets/images/company.png';
          break;
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.primaryContainer,
        border: Border.all(
          color: theme.colorScheme.outline,
          width: 0.5,
        ),
      ),
      child: ClipOval(
        child: asset != null
            ? Image.asset(
                asset,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildFallback(theme),
              )
            : imageUrl != null && imageUrl!.isNotEmpty
                ? Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        _buildFallback(theme),
                  )
                : _buildFallback(theme),
      ),
    );
  }

  Widget _buildFallback(ThemeData theme) {
    return Center(
      child: Text(
        _getInitials(name),
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
          fontSize: size * 0.4,
        ),
      ),
    );
  }
}
