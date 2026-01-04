import 'package:ethioworks/utils/validator.dart';
import 'package:ethioworks/screens/mobile/auth/signin.dart' as mobile_signin;
import 'package:ethioworks/screens/web_and_desktop/auth/signin.dart';
import 'package:ethioworks/widgets/responsive_layout.dart';
import 'package:ethioworks/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ethioworks/providers/auth_provider.dart';
import 'package:ethioworks/widgets/custom_button.dart';
import 'package:ethioworks/theme.dart';

class WebForgotPasswordScreen extends StatefulWidget {
  const WebForgotPasswordScreen({super.key});

  @override
  State<WebForgotPasswordScreen> createState() =>
      _WebForgotPasswordScreenState();
}

class _WebForgotPasswordScreenState extends State<WebForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success =
        await authProvider.resetPassword(_emailController.text.trim());

    if (!mounted) return;

    if (success) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Success'),
          content: const Text(
              'Password reset instructions have been sent to your email.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Pop dialog
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const ResponsiveLayout(
                      mobile: mobile_signin.LoginScreen(),
                      desktop: WebLoginScreen(),
                    ),
                  ),
                );
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Password reset failed'),
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
        Icon(Icons.lock_reset, size: 80, color: theme.colorScheme.primary),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Forgot Password?',
          style: theme.textTheme.headlineMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          "Don't worry! Enter your email address and we'll send you instructions to reset your password.",
          style: theme.textTheme.bodyLarge
              ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
        const SizedBox(height: AppSpacing.xl),
        CustomButton(
          text: 'Send Reset Link',
          onPressed: _handleResetPassword,
          isLoading: authProvider.isLoading,
        ),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: TextButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => const ResponsiveLayout(
                  mobile: mobile_signin.LoginScreen(),
                  desktop: WebLoginScreen(),
                ),
              ),
            ),
            child: Text(
              'Back to Login',
              style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const ResponsiveLayout(
                mobile: mobile_signin.LoginScreen(),
                desktop: WebLoginScreen(),
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                            child: Form(
                                key: _formKey, child: _buildFormContent())),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        'https://images.unsplash.com/photo-1633265486064-086b219458ec?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cGFzc3dvcmR8ZW58MHx8MHx8fDA%3D',
                        fit: BoxFit.cover,
                      ),
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48),
                          child: Text(
                            'Get Back to\nYour Opportunities',
                            style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.3),
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
