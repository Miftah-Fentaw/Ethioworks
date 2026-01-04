import 'package:ethioworks/screens/mobile/auth/signin.dart';
import 'package:ethioworks/screens/mobile/employer/employer_root.dart';
import 'package:ethioworks/screens/mobile/job_seeker/job_seeker_root.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/job_seeker_root.dart'
    as web_seeker;
import 'package:ethioworks/screens/web_and_desktop/employer/employer_root.dart'
    as web_employer;
import 'package:ethioworks/screens/web_and_desktop/auth/signin.dart'
    as web_signin;
import 'package:ethioworks/widgets/responsive_layout.dart';
import 'package:ethioworks/utils/validator.dart';
import 'package:ethioworks/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/models/user_model.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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
          MaterialPageRoute(
            builder: (_) => const ResponsiveLayout(
              mobile: JobSeekerRoot(),
              desktop: web_seeker.JobSeekerRoot(),
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const ResponsiveLayout(
              mobile: EmployerRoot(),
              desktop: web_employer.EmployerRoot(),
            ),
          ),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingXl,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl),
                _buildHeader(theme),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionHeader(theme, 'Account Type'),
                const SizedBox(height: AppSpacing.md),
                _buildUserTypeSelector(theme),
                const SizedBox(height: AppSpacing.xxl),
                _buildSectionHeader(theme, 'Personal Information'),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  label: _selectedUserType == UserType.jobSeeker
                      ? 'Full Name'
                      : 'Company/Personal Name',
                  hint: _selectedUserType == UserType.jobSeeker
                      ? 'full name'
                      : 'Company Name',
                  controller: _nameController,
                  prefixIcon: _selectedUserType == UserType.jobSeeker
                      ? Icons.person_rounded
                      : Icons.business_rounded,
                  validator: Validators.validateName,
                ),
                const SizedBox(height: AppSpacing.xl),
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
                  label: 'Password',
                  hint: '••••••••',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_rounded,
                  validator: Validators.validatePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_rounded
                          : Icons.visibility_off_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                CustomButton(
                  text: 'Create Account',
                  onPressed: _handleSignup,
                  isLoading: authProvider.isLoading,
                  icon: Icons.person_add_rounded,
                ),
                const SizedBox(height: AppSpacing.xxl),
                _buildDivider(theme),
                const SizedBox(height: AppSpacing.xxl),
                CustomButton(
                  text: 'Continue with Google',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Google Sign-In coming soon!')),
                    );
                  },
                  isOutlined: true,
                ),
                const SizedBox(height: AppSpacing.xxl),
                _buildFooter(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: AppSpacing.paddingLg,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.outline, width: 1),
          ),
          child: Icon(
            Icons.work_rounded,
            size: 40,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          'Join EthioWorks',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Create an account to get started.',
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
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

  Widget _buildUserTypeSelector(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildTypeCard(
            theme,
            UserType.jobSeeker,
            'Job Seeker',
            Icons.person_search_rounded,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _buildTypeCard(
            theme,
            UserType.employer,
            'Employer',
            Icons.business_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeCard(
      ThemeData theme, UserType type, String label, IconData icon) {
    final isSelected = _selectedUserType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedUserType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppSpacing.paddingLg,
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        Expanded(
            child: Divider(color: theme.colorScheme.outline, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'OR',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
        Expanded(
            child: Divider(color: theme.colorScheme.outline, thickness: 1)),
      ],
    );
  }

  Widget _buildFooter(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const ResponsiveLayout(
                  mobile: LoginScreen(),
                  desktop: web_signin.WebLoginScreen(),
                ),
              ),
            );
          },
          child: Text(
            'Log In',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}
