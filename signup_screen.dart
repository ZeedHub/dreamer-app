import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sign up screen for new user registration
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Terms & Conditions'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // TODO: Implement Firebase Auth signup
      // final authService = ref.read(authServiceProvider);
      // await authService.signUpWithEmailAndPassword(
      //   email: _emailController.text.trim(),
      //   password: _passwordController.text,
      //   displayName: _nameController.text.trim(),
      // );

      // Simulate signup delay
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Navigate to astro setup after successful signup
      context.go('/profile/astro-setup');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Welcome to Dreamer! 🌙✨'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignup() async {
    setState(() => _isLoading = true);

    try {
      // TODO: Implement Google Sign-In
      // final authService = ref.read(authServiceProvider);
      // await authService.signInWithGoogle();

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      context.go('/profile/astro-setup');
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created with Google! 🌙✨'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Google sign-up failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _nextStep() {
    if (_currentStep == 0) {
      // Validate name and email
      if (_nameController.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter your name')),
        );
        return;
      }
      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(_emailController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid email')),
        );
        return;
      }
    }
    
    if (_currentStep < 1) {
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isLoading
              ? null
              : () {
                  if (_currentStep > 0) {
                    _previousStep();
                  } else {
                    context.pop();
                  }
                },
        ),
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            height: size.height - 
                   MediaQuery.of(context).padding.top - 
                   kToolbarHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                
                // Progress Indicator
                _buildProgressIndicator(theme),
                
                const SizedBox(height: 32),
                
                // Header
                _buildHeader(theme),
                
                const SizedBox(height: 32),
                
                // Sign Up Form
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: _currentStep == 0
                        ? _buildStep1(theme)
                        : _buildStep2(theme),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: (_currentStep + 1) / 2,
            backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Step ${_currentStep + 1} of 2',
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Text(
          _currentStep == 0 ? 'Let\'s get started' : 'Secure your account',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _currentStep == 0
              ? 'Create an account to start your dream journey'
              : 'Choose a strong password to protect your dreams',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.textTheme.bodySmall?.color,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStep1(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Name Field
        TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
          enabled: !_isLoading,
          decoration: const InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter your full name',
            prefixIcon: Icon(Icons.person_outline),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter your name';
            }
            if (value.trim().length < 2) {
              return 'Name must be at least 2 characters';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        // Email Field
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          enabled: !_isLoading,
          decoration: const InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                .hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 32),
        
        // Next Button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _nextStep,
            child: const Text('Continue'),
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Divider
        _buildDivider(theme),
        
        const SizedBox(height: 24),
        
        // Social Sign Up Buttons
        _buildSocialButtons(theme),
        
        const Spacer(),
        
        // Login Link
        _buildLoginLink(theme),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStep2(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Password Field
        TextFormField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          enabled: !_isLoading,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Create a password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
              return 'Password must contain uppercase, lowercase & number';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        // Confirm Password Field
        TextFormField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          enabled: !_isLoading,
          onFieldSubmitted: (_) => _handleSignup(),
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Re-enter your password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
              onPressed: () {
                setState(() {
                  _obscureConfirmPassword = !_obscureConfirmPassword;
                });
              },
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please confirm your password';
            }
            if (value != _passwordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        
        const SizedBox(height: 16),
        
        // Password Requirements
        _buildPasswordRequirements(theme),
        
        const SizedBox(height: 24),
        
        // Terms & Conditions
        _buildTermsCheckbox(theme),
        
        const SizedBox(height: 32),
        
        // Sign Up Button
        SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleSignup,
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  )
                : const Text('Create Account'),
          ),
        ),
        
        const Spacer(),
        
        // Login Link
        _buildLoginLink(theme),
        
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildPasswordRequirements(ThemeData theme) {
    final password = _passwordController.text;
    final hasMinLength = password.length >= 8;
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password requirements:',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildRequirementItem(theme, 'At least 8 characters', hasMinLength),
          _buildRequirementItem(theme, 'One uppercase letter', hasUppercase),
          _buildRequirementItem(theme, 'One lowercase letter', hasLowercase),
          _buildRequirementItem(theme, 'One number', hasNumber),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(ThemeData theme, String text, bool met) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            met ? Icons.check_circle : Icons.circle_outlined,
            size: 16,
            color: met ? Colors.green : theme.textTheme.bodySmall?.color,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: met ? Colors.green : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox(ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: _acceptTerms,
            onChanged: _isLoading
                ? null
                : (value) {
                    setState(() {
                      _acceptTerms = value ?? false;
                    });
                  },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodySmall,
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _showTermsDialog();
                    },
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      _showPrivacyDialog();
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider(ThemeData theme) {
    return Row(
      children: [
        Expanded(child: Divider(color: theme.dividerColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: theme.textTheme.bodySmall,
          ),
        ),
        Expanded(child: Divider(color: theme.dividerColor)),
      ],
    );
  }

  Widget _buildSocialButtons(ThemeData theme) {
    return Column(
      children: [
        // Google Sign Up
        SizedBox(
          height: 56,
          child: OutlinedButton.icon(
            onPressed: _isLoading ? null : _handleGoogleSignup,
            icon: _isLoading
                ? const SizedBox.shrink()
                : Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.g_mobiledata,
                      color: Colors.red,
                      size: 24,
                    ),
                  ),
            label: const Text('Sign up with Google'),
          ),
        ),
        
        const SizedBox(height: 12),
        
        // Apple Sign Up
        SizedBox(
          height: 56,
          child: OutlinedButton.icon(
            onPressed: _isLoading
                ? null
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Apple Sign-Up coming soon!'),
                      ),
                    );
                  },
            icon: const Icon(Icons.apple, size: 24),
            label: const Text('Sign up with Apple'),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginLink(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: theme.textTheme.bodyMedium,
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  context.go('/login');
                },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign In',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms & Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms & Conditions content goes here...\n\n'
            'This is a placeholder for your actual terms and conditions.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy Policy content goes here...\n\n'
            'This is a placeholder for your actual privacy policy.',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
