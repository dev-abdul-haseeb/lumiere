import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumiere/src/core/enum/enum.dart';
import 'package:lumiere/src/core/theme/theme.dart';
import 'package:lumiere/src/presentation/widgets/button.dart';
import 'package:lumiere/src/presentation/widgets/flash_bar.dart';
import 'package:lumiere/src/presentation/widgets/textwidgets.dart';

import '../../../domain/entities/user.dart';
import '../../blocs/auth/auth_bloc.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();

  final _emailFocus     = FocusNode();

  late final Color _background    = AppColors.get(appColors.background);
  late final Color _primaryAction = AppColors.get(appColors.primary_action);
  late final Color _highlight     = AppColors.get(appColors.highlight);
  late final Color _card          = AppColors.get(appColors.card);
  late final Color _border        = AppColors.get(appColors.border);

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthBloc>().add(
      ForgetPasswordRequested(
        email:   _emailController.text.trim(),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final topPad    = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnAuthenticated) {
          showFlashbar(context, 'Password reset link sent to you', false);
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        if (state is AuthFailure) {
          showFlashbar(context, state.message, false);
        }
      },
      child: Scaffold(
        backgroundColor: _primaryAction,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Dark header ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.only(
                top: topPad + 20,
                left: 24, right: 24, bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 20),

                  AppText(
                    'Password Reset',
                    color: AppColors.get(appColors.highlight),
                    type: TextType.heroTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // ── Cream form section ───────────────────────────────────────
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
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 32, 24, bottomPad + 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          'Enter your email to get a password-reset link:',
                          color: AppColors.get(appColors.primary_action),
                          type: TextType.screenTitle,
                          overflow: TextOverflow.clip,
                        ),

                        _buildField(
                          label:      'Email',
                          hint:       'sarah@gmail.com',
                          controller: _emailController,
                          focusNode:  _emailFocus,
                          icon:       Icons.person_outline,
                          validator:  (v) => (v == null || v.trim().isEmpty)
                              ? 'Required' : null,
                        ),
                        const SizedBox(height: 20),

                        // Continue button
                        _buildContinueButton(),
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

  // Generic field

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 8),
        _inputContainer(
          child: Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF999490)),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller:       controller,
                  focusNode:        focusNode,
                  keyboardType:     inputType,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator:        validator,
                  style: GoogleFonts.dmSans(fontSize: 15, color: _primaryAction),
                  decoration: InputDecoration(
                    border:     InputBorder.none,
                    isDense:    true,
                    hintText:   hint,
                    hintStyle:  GoogleFonts.dmSans(
                        fontSize: 15, color: const Color(0xFFB0AAA2)),
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                  ),
                  onFieldSubmitted: (_) => _onContinue()
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Continue button ───────────────────────────────────────────────────────

  Widget _buildContinueButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Center(
          child: AppButton(
            'CONTINUE',
            onPressed:  isLoading ? null : _onContinue,
            type: ButtonType.primary,
            size: ButtonSize.large,
            isLoading: isLoading,
            fullWidth: true,
            trailingIcon: Icons.arrow_forward,
          ),
        );
      },
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _fieldLabel(String label) => AppText(
    label,
    type: TextType.label,
    color: _primaryAction.withOpacity(0.55),
    letterSpacing: 1.4,
  );

  Widget _inputContainer({required Widget child}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: _border, width: 1),
    ),
    child: child,
  );
}