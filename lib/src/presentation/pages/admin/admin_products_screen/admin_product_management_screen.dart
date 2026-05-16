import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lumiere/src/core/enum/enum.dart';
import 'package:lumiere/src/core/theme/theme.dart';
import 'package:lumiere/src/presentation/blocs/product/product_bloc.dart';
import 'package:lumiere/src/presentation/widgets/button.dart';
import 'package:lumiere/src/presentation/widgets/flash_bar.dart';
import 'package:lumiere/src/presentation/widgets/textwidgets.dart';

import '../../../../domain/entities/products.dart';

class AdminProductManagementScreen extends StatefulWidget {
  final Products? existingProduct; // null = add mode, non-null = edit mode
  const AdminProductManagementScreen({super.key, this.existingProduct});

  @override
  State<AdminProductManagementScreen> createState() =>
      _AdminProductManagementScreenState();
}
class _AdminProductManagementScreenState
    extends State<AdminProductManagementScreen> {
  final _nameController        = TextEditingController();
  final _subtitleController    = TextEditingController();
  final _costPriceController       = TextEditingController();
  final _salePriceController       = TextEditingController();
  final _volumeController      = TextEditingController();
  final _stockController       = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();

  String _existingImageUrl = '';

  bool     _isNewArrival     = false;
  bool     _isFeatured       = false;
  XFile?   _imageFile;

  late final Color _bg;
  late final Color _dark;
  late final Color _gold;
  late final Color _olive;
  late final Color _card;
  late final Color _border;

  @override
  void initState() {
    super.initState();
    _bg     = AppColors.get(appColors.background);
    _dark   = AppColors.get(appColors.primary_action);
    _gold   = AppColors.get(appColors.highlight);
    _olive  = AppColors.get(appColors.accent_success);
    _card   = AppColors.get(appColors.card);
    _border = AppColors.get(appColors.border);

    // Pre-fill for edit mode
    final p = widget.existingProduct;
    if (p != null) {
      _nameController.text        = p.productName;
      _subtitleController.text    = p.subtitle;
      _costPriceController.text       = p.cost_price.toString();
      _salePriceController.text       = p.sale_price.toString();
      _volumeController.text      = p.volume.toString();
      _stockController.text       = p.stock_quantity.toString();
      _descriptionController.text = p.description;
      _categoryController.text    = p.category;
      _isNewArrival               = p.isNewArrival;
      _isFeatured                 = p.isFeatured;
      _existingImageUrl           = p.image_link;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subtitleController.dispose();
    _costPriceController.dispose();
    _salePriceController.dispose();
    _volumeController.dispose();
    _stockController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 85,
    );
    if (picked != null) setState(() => _imageFile = picked);
  }

  void _onPublish() {
    if (_nameController.text.trim().isEmpty) {
      showFlashbar(context, 'Product name is required.', false);
      return;
    }
    if (_costPriceController.text.trim().isEmpty) {
      showFlashbar(context, 'Cost price is required.', false);
      return;
    }
    if (_salePriceController.text.trim().isEmpty) {
      showFlashbar(context, 'Sale price is required.', false);
      return;
    }
    if (_stockController.text.trim().isEmpty) {
      showFlashbar(context, 'Stock quantity is required.', false);
      return;
    }

    final isEditing = widget.existingProduct != null;

    if (isEditing) {
      context.read<ProductBloc>().add(
        UpdateProductRequested(
          productId:        widget.existingProduct!.productId,
          name:             _nameController.text.trim(),
          subtitle:         _subtitleController.text.trim(),
          costPrice:        double.tryParse(_costPriceController.text) ?? 0.0,
          salePrice:        double.tryParse(_salePriceController.text) ?? 0.0,
          volume:           int.tryParse(_volumeController.text) ?? 0,
          category:         _categoryController.text.trim(),
          stock:            int.tryParse(_stockController.text) ?? 0,
          description:      _descriptionController.text.trim(),
          isNewArrival:     _isNewArrival,
          isFeatured:       _isFeatured,
          existingImageUrl: _existingImageUrl,
          imagePath:        _imageFile?.path,
        ),
      );
    } else {
      context.read<ProductBloc>().add(
        AddProductRequested(
          name:         _nameController.text.trim(),
          subtitle:     _subtitleController.text.trim(),
          costPrice:    double.tryParse(_costPriceController.text) ?? 0.0,
          salePrice:    double.tryParse(_salePriceController.text) ?? 0.0,
          volume:       int.tryParse(_volumeController.text) ?? 0,
          category:     _categoryController.text.trim(),
          stock:        int.tryParse(_stockController.text) ?? 0,
          description:  _descriptionController.text.trim(),
          isNewArrival: _isNewArrival,
          isFeatured:   _isFeatured,
          imagePath:    _imageFile?.path,
        ),
      );
    }
  }  // Build

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 720;

    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductAdded) {
          showFlashbar(context, 'Product published successfully.', true);
          Navigator.of(context).pop();
        } else if (state is ProductUpdated) {
          showFlashbar(context, 'Product updated successfully.', true);
          Navigator.of(context).pop();
        } else if (state is ProductError) {
          showFlashbar(context, state.message, false);
        }
      },
      child: Scaffold(
        backgroundColor: _bg,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              Expanded(
                child: isWide
                    ? _buildWideLayout()
                    : _buildNarrowLayout(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Top Bar ───────────────────────────────────────────────────────────────

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: _dark,
        boxShadow: [
          BoxShadow(
            color: _dark.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white70, size: 18),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  widget.existingProduct != null ? 'EDIT PRODUCT' : 'ADD PRODUCT',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 2.5,
                  )),
              Text('New listing',
                  style: GoogleFonts.dmSans(
                      fontSize: 11, color: _gold, letterSpacing: 0.5)),
            ],
          ),
          const Spacer(),
          // Quick status chips
          _statusPill('DRAFT', Colors.white24, Colors.white54),
        ],
      ),
    );
  }

  Widget _statusPill(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: GoogleFonts.dmSans(
              fontSize: 10, fontWeight: FontWeight.w600,
              color: fg, letterSpacing: 1.5)),
    );
  }

  // ── Wide Layout (Windows / tablet) ────────────────────────────────────────

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left panel — image + flags + actions
        Container(
          width: 300,
          color: _card,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageUpload(),
                      const SizedBox(height: 24),
                      _sectionDivider('VISIBILITY'),
                      const SizedBox(height: 12),
                      _buildFlags(),
                    ],
                  ),
                ),
              ),
              _buildActionsPanel(),
            ],
          ),
        ),
        // Thin border
        VerticalDivider(width: 1, color: _border),
        // Right panel — all fields
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionDivider('PRODUCT DETAILS'),
                const SizedBox(height: 16),
                _fieldLabel('PRODUCT NAME'),
                const SizedBox(height: 8),
                _inputField(
                    controller: _nameController,
                    hint: 'Lumière Eye Complex'),
                const SizedBox(height: 16),
                _fieldLabel('SUBTITLE'),
                const SizedBox(height: 8),
                _inputField(
                    controller: _subtitleController,
                    hint: 'Peptide Eye Complex'),
                // In _buildWideLayout(), inside the right panel Column, after the subtitle field:
                const SizedBox(height: 16),
                _fieldLabel('CATEGORY'),
                const SizedBox(height: 8),
                _inputField(
                    controller: _categoryController,
                    hint: 'e.g. Serums, Toners, Moisturizers'),
                const SizedBox(height: 24),
                _sectionDivider('PRICING & INVENTORY'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _labeledField(
                      label: 'COST PRICE (\$)',
                      controller: _costPriceController,
                      hint: '115.00',
                      inputType: const TextInputType.numberWithOptions(decimal: true),
                      formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    )),
                    const SizedBox(width: 16),
                    Expanded(child: _labeledField(
                      label: 'SALE PRICE (\$)',
                      controller: _salePriceController,
                      hint: '115.00',
                      inputType: const TextInputType.numberWithOptions(decimal: true),
                      formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    )),
                    const SizedBox(width: 16),
                    Expanded(child: _labeledField(
                      label: 'VOLUME (ml)',
                      controller: _volumeController,
                      hint: '15',
                      inputType: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                    )),
                    const SizedBox(width: 16),
                    Expanded(child: _labeledField(
                      label: 'STOCK QTY',
                      controller: _stockController,
                      hint: '200',
                      inputType: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                    )),
                  ],
                ),
                const SizedBox(height: 24),
                _sectionDivider('DESCRIPTION'),
                const SizedBox(height: 16),
                _descriptionField(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Narrow Layout (Android / small screens) ───────────────────────────────

  Widget _buildNarrowLayout() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageUpload(),
                const SizedBox(height: 20),
                _sectionDivider('PRODUCT DETAILS'),
                const SizedBox(height: 14),
                _fieldLabel('PRODUCT NAME'),
                const SizedBox(height: 8),
                _inputField(
                    controller: _nameController,
                    hint: 'Lumière Eye Complex'),
                const SizedBox(height: 14),
                _fieldLabel('SUBTITLE'),
                const SizedBox(height: 8),
                _inputField(controller: _subtitleController, hint: 'Peptide Eye Complex'),
                const SizedBox(height: 14),
                _fieldLabel('Category'),
                const SizedBox(height: 8),
                _inputField(controller: _categoryController, hint: 'Peptide Eye Complex'),
                const SizedBox(height: 20),
                _sectionDivider('PRICING & INVENTORY'),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _labeledField(
                      label: 'COST PRICE (\$)',
                      controller: _costPriceController,
                      hint: '115.00',
                      inputType: const TextInputType.numberWithOptions(decimal: true),
                      formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _labeledField(
                      label: 'SALE PRICE (\$)',
                      controller: _salePriceController,
                      hint: '115.00',
                      inputType: const TextInputType.numberWithOptions(decimal: true),
                      formatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
                    )),
                    const SizedBox(width: 12),
                    Expanded(child: _labeledField(
                      label: 'VOLUME (ml)',
                      controller: _volumeController,
                      hint: '15',
                      inputType: TextInputType.number,
                      formatters: [FilteringTextInputFormatter.digitsOnly],
                    )),
                  ],
                ),
                const SizedBox(height: 14),
                _labeledField(
                  label: 'STOCK QTY',
                  controller: _stockController,
                  hint: '200',
                  inputType: TextInputType.number,
                  formatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                const SizedBox(height: 20),
                _sectionDivider('DESCRIPTION'),
                const SizedBox(height: 14),
                _descriptionField(),
                const SizedBox(height: 20),
                _sectionDivider('VISIBILITY'),
                const SizedBox(height: 14),
                _buildFlags(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        _buildActionsPanel(),
      ],
    );
  }

  // ── Image Upload ──────────────────────────────────────────────────────────

  Widget _buildImageUpload() {
    return GestureDetector(
      onTap: _pickImage,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: (_imageFile != null || _existingImageUrl.isNotEmpty)
                  ? _olive
                  : _border,
              width: (_imageFile != null || _existingImageUrl.isNotEmpty) ? 2 : 1.5,
            ),
          ),
          child: _imageFile != null
          // Newly picked image
              ? ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: kIsWeb
                ? Image.network(_imageFile!.path, fit: BoxFit.cover)
                : Image.file(File(_imageFile!.path), fit: BoxFit.cover),
          )
              : _existingImageUrl.isNotEmpty
          // Existing image from Firestore
              ? Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(13),
                child: Image.network(
                  _existingImageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _imagePlaceholder(),
                ),
              ),
              // Tap-to-change overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13),
                  child: Container(
                    color: Colors.black26,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_rounded,
                              color: Colors.white70, size: 20),
                          const SizedBox(height: 6),
                          Text('Tap to change photo',
                              style: GoogleFonts.dmSans(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
          // No image at all
              : _imagePlaceholder(),
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: _dark.withOpacity(0.06),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add_photo_alternate_outlined,
              size: 24, color: _dark.withOpacity(0.4)),
        ),
        const SizedBox(height: 12),
        AppText('Tap to upload product image',
            type: TextType.bodyText, color: _dark.withOpacity(0.55)),
        const SizedBox(height: 4),
        AppText('PNG or JPG · max 5 MB',
            type: TextType.caption, color: _dark.withOpacity(0.3)),
      ],
    );
  }
  // ── Description ───────────────────────────────────────────────────────────

  Widget _descriptionField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: 5,
        style: GoogleFonts.cormorantGaramond(
            fontSize: 15, fontStyle: FontStyle.italic, color: _dark),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText:
          'A concentrated peptide treatment targeting dark circles and puffiness...',
          hintStyle: GoogleFonts.cormorantGaramond(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: _dark.withOpacity(0.3)),
        ),
      ),
    );
  }

  // ── Flags ─────────────────────────────────────────────────────────────────

  Widget _buildFlags() {
    return Row(
      children: [
        _flagChip(
          label: 'New Arrival',
          icon: Icons.fiber_new_rounded,
          value: _isNewArrival,
          onChanged: (v) => setState(() => _isNewArrival = v),
        ),
        const SizedBox(width: 10),
        _flagChip(
          label: 'Featured',
          icon: Icons.star_rounded,
          value: _isFeatured,
          onChanged: (v) => setState(() => _isFeatured = v),
        ),
      ],
    );
  }

  Widget _flagChip({
    required String label,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: value ? _olive.withOpacity(0.1) : _card,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: value ? _olive : _border,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 15,
                  color: value ? _olive : _dark.withOpacity(0.35)),
              const SizedBox(width: 6),
              Text(label,
                  style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: value ? _olive : _dark.withOpacity(0.5),
                    letterSpacing: 0.3,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // ── Actions Panel (sticky bottom) ─────────────────────────────────────────

  Widget _buildActionsPanel() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        final isLoading = state is ProductLoading;
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          decoration: BoxDecoration(
            color: _card,
            border: Border(top: BorderSide(color: _border)),
          ),
          child: AppButton(           // ← remove the Expanded wrapper
            'PUBLISH',
            onPressed: isLoading ? null : _onPublish,
            type: ButtonType.primary,
            size: ButtonSize.large,
            fullWidth: true,
            isLoading: isLoading,
          ),
        );
      },
    );
  }
  // Helpers

  Widget _sectionDivider(String label) {
    return Row(
      children: [
        Text(label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: _dark.withOpacity(0.35),
              letterSpacing: 2,
            )),
        const SizedBox(width: 10),
        Expanded(child: Divider(color: _border, height: 1)),
      ],
    );
  }

  Widget _fieldLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: AppText(
      text,
      type: TextType.label,
      color: _dark.withOpacity(0.5),
      letterSpacing: 1.2,
    ),
  );

  Widget _labeledField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? formatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 8),
        _inputField(
            controller: controller,
            hint: hint,
            inputType: inputType,
            formatters: formatters),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? formatters,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        inputFormatters: formatters,
        style: GoogleFonts.cormorantGaramond(
            fontSize: 16, fontStyle: FontStyle.italic, color: _dark),
        decoration: InputDecoration(
          border: InputBorder.none,
          isDense: true,
          hintText: hint,
          hintStyle: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: _dark.withOpacity(0.3)),
        ),
      ),
    );
  }
}