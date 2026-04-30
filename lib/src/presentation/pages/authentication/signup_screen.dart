import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumiere/src/core/constants/constants.dart';
import 'package:lumiere/src/core/enum/enum.dart';
import 'package:lumiere/src/core/theme/theme.dart';
import 'package:lumiere/src/presentation/widgets/textwidgets.dart';
import 'package:lumiere/src/presentation/widgets/button.dart';
import 'package:lumiere/src/presentation/widgets/flash_bar.dart';

import '../../blocs/auth/auth_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController      = TextEditingController();
  final _passwordController   = TextEditingController();
  final _confirmController    = TextEditingController();

  final _emailFocus      = FocusNode();
  final _passwordFocus   = FocusNode();
  final _confirmFocus    = FocusNode();

  bool _obscurePassword = true;
  bool _obscureConfirm  = true;
  bool _agreedToTerms   = false;

  // Password strength (0–4)
  int _passwordStrength = 0;

  // Colors
  late final Color _background    = AppColors.get(appColors.background);
  late final Color _primaryAction = AppColors.get(appColors.primary_action);
  late final Color _highlight     = AppColors.get(appColors.highlight);
  late final Color _card          = AppColors.get(appColors.card);
  late final Color _border        = AppColors.get(appColors.border);
  late final Color _olive         = AppColors.get(appColors.accent_success);

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updateStrength);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  // Password strength

  void _updateStrength() {
    final p = _passwordController.text;
    int score = 0;
    if (p.length >= 8)                        score++;
    if (RegExp(r'[A-Z]').hasMatch(p))         score++;
    if (RegExp(r'[0-9]').hasMatch(p))         score++;
    if (RegExp(r'[!@#\$&*~%^]').hasMatch(p)) score++;
    setState(() => _passwordStrength = score);
  }

  String _strengthLabel() {
    switch (_passwordStrength) {
      case 1:  return 'Weak password';
      case 2:  return 'Fair password';
      case 3:  return 'Good password';
      case 4:  return 'Strong password';
      default: return '';
    }
  }

  Color _strengthColor() {
    switch (_passwordStrength) {
      case 1:  return const Color(0xFFE57373);
      case 2:  return const Color(0xFFFFB74D);
      case 3:  return const Color(0xFF81C784);
      case 4:  return const Color(0xFF6B7C4A);
      default: return Colors.transparent;
    }
  }

  // Submit

  void _onCreateAccount() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (!_agreedToTerms) {
      showFlashbar(context, 'Please agree to the Terms of Service.', false);
      return;
    }

    if (_passwordController.text != _confirmController.text) {
      showFlashbar(context, 'Passwords do not match.', false);
      return;
    }

    context.read<AuthBloc>().add(
      SignUpWithPasswordRequested(
        email:       _emailController.text.trim(),
        password:    _passwordController.text,
        is_admin: false,
      ),
    );
  }

  // Build

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          showFlashbar(context, state.message, false);
        }
        if (state is AuthAuthenticated) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },

      child: Scaffold(
        backgroundColor: _primaryAction,
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _background,
                  borderRadius: const BorderRadius.only(
                    topLeft:  Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildField(
                          label:       'EMAIL ADDRESS',
                          hint:        'sarah@example.com',
                          controller:  _emailController,
                          focusNode:   _emailFocus,
                          nextFocus:   _passwordFocus,
                          icon:        Icons.email_outlined,
                          inputType:   TextInputType.emailAddress,
                          suffixWidget: _emailController.text.isNotEmpty
                              ? Icon(Icons.check_circle,
                              size: 18, color: _olive)
                              : null,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) return 'Required';
                            if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(v.trim())) return 'Invalid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),

                        // Password
                        _buildPasswordField(),
                        const SizedBox(height: 6),
                        _buildStrengthBar(),
                        const SizedBox(height: 8),

                        // Confirm password
                        _buildConfirmField(),
                        const SizedBox(height: 15),

                        // Terms
                        _buildTermsRow(),
                        const SizedBox(height: 20),

                        // CTA
                        _buildCreateButton(),
                        const SizedBox(height: 15),

                        _buildSignInRow(),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Header

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 24,
        right: 24,
        bottom: 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white.withOpacity(0.2), width: 1),
                  ),
                  child: const Icon(Icons.chevron_left,
                      color: Colors.white, size: 20),
                ),
              ),
              // Logo mark
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: _highlight, width: 1.5),
                ),
                child: Center(
                  child: Text('L',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 18, fontWeight: FontWeight.w400,
                      color: _highlight,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Create your\naccount',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 40, fontWeight: FontWeight.w300,
              fontStyle: FontStyle.italic, color: Colors.white, height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join the ${AppConstants.appName} family',
            style: GoogleFonts.dmSans(
              fontSize: 13, color: _highlight, letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // Generic field builder

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffixWidget,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 2),
        _inputContainer(
          child: Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF999490)),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller:       controller,
                  focusNode:        focusNode,
                  keyboardType:     inputType,
                  inputFormatters:  inputFormatters,
                  validator:        validator,
                  onChanged: (_) => setState(() {}),
                  style: GoogleFonts.dmSans(fontSize: 15, color: _primaryAction),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: hint,
                    hintStyle: GoogleFonts.dmSans(
                        fontSize: 15, color: const Color(0xFFB0AAA2)),
                    errorStyle: const TextStyle(height: 0),
                  ),
                  onFieldSubmitted: (_) => nextFocus != null
                      ? FocusScope.of(context).requestFocus(nextFocus)
                      : null,
                ),
              ),
              if (suffixWidget != null) suffixWidget,
            ],
          ),
        ),
      ],
    );
  }

  // Password field

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('PASSWORD'),
        const SizedBox(height: 2),
        _inputContainer(
          child: Row(
            children: [
              const Icon(Icons.lock_outline, size: 18, color: Color(0xFF999490)),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller:  _passwordController,
                  focusNode:   _passwordFocus,
                  obscureText: _obscurePassword,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (v.length < 8) return 'Min 8 characters';
                    return null;
                  },
                  style: GoogleFonts.dmSans(
                      fontSize: 15, color: _primaryAction),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: '••••••••',
                    hintStyle: GoogleFonts.dmSans(
                        fontSize: 15, color: const Color(0xFFB0AAA2)),
                    errorStyle: const TextStyle(height: 0),
                  ),
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_confirmFocus),
                ),
              ),
              GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18, color: const Color(0xFF999490),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Strength bar

  Widget _buildStrengthBar() {
    if (_passwordController.text.isEmpty) return const SizedBox.shrink();
    final color = _strengthColor();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 6),
        Row(
          children: List.generate(4, (i) {
            final filled = i < _passwordStrength;
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                height: 3,
                decoration: BoxDecoration(
                  color: filled ? color : _border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        Text(
          _strengthLabel(),
          style: GoogleFonts.dmSans(
              fontSize: 12, color: color, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // Confirm password

  Widget _buildConfirmField() {
    final matches = _confirmController.text.isNotEmpty &&
        _confirmController.text == _passwordController.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('CONFIRM PASSWORD'),
        const SizedBox(height: 8),
        _inputContainer(
          child: Row(
            children: [
              const Icon(Icons.lock_outline,
                  size: 18, color: Color(0xFF999490)),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller:  _confirmController,
                  focusNode:   _confirmFocus,
                  obscureText: _obscureConfirm,
                  onChanged:   (_) => setState(() {}),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Required';
                    if (v != _passwordController.text) return 'Passwords do not match';
                    return null;
                  },
                  style: GoogleFonts.dmSans(
                      fontSize: 15, color: _primaryAction),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: '••••••••',
                    hintStyle: GoogleFonts.dmSans(
                        fontSize: 15, color: const Color(0xFFB0AAA2)),
                    errorStyle: const TextStyle(height: 0),
                  ),
                  onFieldSubmitted: (_) => _onCreateAccount(),
                ),
              ),
              if (matches)
                Icon(Icons.check_circle, size: 18, color: _olive)
              else
                GestureDetector(
                  onTap: () =>
                      setState(() => _obscureConfirm = !_obscureConfirm),
                  child: Icon(
                    _obscureConfirm
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18, color: const Color(0xFF999490),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Terms row

  Widget _buildTermsRow() {
    return GestureDetector(
      onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 20, height: 20,
            decoration: BoxDecoration(
              color: _agreedToTerms ? _olive : Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: _agreedToTerms ? _olive : _border,
                width: 1.5,
              ),
            ),
            child: _agreedToTerms
                ? const Icon(Icons.check, size: 13, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: _primaryAction.withOpacity(0.6),
                    height: 1.4),
                children: [
                  const TextSpan(text: 'I agree to the '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _highlight),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: GoogleFonts.dmSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _highlight),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Create account button

  Widget _buildCreateButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Center(
          child: AppButton(
            'CREATE ACCOUNT',
            onPressed: isLoading ? null : _onCreateAccount,
            type:      ButtonType.primary,
            size:      ButtonSize.large,
            isLoading: isLoading,
            fullWidth: true,
          ),
        );
      },
    );
  }


  Widget _buildSignInRow() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.dmSans(
              fontSize: 13, color: _primaryAction.withOpacity(0.55)),
          children: [
            const TextSpan(text: 'Already have an account? '),
            WidgetSpan(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  'Sign in',
                  style: GoogleFonts.dmSans(
                    fontSize: 13, fontWeight: FontWeight.w600,
                    color: _highlight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helpers

  Widget _fieldLabel(String label) => AppText(
    label,
    type: TextType.label,
    color: _primaryAction.withOpacity(0.55),
    letterSpacing: 1.4,
  );

  Widget _inputContainer({required Widget child}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _border, width: 1),
    ),
    child: child,
  );
}