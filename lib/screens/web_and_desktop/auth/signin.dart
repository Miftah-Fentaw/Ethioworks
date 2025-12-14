import 'package:ethioworks/screens/web_and_desktop/employer/employer_root.dart';
import 'package:ethioworks/screens/web_and_desktop/job_seeker/job_seeker_root.dart';
import 'package:ethioworks/screens/web_and_desktop/auth/forgot_password.dart';
import 'package:ethioworks/screens/web_and_desktop/auth/signup.dart';
import 'package:ethioworks/utils/validator.dart';
import 'package:ethioworks/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/theme.dart';

class WebLoginScreen extends StatefulWidget {
  const WebLoginScreen({super.key});

  @override
  State<WebLoginScreen> createState() => _WebLoginScreenState();
}

class _WebLoginScreenState extends State<WebLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
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
          content: Text(authProvider.errorMessage ?? 'Login failed'),
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
        const SizedBox(height: AppSpacing.xxl),
        Icon(
          Icons.work_rounded,
          size: 80,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Welcome Back',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Log in to continue your job search',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xxl),
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
        const SizedBox(height: AppSpacing.md),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WebForgotPasswordScreen()),
              );
            },
            child: Text(
              'Forgot Password?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        CustomButton(
          text: 'Log In',
          onPressed: _handleLogin,
          isLoading: authProvider.isLoading,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(child: Divider(color: theme.colorScheme.outline)),
            Padding(
              padding: AppSpacing.horizontalMd,
              child: Text('OR', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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
        const SizedBox(height: AppSpacing.xl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account? ", style: theme.textTheme.bodyMedium),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const WebSignupScreen()),
                );
              },
              child: Text(
                'Sign Up',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWide = constraints.maxWidth >= 900;

          if (isWide) {
            return Row(
              children: [
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: SingleChildScrollView(
                          child: Form(key: _formKey, child: _buildFormContent()),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1552664730-d307ca884978?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80',
                        fit: BoxFit.cover,
                      ),
                      Container(color: Colors.black.withOpacity(0.5)),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48),
                          child: Text(
                            'Discover Your\nNext Opportunity\nin Ethiopia',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            // Mobile layout
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