import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/workspace_bottom_nav.dart';
import 'inventory_product.dart';

enum _DetailTab { overview, history, details }

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final InventoryProduct product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  var _tab = _DetailTab.overview;

  InventoryProduct get product => widget.product;

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final maxWidth = contentMaxWidth(context);
    final horizontal = tablet ? 32.0 : 20.0;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontal - 8, 2, horizontal - 8, 0),
                  child: _DetailHeader(onBack: () => Navigator.of(context).pop()),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(horizontal, 4, horizontal, 20),
                    children: [
                      _HeroBlock(product: product),
                      const SizedBox(height: 12),
                      _CurrentStockCard(product: product),
                      const SizedBox(height: 10),
                      _StatsRow(product: product),
                      const SizedBox(height: 12),
                      const _ActionRow(),
                      const SizedBox(height: 14),
                      _TabBar(
                        tab: _tab,
                        onChanged: (tab) => setState(() => _tab = tab),
                      ),
                      const SizedBox(height: 10),
                      ...switch (_tab) {
                        _DetailTab.overview => [
                            _ProductInfoCard(product: product),
                            const SizedBox(height: 10),
                            _ActivityCard(product: product),
                          ],
                        _DetailTab.history => [
                            _HistoryCard(product: product),
                          ],
                        _DetailTab.details => [
                            _ExtraDetailsCard(product: product),
                          ],
                      },
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: WorkspaceBottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index != 2) Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 6, 8, 6),
            child: Row(
              children: [
                const Icon(Icons.chevron_left, size: 24, color: AppColors.coffee),
                Text(
                  'Back',
                  style: AppTypography.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.coffee,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          icon: const Icon(Icons.more_horiz, size: 22, color: AppColors.coffee),
        ),
      ],
    );
  }
}

class _HeroBlock extends StatelessWidget {
  const _HeroBlock({required this.product});

  final InventoryProduct product;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Hero(
                tag: 'inv-${product.sku}',
                child: Material(
                  color: Colors.transparent,
                  child: Image.asset(
                    product.image,
                    width: 108,
                    height: 108,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 6,
              top: 6,
              child: _StatusChip(status: product.status, compact: true),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.category,
                style: AppTypography.inter(
                  fontSize: 10,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                product.name,
                style: AppTypography.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      'SKU: ${product.sku}',
                      style: AppTypography.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: () => Clipboard.setData(ClipboardData(text: product.sku)),
                    child: Icon(
                      Icons.copy_outlined,
                      size: 12,
                      color: AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                product.description,
                style: AppTypography.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: [
                  for (final tag in product.tags) _TagChip(label: tag),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: AppTypography.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.coffeeMuted,
        ),
      ),
    );
  }
}

class _CurrentStockCard extends StatelessWidget {
  const _CurrentStockCard({required this.product});

  final InventoryProduct product;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: product.status.bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inventory_2_outlined, size: 16, color: product.status.fg),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Stock',
                  style: AppTypography.inter(
                    fontSize: 11,
                    color: AppColors.coffeeMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${product.units}',
                      style: AppTypography.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: product.status.fg,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        'units',
                        style: AppTypography.inter(
                          fontSize: 11,
                          color: AppColors.coffeeMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusChip(status: product.status, onTinted: true),
                const SizedBox(height: 6),
                Text(
                  product.status.hint,
                  style: AppTypography.inter(
                    fontSize: 10,
                    color: AppColors.coffeeMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.product});

  final InventoryProduct product;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCell(
            icon: Icons.inventory_2_outlined,
            label: 'Reorder Level',
            value: '${product.reorderLevel} units',
          ),
        ),
        const _StatDivider(),
        Expanded(
          child: _StatCell(
            icon: Icons.local_shipping_outlined,
            label: 'Units on Order',
            value: '${product.unitsOnOrder} units',
          ),
        ),
        const _StatDivider(),
        Expanded(
          child: _StatCell(
            icon: Icons.sell_outlined,
            label: 'Unit Price',
            value: product.unitPriceLabel,
          ),
        ),
        const _StatDivider(),
        Expanded(
          child: _StatCell(
            icon: Icons.bar_chart_outlined,
            label: 'Total Value',
            value: product.totalValueLabel,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      color: AppColors.sand.withValues(alpha: 0.45),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 16, color: AppColors.bronze),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppTypography.inter(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppTypography.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.coffee,
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Material(
            color: AppColors.bronze,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.add, size: 15, color: Colors.white),
                    const SizedBox(width: 4),
                    Text(
                      'Adjust Stock',
                      style: AppTypography.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: 4,
          child: _OutlineAction(
            icon: Icons.shopping_cart_outlined,
            label: 'Create Order',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          flex: 4,
          child: _OutlineAction(
            icon: Icons.qr_code_scanner,
            label: 'Scan Item',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _OutlineAction extends StatelessWidget {
  const _OutlineAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.sand.withValues(alpha: 0.45)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: AppColors.coffee),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coffee,
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

class _TabBar extends StatelessWidget {
  const _TabBar({required this.tab, required this.onChanged});

  final _DetailTab tab;
  final ValueChanged<_DetailTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabItem(
          label: 'Overview',
          selected: tab == _DetailTab.overview,
          onTap: () => onChanged(_DetailTab.overview),
        ),
        _TabItem(
          label: 'Stock History',
          selected: tab == _DetailTab.history,
          onTap: () => onChanged(_DetailTab.history),
        ),
        _TabItem(
          label: 'Details',
          selected: tab == _DetailTab.details,
          onTap: () => onChanged(_DetailTab.details),
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text(
                label,
                style: AppTypography.inter(
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppColors.coffee : AppColors.textSecondary,
                ),
              ),
            ),
            Container(
              height: 2,
              color: selected ? AppColors.coffee : AppColors.sand.withValues(alpha: 0.35),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductInfoCard extends StatelessWidget {
  const _ProductInfoCard({required this.product});

  final InventoryProduct product;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.description_outlined,
      title: 'Product Information',
      compact: true,
      child: Column(
        children: [
          _InfoRow(label: 'SKU', value: product.sku, copyValue: product.sku, dense: true),
          const _FaintDivider(dense: true),
          _InfoRow(label: 'Category', value: product.category, dense: true),
          const _FaintDivider(dense: true),
          _InfoRow(label: 'Brand', value: product.brand, dense: true),
          const _FaintDivider(dense: true),
          _InfoRow(label: 'Barcode', value: product.barcode, copyValue: product.barcode, dense: true),
          const _FaintDivider(dense: true),
          _InfoRow(label: 'Added on', value: product.addedOn, dense: true),
          const _FaintDivider(dense: true),
          _InfoRow(label: 'Last updated', value: product.lastUpdated, dense: true),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.product});

  final InventoryProduct product;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.schedule_outlined,
      title: 'Recent Activity',
      compact: true,
      trailing: Text(
        'View all  →',
        style: AppTypography.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.bronze,
        ),
      ),
      child: Column(
        children: [
          for (var i = 0; i < product.activity.length; i++) ...[
            _ActivityRow(item: product.activity[i], dense: true),
            if (i != product.activity.length - 1) const _FaintDivider(dense: true),
          ],
        ],
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.product});

  final InventoryProduct product;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.history,
      title: 'Stock History',
      child: Column(
        children: [
          for (var i = 0; i < product.activity.length; i++) ...[
            _ActivityRow(item: product.activity[i]),
            if (i != product.activity.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _ExtraDetailsCard extends StatelessWidget {
  const _ExtraDetailsCard({required this.product});

  final InventoryProduct product;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      icon: Icons.info_outline,
      title: 'Warehouse Details',
      child: Column(
        children: [
          _InfoRow(label: 'Warehouse', value: product.warehouse),
          _InfoRow(label: 'Shelf', value: product.shelf),
          _InfoRow(label: 'Supplier', value: product.supplier, last: true),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Widget? trailing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: compact
            ? const EdgeInsets.fromLTRB(10, 8, 10, 8)
            : const EdgeInsets.fromLTRB(12, 12, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: compact ? 14 : 15, color: AppColors.bronze),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    title,
                    style: AppTypography.inter(
                      fontSize: compact ? 11 : 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coffee,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            SizedBox(height: compact ? 6 : 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _FaintDivider extends StatelessWidget {
  const _FaintDivider({this.dense = false});

  final bool dense;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: dense ? 8 : 14,
      thickness: 1,
      color: AppColors.sand.withValues(alpha: 0.28),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.copyValue,
    this.last = false,
    this.dense = false,
  });

  final String label;
  final String value;
  final String? copyValue;
  final bool last;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final size = dense ? 10.0 : 11.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dense ? 0 : 2),
      child: Row(
        children: [
          SizedBox(
            width: dense ? 84 : 92,
            child: Text(
              label,
              style: AppTypography.inter(
                fontSize: size,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.inter(
                fontSize: size,
                fontWeight: FontWeight.w600,
                color: AppColors.coffee,
              ),
            ),
          ),
          if (copyValue != null)
            GestureDetector(
              onTap: () => Clipboard.setData(ClipboardData(text: copyValue!)),
              child: Icon(
                Icons.copy_outlined,
                size: dense ? 11 : 13,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item, this.dense = false});

  final InventoryActivity item;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final iconSize = dense ? 24.0 : 28.0;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: dense ? 1 : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(color: item.bg, shape: BoxShape.circle),
            child: Icon(item.icon, size: dense ? 12 : 14, color: item.fg),
          ),
          SizedBox(width: dense ? 6 : 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.inter(
                    fontSize: dense ? 11 : 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coffee,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: AppTypography.inter(
                    fontSize: dense ? 10 : 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            item.time,
            style: AppTypography.inter(
              fontSize: dense ? 9 : 10,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
    this.compact = false,
    this.onTinted = false,
  });

  final StockStatus status;
  final bool compact;
  final bool onTinted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: compact
          ? const EdgeInsets.fromLTRB(5, 2, 6, 2)
          : const EdgeInsets.fromLTRB(7, 3, 8, 3),
      decoration: BoxDecoration(
        color: onTinted ? Colors.white.withValues(alpha: 0.88) : status.bg,
        borderRadius: BorderRadius.circular(compact ? 10 : 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 4 : 6,
            height: compact ? 4 : 6,
            decoration: BoxDecoration(color: status.dot, shape: BoxShape.circle),
          ),
          SizedBox(width: compact ? 4 : 5),
          Text(
            status.label,
            style: AppTypography.inter(
              fontSize: compact ? 8 : 10,
              fontWeight: FontWeight.w600,
              color: status.fg,
            ),
          ),
        ],
      ),
    );
  }
}
