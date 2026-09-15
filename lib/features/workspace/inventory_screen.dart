import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

enum _StockFilter { all, inStock, lowStock, outOfStock }

enum _StockStatus { inStock, lowStock, outOfStock }

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final _query = TextEditingController();
  var _filter = _StockFilter.all;
  var _showBanner = true;

  static const _items = <_Product>[
    _Product(
      name: 'Wireless Earbuds',
      sku: 'WE-BLK',
      category: 'Electronics',
      image: 'assets/images/inv_earbuds.jpg',
      status: _StockStatus.outOfStock,
      units: 0,
    ),
    _Product(
      name: 'Classic T-Shirt',
      sku: 'TS-WHT-L',
      category: 'Apparel',
      image: 'assets/images/inv_tshirt.jpg',
      status: _StockStatus.inStock,
      units: 120,
    ),
    _Product(
      name: 'Travel Backpack',
      sku: 'TB-BLK',
      category: 'Bags',
      image: 'assets/images/inv_backpack.jpg',
      status: _StockStatus.lowStock,
      units: 5,
    ),
    _Product(
      name: 'Yoga Mat',
      sku: 'YM-GRY',
      category: 'Fitness',
      image: 'assets/images/inv_yoga_mat.jpg',
      status: _StockStatus.inStock,
      units: 45,
    ),
    _Product(
      name: 'Water Bottle',
      sku: 'WB-SLV',
      category: 'Accessories',
      image: 'assets/images/inv_bottle.jpg',
      status: _StockStatus.inStock,
      units: 200,
    ),
    _Product(
      name: 'Baseball Cap',
      sku: 'BC-BLK',
      category: 'Apparel',
      image: 'assets/images/inv_cap.jpg',
      status: _StockStatus.lowStock,
      units: 8,
    ),
  ];

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<_Product> get _visible {
    final q = _query.text.trim().toLowerCase();
    return _items.where((item) {
      final matchesFilter = switch (_filter) {
        _StockFilter.all => true,
        _StockFilter.inStock => item.status == _StockStatus.inStock,
        _StockFilter.lowStock => item.status == _StockStatus.lowStock,
        _StockFilter.outOfStock => item.status == _StockStatus.outOfStock,
      };
      if (!matchesFilter) return false;
      if (q.isEmpty) return true;
      return item.name.toLowerCase().contains(q) ||
          item.sku.toLowerCase().contains(q) ||
          item.category.toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final horizontal = tablet ? 32.0 : 20.0;
    final visible = _visible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(horizontal, 4, horizontal, 0),
          child: const _InventoryHeader(),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontal),
          child: _SearchRow(
            controller: _query,
            onChanged: (_) => setState(() {}),
            onFilter: () => _openFilterSheet(context),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.only(left: horizontal),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _StockChip(
                  label: 'All',
                  count: 124,
                  selected: _filter == _StockFilter.all,
                  onTap: () => setState(() => _filter = _StockFilter.all),
                ),
                const SizedBox(width: 5),
                _StockChip(
                  label: 'In Stock',
                  count: 98,
                  selected: _filter == _StockFilter.inStock,
                  onTap: () => setState(() => _filter = _StockFilter.inStock),
                ),
                const SizedBox(width: 5),
                _StockChip(
                  label: 'Low Stock',
                  count: 18,
                  selected: _filter == _StockFilter.lowStock,
                  onTap: () => setState(() => _filter = _StockFilter.lowStock),
                ),
                const SizedBox(width: 5),
                _StockChip(
                  label: 'Out of Stock',
                  count: 6,
                  selected: _filter == _StockFilter.outOfStock,
                  onTap: () => setState(() => _filter = _StockFilter.outOfStock),
                ),
                SizedBox(width: horizontal),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 12),
            children: [
              if (visible.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 36),
                  child: Text(
                    'No products match this search.',
                    textAlign: TextAlign.center,
                    style: AppTypography.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              else
                for (var i = 0; i < visible.length; i++) ...[
                  _ProductRow(product: visible[i]),
                  if (i != visible.length - 1) const SizedBox(height: 6),
                ],
            ],
          ),
        ),
        if (_showBanner)
          Padding(
            padding: EdgeInsets.fromLTRB(horizontal, 4, horizontal, 10),
            child: _InventoryBanner(onClose: () => setState(() => _showBanner = false)),
          ),
      ],
    );
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.sand,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Filter',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Stock status',
                style: AppTypography.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.coffeeMuted,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  _StockChip(
                    label: 'All',
                    count: 124,
                    selected: _filter == _StockFilter.all,
                    onTap: () {
                      setState(() => _filter = _StockFilter.all);
                      Navigator.pop(context);
                    },
                  ),
                  _StockChip(
                    label: 'In Stock',
                    count: 98,
                    selected: _filter == _StockFilter.inStock,
                    onTap: () {
                      setState(() => _filter = _StockFilter.inStock);
                      Navigator.pop(context);
                    },
                  ),
                  _StockChip(
                    label: 'Low Stock',
                    count: 18,
                    selected: _filter == _StockFilter.lowStock,
                    onTap: () {
                      setState(() => _filter = _StockFilter.lowStock);
                      Navigator.pop(context);
                    },
                  ),
                  _StockChip(
                    label: 'Out of Stock',
                    count: 6,
                    selected: _filter == _StockFilter.outOfStock,
                    onTap: () {
                      setState(() => _filter = _StockFilter.outOfStock);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InventoryHeader extends StatelessWidget {
  const _InventoryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Inventory',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Manage your products and stock levels.',
                style: AppTypography.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Material(
          color: AppColors.bronze,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 12, 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    'Add Product',
                    style: AppTypography.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow({
    required this.controller,
    required this.onChanged,
    required this.onFilter,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: AppTypography.inter(fontSize: 12, color: AppColors.coffee),
            cursorColor: AppColors.bronze,
            decoration: InputDecoration(
              isDense: true,
              hintText: 'Search products, SKU or category...',
              hintStyle: AppTypography.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.coffeeMuted),
              prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.55),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: AppColors.sand.withValues(alpha: 0.4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: BorderSide(color: AppColors.sand.withValues(alpha: 0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22),
                borderSide: const BorderSide(color: AppColors.bronze),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.white.withValues(alpha: 0.55),
          shape: StadiumBorder(
            side: BorderSide(color: AppColors.sand.withValues(alpha: 0.45)),
          ),
          child: InkWell(
            onTap: onFilter,
            customBorder: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.filter_alt_outlined, size: 15, color: AppColors.coffee),
                  const SizedBox(width: 4),
                  Text(
                    'Filter',
                    style: AppTypography.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StockChip extends StatelessWidget {
  const _StockChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.bronze : AppColors.creamDark.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 4, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.coffeeMuted,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                constraints: const BoxConstraints(minWidth: 18, minHeight: 16),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? const Color(0xFF6B5136)
                      : Colors.white.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  '$count',
                  style: AppTypography.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.coffeeMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({required this.product});

  final _Product product;

  @override
  Widget build(BuildContext context) {
    final showUnits = product.status != _StockStatus.outOfStock;

    return Material(
      color: AppColors.card,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.sand.withValues(alpha: 0.22)),
      ),
      child: InkWell(
        onTap: () {},
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 68,
                child: Image.asset(
                  product.image,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 4, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              product.name,
                              style: AppTypography.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.coffee,
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Icon(Icons.more_vert, size: 16, color: AppColors.coffeeMuted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SKU: ${product.sku}  ·  ${product.category}',
                        style: AppTypography.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _StatusChip(status: product.status),
                          const Spacer(),
                          if (showUnits) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${product.units}',
                                  style: AppTypography.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.coffee,
                                  ),
                                ),
                                Text(
                                  'units',
                                  style: AppTypography.inter(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 4),
                          ],
                          Icon(
                            Icons.chevron_right,
                            size: 16,
                            color: AppColors.textSecondary.withValues(alpha: 0.7),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final _StockStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg, dot) = switch (status) {
      _StockStatus.inStock => (
          'In stock',
          const Color(0xFFE3F0E6),
          const Color(0xFF4C9A62),
          const Color(0xFF4C9A62),
        ),
      _StockStatus.lowStock => (
          'Low stock',
          AppColors.alertAmber,
          AppColors.alertAmberIcon,
          const Color(0xFFE8A23A),
        ),
      _StockStatus.outOfStock => (
          'Out of stock',
          AppColors.alertRose,
          AppColors.alertRoseIcon,
          const Color(0xFFE05252),
        ),
    };

    return Container(
      padding: const EdgeInsets.fromLTRB(7, 3, 8, 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTypography.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryBanner extends StatelessWidget {
  const _InventoryBanner({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.creamDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: const BoxDecoration(
                color: AppColors.cream,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.inventory_2_outlined, size: 13, color: AppColors.bronze),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keep your inventory up to date',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coffee,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'Accurate stock helps you fulfill orders faster.',
                    maxLines: 2,
                    style: AppTypography.inter(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Material(
              color: Colors.white.withValues(alpha: 0.7),
              shape: const StadiumBorder(),
              child: InkWell(
                onTap: () {},
                customBorder: const StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  child: Text(
                    'Learn more',
                    style: AppTypography.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: onClose,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
              icon: const Icon(Icons.close, size: 16, color: AppColors.coffeeMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _Product {
  const _Product({
    required this.name,
    required this.sku,
    required this.category,
    required this.image,
    required this.status,
    required this.units,
  });

  final String name;
  final String sku;
  final String category;
  final String image;
  final _StockStatus status;
  final int units;
}
