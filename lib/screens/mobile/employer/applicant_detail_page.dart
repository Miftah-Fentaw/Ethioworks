import 'package:flutter/material.dart';
import 'package:ethioworks/models/application_model.dart';
import 'package:ethioworks/widgets/profile_avatar.dart';
import 'package:ethioworks/theme.dart';

class ApplicantDetailScreen extends StatelessWidget {
  final Application application;

  const ApplicantDetailScreen({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Applicant Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(theme),
            const SizedBox(height: AppSpacing.xxl),
            _buildSectionHeader(theme, 'Cover Letter'),
            const SizedBox(height: AppSpacing.md),
            _buildCoverLetterCard(theme),
            const SizedBox(height: AppSpacing.xxl),
            _buildSectionHeader(theme, 'Contact Information'),
            const SizedBox(height: AppSpacing.md),
            _buildContactCard(theme),
            const SizedBox(height: AppSpacing.xxl),
            _buildSectionHeader(theme, 'Links & Documents'),
            const SizedBox(height: AppSpacing.md),
            _buildLinksCard(theme),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.lg),
        ProfileAvatar(
          imageUrl: null,
          name: application.applicantName,
          size: 112,
          avatarType: AvatarType.jobSeeker,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          application.applicantName,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
          textAlign: TextAlign.center,
        ),
        if (application.applicantTitle != null) ...[
          const SizedBox(height: 4.0),
          Text(
            application.applicantTitle!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildCoverLetterCard(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Text(
        application.coverLetter,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildContactCard(ThemeData theme) {
    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        children: [
          _buildInfoRow(theme, Icons.email_rounded, 'Email', application.email),
          const Divider(height: AppSpacing.xl),
          _buildInfoRow(
              theme, Icons.phone_rounded, 'Phone', application.phoneNo),
          const Divider(height: AppSpacing.xl),
          _buildInfoRow(theme, Icons.alternate_email_rounded, 'Telegram',
              application.telegramUsername),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
      ThemeData theme, IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: theme.colorScheme.outline, width: 1),
          ),
          child: Icon(icon, size: 20, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinksCard(ThemeData theme) {
    return Container(
      padding: AppSpacing.paddingLg,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: theme.colorScheme.outline, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLinkItem(theme, 'Resume URL', application.resumeLink,
              Icons.description_rounded),
          if (application.portfolioLinks.isNotEmpty) ...[
            const Divider(height: AppSpacing.xl),
            ...application.portfolioLinks.map((link) => Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: _buildLinkItem(
                      theme, 'Portfolio', link, Icons.link_rounded),
                )),
          ],
        ],
      ),
    );
  }

  Widget _buildLinkItem(
      ThemeData theme, String label, String link, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              InkWell(
                onTap: () {},
                child: Text(
                  link,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
