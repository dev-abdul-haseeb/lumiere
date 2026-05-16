import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumiere/src/core/constants/constants.dart';
import 'package:lumiere/src/core/enum/enum.dart';
import 'package:lumiere/src/core/theme/theme.dart';
import 'package:lumiere/src/presentation/pages/authentication/password_reset_screen.dart';
import 'package:lumiere/src/presentation/pages/authentication/signup_screen.dart';
import 'package:lumiere/src/presentation/widgets/textwidgets.dart';

import '../../blocs/application/application_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/button.dart';
import '../../widgets/flash_bar.dart';  // showFlashbar

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _obscurePassword     = true;

  // Colors (from AppColors)
  final Color _background    = AppColors.get(appColors.background);
  final Color _primaryAction = AppColors.get(appColors.primary_action);
  final Color _highlight     = AppColors.get(appColors.highlight);
  final Color _card          = AppColors.get(appColors.card);
  final Color _border        = AppColors.get(appColors.border);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Submit

  void _onSignIn() {
    final email    = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showFlashbar(context, 'Please fill in all fields.', false);
      return;
    }

    context.read<AuthBloc>().add(
      SignInWithPasswordRequested(email: email, password: password),
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
                  borderRadius: BorderRadius.only(
                    topLeft:  Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildEmailField(),
                      const SizedBox(height: 20),
                      _buildPasswordField(),
                      const SizedBox(height: 8),
                      _buildForgotPassword(),
                      const SizedBox(height: 28),
                      _buildSignInButton(),
                      const SizedBox(height: 24),
                      _buildDivider(),
                      const SizedBox(height: 20),
                      Center(
                        child: AppButton(
                          'Continue with Google',
                          leadingIcon: Icons.g_mobiledata,
                          onPressed: () {
                            context.read<AuthBloc>().add(SignInWithGmailRequested());
                          },
                          type: ButtonType.social,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _buildSignUpRow(),
                    ],
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
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, state) {
        final appName = state is ApplicationLoaded ? state.application.name.toUpperCase() : AppConstants.appName;
        return Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 24,
            left: 24,
            right: 24,
            bottom: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: _highlight, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        appName.isNotEmpty ? appName[0] : 'L',  // first letter dynamically
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: _highlight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    appName,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      letterSpacing: 3.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'Welcome\nback',
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 44,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to your account',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: _highlight,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Email Field

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('EMAIL ADDRESS'),
        const SizedBox(height: 8),
        _inputContainer(
          child: Row(
            children: [
              const Icon(Icons.email_outlined,
                  size: 18, color: Color(0xFF999490)),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  focusNode: _emailFocusNode,
                  autofocus: true,

                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: GoogleFonts.dmSans(
                      fontSize: 15, color: _primaryAction),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: 'sarah@example.com',
                    hintStyle: GoogleFonts.dmSans(
                        fontSize: 15, color: const Color(0xFFB0AAA2)),
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Password Field

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('PASSWORD'),
        const SizedBox(height: 8),
        _inputContainer(
          child: Row(
            children: [
              const Icon(Icons.lock_outline,
                  size: 18, color: Color(0xFF999490)),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  focusNode: _passwordFocusNode,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: GoogleFonts.dmSans(
                      fontSize: 15, color: _primaryAction),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    hintText: '••••••••',
                    hintStyle: GoogleFonts.dmSans(
                        fontSize: 15, color: const Color(0xFFB0AAA2)),
                  ),
                  onFieldSubmitted: (_) {
                    _onSignIn();
                  },
                ),
              ),
              GestureDetector(
                onTap: () => setState(
                        () => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  size: 18,
                  color: const Color(0xFF999490),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Forgot Password

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetScreen()));
        },
        child: Text(
          'Forgot password?',
          style: GoogleFonts.dmSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _highlight,
          ),
        ),
      ),
    );
  }

  // Sign In Button

  Widget _buildSignInButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Center(
          child: AppButton(
            'SIGN IN',
            onPressed: isLoading ? null : _onSignIn,
            type: ButtonType.primary,
            size: ButtonSize.large,
            color: Colors.white,
            bgcolor: _primaryAction,
            isLoading: isLoading,
            fullWidth: true,
            leadingIcon: Icons.login,
          ),
        );
      },
    );
  }

  // Divider

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: _border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: AppText(
            'or continue with',
            type: TextType.caption,
            align: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            color: AppColors.get(appColors.primary_action)
          )
        ),
        Expanded(child: Divider(color: _border, thickness: 1)),
      ],
    );
  }

  // ── Sign Up Row ───────────────────────────────────────────────────────────

  Widget _buildSignUpRow() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.dmSans(
            fontSize: 13,
            color: _primaryAction.withOpacity(0.55),
          ),
          children: [
            const TextSpan(text: "Don't have an account? "),
            WidgetSpan(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignupScreen()));
                },
                child: Text(
                  'Sign up',
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _fieldLabel(String label) {
    return AppText(
      label,
      color: AppColors.get(appColors.primary_action).withOpacity(0.55),
      type: TextType.label,
      letterSpacing: 1.4,
    );
  }

  Widget _inputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border, width: 1),
      ),
      child: child,
    );
  }
}