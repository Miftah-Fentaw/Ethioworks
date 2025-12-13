import 'package:ethioworks/screens/mobile/auth/signin.dart';
import 'package:ethioworks/screens/mobile/employer/employer_home_page.dart';
import 'package:ethioworks/screens/mobile/job_seeker/job_seeker_home_page.dart';
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
      name: _selectedUserType == UserType.jobSeeker ? _nameController.text.trim() : null,
      companyOrPersonalName: _selectedUserType == UserType.employer ? _nameController.text.trim() : null,
    );

    if (!mounted) return;

    if (success) {
      if (authProvider.isJobSeeker) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const SeekerHomeScreen()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const EmployerHomeScreen()),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.xl),
                Icon(
                  Icons.work_rounded,
                  size: 70,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'Create Account',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Join EthioWorks and explore opportunities',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'I am a',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _selectedUserType = UserType.jobSeeker),
                          borderRadius: BorderRadius.circular(AppRadius.md),
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
                                Icon(
                                  Icons.person_search,
                                  color: _selectedUserType == UserType.jobSeeker
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Job Seeker',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: _selectedUserType == UserType.jobSeeker
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _selectedUserType = UserType.employer),
                          borderRadius: BorderRadius.circular(AppRadius.md),
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
                                Icon(
                                  Icons.business,
                                  color: _selectedUserType == UserType.employer
                                      ? theme.colorScheme.onPrimary
                                      : theme.colorScheme.onSurfaceVariant,
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'Employer',
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: _selectedUserType == UserType.employer
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
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
                  label: _selectedUserType == UserType.jobSeeker ? 'Full Name' : 'Company/Personal Name',
                  hint: _selectedUserType == UserType.jobSeeker ? 'John Doe' : 'Company Name',
                  controller: _nameController,
                  prefixIcon: _selectedUserType == UserType.jobSeeker ? Icons.person_outline : Icons.business_outlined,
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
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
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
                      child: Text(
                        'OR',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: theme.colorScheme.outline)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomButton(
                  text: 'Continue with Google',
                  icon: Icons.login,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Google Sign-In coming soon!')),
                    );
                  },
                  isOutlined: true,
                ),
                const SizedBox(height: AppSpacing.lg),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: theme.textTheme.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        'Log In',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
