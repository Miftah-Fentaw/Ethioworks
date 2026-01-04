import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/job_post_model.dart';
import 'package:ethioworks/models/application_model.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/providers/application_provider.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/widgets/custom_text.dart';
import 'package:ethioworks/utils/validator.dart';
import 'package:ethioworks/theme.dart';

class ApplyJobScreen extends StatefulWidget {
  final JobPost job;

  const ApplyJobScreen({super.key, required this.job});

  @override
  State<ApplyJobScreen> createState() => _ApplyJobScreenState();
}

class _ApplyJobScreenState extends State<ApplyJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _coverLetterController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _resumeLinkController = TextEditingController();
  final _telegramController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final seeker = context.read<AuthProvider>().currentJobSeeker;
    if (seeker != null) {
      _emailController.text = seeker.email;
      _phoneController.text = seeker.phoneNo ?? '';
    }
  }

  @override
  void dispose() {
    _coverLetterController.dispose();
    _portfolioController.dispose();
    _resumeLinkController.dispose();
    _telegramController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final applicationProvider = context.read<ApplicationProvider>();
    final seeker = authProvider.currentJobSeeker;

    if (seeker == null) return;

    final portfolioLinks = _portfolioController.text.isEmpty
        ? <String>[]
        : _portfolioController.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();

    final application = Application(
      id: '',
      coverLetter: _coverLetterController.text.trim(),
      portfolioLinks: portfolioLinks,
      resumeLink: _resumeLinkController.text.trim(),
      telegramUsername: _telegramController.text.trim(),
      email: _emailController.text.trim(),
      phoneNo: _phoneController.text.trim(),
      jobId: widget.job.id,
      userId: seeker.id,
      applicantName: seeker.name,
      applicantTitle: seeker.title,
      createdAt: DateTime.now(),
    );

    final success = await applicationProvider.submitApplication(application);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Application submitted successfully!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(applicationProvider.errorMessage ??
              'Failed to submit application'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final applicationProvider = context.watch<ApplicationProvider>();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(
          'Submit Application',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingLg,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildJobHeader(theme),
              const SizedBox(height: AppSpacing.xxl),
              _buildSectionHeader(theme, 'Personal Information'),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Email Address',
                hint: 'example@gmail.com',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_rounded,
                validator: Validators.validateEmail,
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomTextField(
                label: 'Phone Number',
                hint: '+251 9XX XXX XXX',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: Icons.phone_rounded,
                validator: (value) =>
                    Validators.validateRequired(value, 'Phone number'),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildSectionHeader(theme, 'Application Details'),
              const SizedBox(height: AppSpacing.md),
              CustomTextField(
                label: 'Cover Letter',
                hint: 'Tell us why you are the perfect fit...',
                controller: _coverLetterController,
                maxLines: 5,
                validator: (value) =>
                    Validators.validateRequired(value, 'Cover letter'),
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomTextField(
                label: 'Resume Link',
                hint: 'https://drive.google.com/your-resume',
                controller: _resumeLinkController,
                keyboardType: TextInputType.url,
                prefixIcon: Icons.description_rounded,
                validator: (value) =>
                    Validators.validateRequired(value, 'Resume link'),
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomTextField(
                label: 'Portfolio Links (Optional)',
                hint: 'https://portfolio.com, https://github.com/...',
                controller: _portfolioController,
                maxLines: 2,
                keyboardType: TextInputType.url,
                prefixIcon: Icons.link_rounded,
              ),
              const SizedBox(height: AppSpacing.xl),
              CustomTextField(
                label: 'Telegram Username',
                hint: '@yourusername',
                controller: _telegramController,
                prefixIcon: Icons.alternate_email_rounded,
                validator: (value) =>
                    Validators.validateRequired(value, 'Telegram username'),
              ),
              const SizedBox(height: AppSpacing.xxl),
              CustomButton(
                text: 'Submit Application',
                icon: Icons.send_rounded,
                onPressed: _submitApplication,
                isLoading: applicationProvider.isLoading,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobHeader(ThemeData theme) {
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
          Text(
            'Job Opportunity',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            widget.job.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4.0),
          Text(
            widget.job.companyName,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w900,
        color: theme.colorScheme.onSurface,
        letterSpacing: 0.5,
      ),
    );
  }
}
