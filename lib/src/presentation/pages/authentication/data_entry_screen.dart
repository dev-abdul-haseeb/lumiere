import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumiere/src/core/constants/constants.dart';
import 'package:lumiere/src/core/enum/enum.dart';
import 'package:lumiere/src/core/theme/theme.dart';
import 'package:lumiere/src/presentation/widgets/button.dart';
import 'package:lumiere/src/presentation/widgets/flash_bar.dart';
import 'package:lumiere/src/presentation/widgets/textwidgets.dart';

import '../../../domain/entities/user.dart';
import '../../blocs/application/application_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';

class DataEntryScreen extends StatefulWidget {
  final User user;
  const DataEntryScreen({super.key, required this.user});

  @override
  State<DataEntryScreen> createState() => _DataEntryScreenState();
}

class _DataEntryScreenState extends State<DataEntryScreen> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController  = TextEditingController();
  final _phoneController     = TextEditingController();

  final _firstNameFocus = FocusNode();
  final _lastNameFocus  = FocusNode();
  final _phoneFocus     = FocusNode();

  late final Color _background    = AppColors.get(appColors.background);
  late final Color _primaryAction = AppColors.get(appColors.primary_action);
  late final Color _highlight     = AppColors.get(appColors.highlight);
  late final Color _card          = AppColors.get(appColors.card);
  late final Color _border        = AppColors.get(appColors.border);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _phoneFocus.dispose();
    super.dispose();
  }

  // Submit

  void _onContinue() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    context.read<AuthBloc>().add(
      UpdateUserDataRequested(
        user: widget.user,
        first_name:   _firstNameController.text.trim(),
        last_name:    _lastNameController.text.trim(),
        phone_number: _phoneController.text.trim(),
      ),
    );
  }

  // Build

  @override
  Widget build(BuildContext context) {
    final topPad    = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
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

            // Dark header
            Padding(
              padding: EdgeInsets.only(
                top: topPad + 20,
                left: 24, right: 24, bottom: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo mark
                  BlocBuilder<ApplicationBloc, ApplicationState>(
                    builder: (context, state) {
                      final initial = state is ApplicationLoaded ? state.application.name[0].toUpperCase() : AppConstants.appName[0].toUpperCase();

                      return Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: _highlight, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: GoogleFonts.cormorantGaramond(
                              fontSize: 18, fontWeight: FontWeight.w400,
                              color: _highlight,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  AppText(
                    'Almost there',
                    color: AppColors.get(appColors.card),
                    type: TextType.heroTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tell us a little about yourself',
                    style: GoogleFonts.dmSans(
                      fontSize: 13, color: _highlight, letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            // Cream form section
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
                      children: [


                        _buildField(
                          label:      'FIRST NAME',
                          hint:       'Sarah',
                          controller: _firstNameController,
                          focusNode:  _firstNameFocus,
                          nextFocus:  _lastNameFocus,
                          icon:       Icons.person_outline,
                          validator:  (v) => (v == null || v.trim().isEmpty)
                              ? 'Required' : null,
                        ),
                        _buildField(
                          label:      'LAST NAME',
                          hint:       'Johnson',
                          controller: _lastNameController,
                          focusNode:  _lastNameFocus,
                          nextFocus:  _phoneFocus,
                          icon:       Icons.person_outline,
                          validator:  (v) => (v == null || v.trim().isEmpty)
                              ? 'Required' : null,
                        ),
                        const SizedBox(height: 20),

                        // Phone number
                        _buildPhoneField(),
                        const SizedBox(height: 8),

                        // Pakistani format hint
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: AppText(
                            'Format: 03XX-XXXXXXX or +92 3XX XXXXXXX',
                            type: TextType.caption,
                            color: _primaryAction.withOpacity(0.4),
                          ),
                        ),
                        const Spacer(),

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
    FocusNode? nextFocus,
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
                  onFieldSubmitted: (_) => nextFocus != null
                      ? FocusScope.of(context).requestFocus(nextFocus)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Phone field

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('PHONE NUMBER'),
        const SizedBox(height: 8),
        _inputContainer(
          child: Row(
            children: [
              // Pakistan flag + code
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _border.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🇵🇰', style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 4),
                    Text('+92',
                      style: GoogleFonts.dmSans(
                        fontSize: 14, fontWeight: FontWeight.w500,
                        color: _primaryAction,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // Divider
              Container(width: 1, height: 18, color: _border),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller:       _phoneController,
                  focusNode:        _phoneFocus,
                  keyboardType:     TextInputType.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9\s\-]')),
                    LengthLimitingTextInputFormatter(12),
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    // Strip spaces/dashes for length check
                    final digits = v.replaceAll(RegExp(r'[\s\-]'), '');
                    // Accept with or without leading 0: 3XX XXXXXXX (10) or 03XX XXXXXXX (11 with 0)
                    if (!RegExp(r'^0?3[0-9]{9}$').hasMatch(digits)) {
                      return 'Enter a valid Pakistani number';
                    }
                    return null;
                  },
                  style: GoogleFonts.dmSans(fontSize: 15, color: _primaryAction),
                  decoration: InputDecoration(
                    border:     InputBorder.none,
                    isDense:    true,
                    hintText:   '3XX XXXXXXX',
                    hintStyle:  GoogleFonts.dmSans(
                        fontSize: 15, color: const Color(0xFFB0AAA2)),
                    errorStyle: const TextStyle(height: 0, fontSize: 0),
                  ),
                  onFieldSubmitted: (_) => _onContinue(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Continue button

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

  // Helpers

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