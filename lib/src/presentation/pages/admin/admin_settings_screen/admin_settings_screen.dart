import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumiere/src/core/enum/enum.dart';
import 'package:lumiere/src/core/theme/theme.dart';
import 'package:lumiere/src/presentation/blocs/application/application_bloc.dart';
import 'package:lumiere/src/presentation/blocs/auth/auth_bloc.dart';
import 'package:lumiere/src/presentation/pages/authentication/password_reset_screen.dart';
import 'package:lumiere/src/presentation/widgets/button.dart';
import 'package:lumiere/src/presentation/widgets/flash_bar.dart';
import 'package:lumiere/src/presentation/widgets/textwidgets.dart';

import '../../../../data/models/application_model.dart';
import '../../../../domain/entities/application.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  final _nameController           = TextEditingController();
  final _subTitleController       = TextEditingController();
  final _taglineController        = TextEditingController();
  final _emailController          = TextEditingController();
  final _freeShippingController  = TextEditingController();
  final _standardRateController  = TextEditingController();
  final _expressRateController   = TextEditingController();

  bool _populated = false;

  final Color _bg      = AppColors.get(appColors.background);
  final Color _dark    = AppColors.get(appColors.primary_action);
  final Color _gold    = AppColors.get(appColors.highlight);
  final Color _olive   = AppColors.get(appColors.accent_success);
  final Color _card    = AppColors.get(appColors.card);
  final Color _border  = AppColors.get(appColors.border);

  @override
  void dispose() {
    _nameController.dispose();
    _taglineController.dispose();
    _subTitleController.dispose();
    _emailController.dispose();
    _freeShippingController.dispose();
    _standardRateController.dispose();
    _expressRateController.dispose();
    super.dispose();
  }

  void _populate(Application app) {
    if (_populated) return;
    _nameController.text         = app.name;
    _taglineController.text      = app.tagLine;
    _subTitleController.text      = app.subTitle;
    _emailController.text        = app.contact_email;
    _freeShippingController.text = app.free_shipping_threshold.toStringAsFixed(2);
    _standardRateController.text = app.standard_shipping_rate.toStringAsFixed(2);
    _expressRateController.text  = app.express_shipping_rate.toStringAsFixed(2);
    _populated = true;
  }
  void _onSave(Application current) {
    final updated = current.copyWith(
      name:                     _nameController.text.trim(),
      tagLine:                  _taglineController.text.trim(),
      subTitle:                 _subTitleController.text.trim(),
      contact_email:            _emailController.text.trim(),
      free_shipping_threshold: double.tryParse(_freeShippingController.text) ?? current.free_shipping_threshold,
      standard_shipping_rate:  double.tryParse(_standardRateController.text) ?? current.standard_shipping_rate,
      express_shipping_rate:   double.tryParse(_expressRateController.text)  ?? current.express_shipping_rate,
    );
    context.read<ApplicationBloc>().add(UpdateApplicationData(updated));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplicationBloc, ApplicationState>(
      listener: (context, state) {
        if (state is ApplicationUpdated) {
          _populated = false;
          showFlashbar(context, 'Settings saved successfully.', true);
        } else if (state is ApplicationError) {
          showFlashbar(context, state.message, false);
        }
      },
      builder: (context, state) {
        Application? current;

        if (state is ApplicationLoaded) {
          _populate(state.application);
          current = state.application;
        } else if (state is ApplicationUpdated) {
          _populate(state.application);
          current = state.application;
        } else if (state is ApplicationError && !_populated) {
          // collection was empty — still enable the save button with a dummy
          current = ApplicationModel(
            id: '',
            name: '',
            tagLine: '',
            subTitle: '',
            contact_email: '',
            free_shipping_threshold: 0.0,
            standard_shipping_rate: 0.0,
            express_shipping_rate: 0.0,
          );
        }

        final isLoading = state is ApplicationLoading;

        return Scaffold(
          backgroundColor: _bg,
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page title
                AppText(
                  'Settings',
                  type: TextType.sectionHeading,
                  color: _dark,
                ),
                const SizedBox(height: 24),

                // Two-column layout on wide screens
                LayoutBuilder(
                  builder: (context, constraints) {
                    final isWide = constraints.maxWidth >= 700;

                    if (isWide) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 55, child: _buildStoreInfoCard(current, isLoading)),
                          const SizedBox(width: 20),
                          Expanded(flex: 45, child: _buildShippingCard(current, isLoading)),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        _buildStoreInfoCard(current, isLoading),
                        const SizedBox(height: 20),
                        _buildShippingCard(current, isLoading),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),
                _buildDangerZone(),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Store Information Card ────────────────────────────────────────────────

  Widget _buildStoreInfoCard(Application? current, bool isLoading) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('STORE INFORMATION'),
          const SizedBox(height: 20),
          _fieldLabel('Store Name'),
          const SizedBox(height: 8),
          _inputField(controller: _nameController, hint: 'LUMIÈRE'),
          const SizedBox(height: 16),
          _fieldLabel('Tagline'),
          const SizedBox(height: 8),
          _inputField(controller: _taglineController, hint: 'Luxury Skincare'),
          const SizedBox(height: 16),
          _fieldLabel('SubTitle'),
          const SizedBox(height: 8),
          _inputField(controller: _subTitleController, hint: 'Crafted for skin that deserves nothing less than extraordinary'),
          const SizedBox(height: 16),
          _fieldLabel('Contact Email'),
          const SizedBox(height: 8),
          _inputField(
            controller: _emailController,
            hint: 'hello@lumiere.com',
            inputType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          AppButton(
            'SAVE CHANGES',
            onPressed: (isLoading || current == null) ? null : () => _onSave(current),
            type: ButtonType.primary,
            size: ButtonSize.large,
            fullWidth: true,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  // ── Shipping Card ─────────────────────────────────────────────────────────

  Widget _buildShippingCard(Application? current, bool isLoading) {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('SHIPPING'),
          const SizedBox(height: 20),
          _shippingRow(
            title:    'Free shipping threshold',
            subtitle: 'Orders above this get free shipping',
            controller: _freeShippingController,
            prefix: '\$',
          ),
          _divider(),
          _shippingRow(
            title:    'Standard shipping rate',
            subtitle: 'Below threshold',
            controller: _standardRateController,
            prefix: '\$',
          ),
          _divider(),
          _shippingRow(
            title:    'Express shipping rate',
            subtitle: '1–2 business days',
            controller: _expressRateController,
            prefix: '\$',
          ),
        ],
      ),
    );
  }

  Widget _shippingRow({
    required String title,
    required String subtitle,
    required TextEditingController controller,
    String prefix = '',
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(title, type: TextType.bodyText, color: _dark),
                const SizedBox(height: 2),
                AppText(subtitle, type: TextType.caption, color: _dark.withOpacity(0.45)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 88,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: _card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _border),
              ),
              child: Row(
                children: [
                  Text(prefix,
                      style: GoogleFonts.dmSans(
                          fontSize: 14, fontWeight: FontWeight.w500, color: _dark)),
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      ],
                      style: GoogleFonts.dmSans(fontSize: 14, color: _dark),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Danger Zone ───────────────────────────────────────────────────────────

  Widget _buildDangerZone() {
    const dangerText = Color(0xFF791F1F);
    const dangerBg   = Color(0xFFFCEBEB);
    const dangerBdr  = Color(0xFFE8C5C5);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: dangerBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: dangerBdr),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Danger zone',
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: dangerText,
                    )),
                const SizedBox(height: 2),
                AppText(
                  'Reset all store data or change admin password',
                  type: TextType.caption,
                  color: dangerText.withOpacity(0.7),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          AppButton(
            'Change password',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>PasswordResetScreen()));
            },
            type: ButtonType.danger,
            size: ButtonSize.small,
            fullWidth: false,
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _cardContainer({required Widget child}) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: _card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: _border),
    ),
    child: child,
  );

  Widget _sectionLabel(String text) => AppText(
    text,
    type: TextType.label,
    color: _dark.withOpacity(0.5),
    letterSpacing: 1.6,
  );

  Widget _fieldLabel(String text) => AppText(
    text,
    type: TextType.caption,
    color: _dark.withOpacity(0.6),
  );

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        style: GoogleFonts.cormorantGaramond(
          fontSize: 16,
          fontStyle: FontStyle.italic,
          color: _dark,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: hint,
          hintStyle: GoogleFonts.cormorantGaramond(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: _dark.withOpacity(0.35),
          ),
        ),
      ),
    );
  }

  Widget _divider() => Divider(color: _border, thickness: 1, height: 1);
}