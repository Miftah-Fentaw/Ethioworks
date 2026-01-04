import 'package:flutter/material.dart';
import 'package:ethioworks/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;
  final String? assetIcon;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.assetIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Common text style for both button types
    final textStyle = theme.textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          padding: AppSpacing.paddingMd,
          side: BorderSide(
            color: backgroundColor ?? theme.colorScheme.outline,
            width: 1.5,
          ),
          shape: const StadiumBorder(),
          foregroundColor: textColor ?? theme.colorScheme.primary,
        ),
        child: isLoading
            ? _buildLoader(backgroundColor ?? theme.colorScheme.primary)
            : _buildContent(
                textStyle: textStyle?.copyWith(
                  color: textColor ?? theme.colorScheme.primary,
                ),
                iconColor: textColor ?? theme.colorScheme.primary,
              ),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        foregroundColor: textColor ?? theme.colorScheme.onPrimary,
        padding: AppSpacing.paddingMd,
        shape: const StadiumBorder(),
        elevation: 0,
      ),
      child: isLoading
          ? _buildLoader(textColor ?? theme.colorScheme.onPrimary)
          : _buildContent(
              textStyle: textStyle?.copyWith(
                color: textColor ?? theme.colorScheme.onPrimary,
              ),
              iconColor: textColor ?? theme.colorScheme.onPrimary,
            ),
    );
  }

  Widget _buildLoader(Color color) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }

  Widget _buildContent({TextStyle? textStyle, Color? iconColor}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(width: AppSpacing.sm),
        ] else if (assetIcon != null) ...[
          Image.asset(assetIcon!, width: 18, height: 18),
          const SizedBox(width: AppSpacing.sm),
        ],
        Text(text, style: textStyle),
      ],
    );
  }
}
