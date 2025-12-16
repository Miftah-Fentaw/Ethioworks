import 'package:ethioworks/models/user_model.dart';
import 'package:ethioworks/screens/web_and_desktop/employer/employer_root.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/job_seeker_root.dart';
import 'package:ethioworks/screens/web_and_desktop/auth/signin.dart';
import 'package:ethioworks/utils/validator.dart';
import 'package:ethioworks/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/theme.dart';

class WebSignupScreen extends StatefulWidget {
  const WebSignupScreen({super.key});

  @override
  State<WebSignupScreen> createState() => _WebSignupScreenState();
}

class _WebSignupScreenState extends State<WebSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _obscurePassword = true;
  UserType _selectedUserType = UserType.jobSeeker;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.signUp(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      userType: _selectedUserType,
      name: _selectedUserType == UserType.jobSeeker
          ? _nameController.text.trim()
          : null,
      companyOrPersonalName: _selectedUserType == UserType.employer
          ? _nameController.text.trim()
          : null,
    );

    if (!mounted) return;

    if (success) {
      if (authProvider.isJobSeeker) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const JobSeekerRoot()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const EmployerRoot()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Signup failed'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Widget _buildFormContent() {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xl),
        Icon(Icons.work_rounded, size: 70, color: theme.colorScheme.primary),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Create Account',
          style: theme.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Join EthioWorks and explore opportunities',
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text('I am a',
            style: theme.textTheme.labelLarge
                ?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.md),
        // User type selector (same as your original)
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border:
                Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () =>
                      setState(() => _selectedUserType = UserType.jobSeeker),
                  child: Container(
                    padding: AppSpacing.paddingMd,
                    decoration: BoxDecoration(
                      color: _selectedUserType == UserType.jobSeeker
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.person_search,
                            color: _selectedUserType == UserType.jobSeeker
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Job Seeker',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: _selectedUserType == UserType.jobSeeker
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () =>
                      setState(() => _selectedUserType = UserType.employer),
                  child: Container(
                    padding: AppSpacing.paddingMd,
                    decoration: BoxDecoration(
                      color: _selectedUserType == UserType.employer
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.business,
                            color: _selectedUserType == UserType.employer
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Employer',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: _selectedUserType == UserType.employer
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        CustomTextField(
          label: _selectedUserType == UserType.jobSeeker
              ? 'Full Name'
              : 'Company/Personal Name',
          hint: _selectedUserType == UserType.jobSeeker
              ? 'John Doe'
              : 'Company Name',
          controller: _nameController,
          prefixIcon: _selectedUserType == UserType.jobSeeker
              ? Icons.person_outline
              : Icons.business_outlined,
          validator: Validators.validateName,
        ),
        const SizedBox(height: AppSpacing.lg),
        CustomTextField(
          label: 'Email Address',
          hint: 'your.email@example.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email_outlined,
          validator: Validators.validateEmail,
        ),
        const SizedBox(height: AppSpacing.lg),
        CustomTextField(
          label: 'Password',
          hint: '••••••••',
          controller: _passwordController,
          obscureText: _obscurePassword,
          prefixIcon: Icons.lock_outline,
          validator: Validators.validatePassword,
          suffixIcon: IconButton(
            icon: Icon(_obscurePassword
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined),
            onPressed: () =>
                setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        CustomButton(
          text: 'Create Account',
          onPressed: _handleSignup,
          isLoading: authProvider.isLoading,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(child: Divider(color: theme.colorScheme.outline)),
            Padding(
                padding: AppSpacing.horizontalMd,
                child: Text('OR', style: theme.textTheme.bodySmall)),
            Expanded(child: Divider(color: theme.colorScheme.outline)),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ElevatedButton.icon(
          onPressed: authProvider.isLoading
              ? null
              : () async {
                  // TODO: Implement Google Sign-In
                  const success = true; // Placeholder for logic

                  if (!mounted) return;
                  if (success) {
                    if (authProvider.isJobSeeker) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const JobSeekerRoot()),
                      );
                    } else {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const EmployerRoot()),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(authProvider.errorMessage ??
                            'Google Sign-In failed'),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                    );
                  }
                },
          icon: Image.asset(
            'assets/google.png',
            height: 24,
            width: 24,
          ),
          label: Text(
            authProvider.isLoading ? 'Signing in...' : 'Sign in with Google',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already have an account? ',
                style: theme.textTheme.bodyMedium),
            TextButton(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const WebLoginScreen())),
              child: Text('Log In',
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 900;

          if (isWide) {
            // Modern Web/Desktop Layout
            return Row(
              children: [
                // Form Section with Modern Card Design
                Expanded(
                  child: Container(
                    color: theme.colorScheme.background,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48, vertical: 40),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: SingleChildScrollView(
                          child: Card(
                            elevation: 8,
                            shadowColor: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Form(
                                key: _formKey,
                                child: _buildFormContent(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Hero Image Section with Modern Gradient
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1521737604893-d14cc237f11d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2064&q=80',
                        fit: BoxFit.cover,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 48),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.rocket_launch_rounded,
                                size: 80,
                                color: Colors.white,
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              Text(
                                'Build Your Future\nWith EthioWorks',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Text(
                                'Join thousands of professionals finding their perfect match',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white.withValues(alpha: 0.9),
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Mobile layout - unchanged
            return SafeArea(
              child: SingleChildScrollView(
                padding: AppSpacing.paddingLg,
                child: Form(key: _formKey, child: _buildFormContent()),
              ),
            );
          }
        },
      ),
    );
  }
}
