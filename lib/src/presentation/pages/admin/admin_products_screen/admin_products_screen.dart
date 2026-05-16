import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumiere/src/core/enum/enum.dart';
import 'package:lumiere/src/core/theme/theme.dart';
import 'package:lumiere/src/domain/entities/products.dart';
import 'package:lumiere/src/presentation/blocs/product/product_bloc.dart';
import 'package:lumiere/src/presentation/pages/admin/admin_products_screen/admin_product_management_screen.dart';
import 'package:lumiere/src/presentation/widgets/button.dart';
import 'package:lumiere/src/presentation/widgets/flash_bar.dart';
import 'package:lumiere/src/presentation/widgets/textwidgets.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery      = '';
  String _selectedCategory = 'All Categories';
  String _selectedStatus   = 'All Status';

  final Color _bg     = AppColors.get(appColors.background);
  final Color _dark   = AppColors.get(appColors.primary_action);
  final Color _gold   = AppColors.get(appColors.highlight);
  final Color _olive  = AppColors.get(appColors.accent_success);
  final Color _card   = AppColors.get(appColors.card);
  final Color _border = AppColors.get(appColors.border);

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(const FetchProductsRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _statusOf(Products p) {
    if (p.stock_quantity == 0) return 'Out of stock';
    if (p.stock_quantity <= 10) return 'Low stock';
    return 'Active';
  }

  List<Products> _filtered(List<Products> all) {
    return all.where((p) {
      final matchSearch   = _searchQuery.isEmpty ||
          p.productName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchCategory = _selectedCategory == 'All Categories' ||
          p.category == _selectedCategory;
      final matchStatus   = _selectedStatus == 'All Status' ||
          _statusOf(p) == _selectedStatus;
      return matchSearch && matchCategory && matchStatus;
    }).toList();
  }

  List<String> _categoryOptions(List<Products> all) {
    final cats = all.map((p) => p.category).toSet().toList();
    return ['All Categories', ...cats];
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ProductDeleted) {
          showFlashbar(context, 'Product deleted.', true);
        } else if (state is ProductError) {
          showFlashbar(context, state.message, false);
        }
      },
      builder: (context, state) {
        final products = state is ProductsFetched ? state.products : <Products>[];
        final isLoading = state is ProductLoading;
        final filtered  = _filtered(products);

        return Scaffold(
          backgroundColor: _bg,
          body: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(products),
                const SizedBox(height: 20),
                _buildSearchBar(products),
                const SizedBox(height: 16),
                _buildTableHeader(),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator(color: _gold))
                      : filtered.isEmpty
                      ? _buildEmpty()
                      : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filtered.length,
                    itemBuilder: (_, i) => _buildProductRow(
                      filtered[i],
                      i == filtered.length - 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Header

  Widget _buildHeader(List<Products> products) {
    final categoryCount = products.map((p) => p.category).toSet().length;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText('Product Management',
                  type: TextType.sectionHeading, color: _dark),
              const SizedBox(height: 4),
              AppText(
                '${products.length} products · $categoryCount categories',
                type: TextType.caption,
                color: _dark.withOpacity(0.45),
              ),
            ],
          ),
        ),
        AppButton(
          '+ ADD PRODUCT',
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AdminProductManagementScreen(),
              ),
            );
            // Re-fetch after returning from add screen
            if (mounted) {
              context.read<ProductBloc>().add(const FetchProductsRequested());
            }
          },
          type: ButtonType.primary,
          size: ButtonSize.medium,
          fullWidth: false,
        ),
      ],
    );
  }

  // Search Bar

  Widget _buildSearchBar(List<Products> products) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _border),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, size: 18, color: _olive),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    style: GoogleFonts.dmSans(fontSize: 14, color: _dark),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      hintText: 'Search products...',
                      hintStyle: GoogleFonts.dmSans(
                          fontSize: 14, color: _dark.withOpacity(0.35)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        _filterDropdown(
          value: _selectedCategory,
          items: _categoryOptions(products),
          onChanged: (v) => setState(() => _selectedCategory = v!),
        ),
        const SizedBox(width: 10),
        _filterDropdown(
          value: _selectedStatus,
          items: const ['All Status', 'Active', 'Low stock', 'Out of stock'],
          onChanged: (v) => setState(() => _selectedStatus = v!),
        ),
      ],
    );
  }

  Widget _filterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    // Guard: if current value isn't in the new items list, reset to first item
    final safeValue = items.contains(value) ? value : items.first;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: safeValue,
          items: items
              .map((s) => DropdownMenuItem(
            value: s,
            child: Text(s,
                style:
                GoogleFonts.dmSans(fontSize: 13, color: _dark)),
          ))
              .toList(),
          onChanged: onChanged,
          dropdownColor: _card,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              size: 16, color: _dark),
          style: GoogleFonts.dmSans(fontSize: 13, color: _dark),
        ),
      ),
    );
  }

  // Table Header

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12), topRight: Radius.circular(12),
        ),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          _headerCell('PRODUCT',    flex: 4),
          _headerCell('CATEGORY',   flex: 2),
          _headerCell('COST',       flex: 2),
          _headerCell('SALE',       flex: 2),
          _headerCell('STOCK',      flex: 2),
          _headerCell('STATUS',     flex: 2),
          _headerCell('ACTIONS',    flex: 3),
        ],
      ),
    );
  }
  Widget _headerCell(String label, {required int flex}) {
    return Expanded(
      flex: flex,
      child: AppText(label,
          type: TextType.label,
          color: _dark.withOpacity(0.45),
          letterSpacing: 1.4),
    );
  }

  // Product Row

  Widget _buildProductRow(Products product, bool isLast) {
    final status       = _statusOf(product);
    final isLowStock   = status == 'Low stock';
    final isOutOfStock = status == 'Out of stock';
    final margin       = product.sale_price - product.cost_price;
    final marginPct    = product.cost_price > 0
        ? ((margin / product.cost_price) * 100).toStringAsFixed(0)
        : '0';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: _card,
        border: Border(
          left:   BorderSide(color: _border),
          right:  BorderSide(color: _border),
          bottom: BorderSide(color: _border),
        ),
        borderRadius: isLast
            ? const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12))
            : BorderRadius.zero,
      ),
      child: Row(
        children: [
          // Product
          Expanded(
            flex: 4,
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: product.image_link.isNotEmpty
                      ? Image.network(
                    product.image_link,
                    width: 40, height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _avatar(),
                  )
                      : _avatar(),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(product.productName,
                          type: TextType.productName, color: _dark),
                      AppText(product.subtitle,
                          type: TextType.caption,
                          color: _dark.withOpacity(0.45),
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Category
          Expanded(
            flex: 2,
            child: AppText(product.category,
                type: TextType.bodyText, color: _dark.withOpacity(0.7)),
          ),

          // Cost Price
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  '\$${product.cost_price.toStringAsFixed(2)}',
                  type: TextType.bodyText,
                  color: _dark.withOpacity(0.6),
                ),
                Text(
                  'cost',
                  style: GoogleFonts.dmSans(
                      fontSize: 10,
                      color: _dark.withOpacity(0.3),
                      letterSpacing: 0.5),
                ),
              ],
            ),
          ),

          // Sale Price + margin badge
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  '\$${product.sale_price.toStringAsFixed(2)}',
                  type: TextType.bodyText,
                  color: _dark,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: _olive.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '+$marginPct%',
                    style: GoogleFonts.dmSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: _olive,
                        letterSpacing: 0.3),
                  ),
                ),
              ],
            ),
          ),

          // Stock
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 6, height: 6,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOutOfStock
                        ? AppColors.get(appColors.out_of_stock_text)
                        : isLowStock
                        ? AppColors.get(appColors.low_stock_text)
                        : _olive,
                  ),
                ),
                AppText(
                  product.stock_quantity.toString(),
                  type: TextType.bodyText,
                  color: isOutOfStock
                      ? AppColors.get(appColors.out_of_stock_text)
                      : isLowStock
                      ? AppColors.get(appColors.low_stock_text)
                      : _dark,
                ),
              ],
            ),
          ),

          // Status
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _statusBadge(status),
            ),
          ),
          // Actions
          Expanded(
            flex: 3,
            child: Row(
              children: [
                _actionButton(
                  icon: Icons.edit_rounded,
                  label: 'Edit',
                  color: _dark,
                  onTap: () => _onEditProduct(product),
                ),
                const SizedBox(width: 8),
                _actionButton(
                  icon: Icons.delete_rounded,
                  label: 'Delete',
                  color: AppColors.get(appColors.out_of_stock_text),
                  onTap: () => _onDeleteProduct(product),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionButton({ required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.07),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.15)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: color.withOpacity(0.8)),
              const SizedBox(width: 5),
              Text(
                label,
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color.withOpacity(0.8),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: _dark.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.inventory_2_outlined,
          size: 16, color: _dark.withOpacity(0.3)),
    );
  }

  Widget _statusBadge(String status) {
    Color bg, text;
    if (status == 'Active') {
      bg   = AppColors.get(appColors.active_stock);
      text = AppColors.get(appColors.active_stock_text);
    } else if (status == 'Low stock') {
      bg   = AppColors.get(appColors.low_stock);
      text = AppColors.get(appColors.low_stock_text);
    } else {
      bg   = AppColors.get(appColors.out_of_stock);
      text = AppColors.get(appColors.out_of_stock_text);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(status,
          style: GoogleFonts.dmSans(
              fontSize: 12, fontWeight: FontWeight.w500, color: text)),
    );
  }

  // Empty State

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined,
              size: 48, color: _dark.withOpacity(0.2)),
          const SizedBox(height: 12),
          AppText('No products found',
              type: TextType.bodyText, color: _dark.withOpacity(0.4)),
        ],
      ),
    );
  }

  // Actions

  void _onEditProduct(Products product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AdminProductManagementScreen(existingProduct: product),
      ),
    ).then((_) {
      if (mounted) {
        context.read<ProductBloc>().add(const FetchProductsRequested());
      }
    });
  }

  void _onDeleteProduct(Products product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: _card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text('Delete product?',
            style: GoogleFonts.dmSans(
                fontSize: 16, fontWeight: FontWeight.w600, color: _dark)),
        content: Text(
          'This will permanently delete "${product.productName}". This action cannot be undone.',
          style: GoogleFonts.dmSans(fontSize: 14, color: _dark.withOpacity(0.6)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: GoogleFonts.dmSans(color: _dark.withOpacity(0.5))),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              context
                  .read<ProductBloc>()
                  .add(DeleteProductRequested(product.productId));
            },
            child: Text('Delete',
                style: GoogleFonts.dmSans(
                    color: AppColors.get(appColors.out_of_stock_text),
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}