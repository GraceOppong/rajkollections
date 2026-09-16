import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/workspace_bottom_nav.dart';
import 'dispatch_order_screen.dart';
import 'order_models.dart';

class PickPackScreen extends StatefulWidget {
  const PickPackScreen({super.key, required this.order});

  final StoreOrder order;

  @override
  State<PickPackScreen> createState() => _PickPackScreenState();
}

class _PickPackScreenState extends State<PickPackScreen> {
  late final List<bool> _picked;

  StoreOrder get order => widget.order;

  @override
  void initState() {
    super.initState();
    final count = order.items.length;
    _picked = [
      for (var i = 0; i < count; i++) i < count - 1,
    ];
  }

  int get _pickedCount => _picked.where((v) => v).length;

  int get _totalCount => order.itemCount;

  double get _progress => _totalCount == 0 ? 0 : _pickedCount / _totalCount;

  bool get _allPicked => _picked.isNotEmpty && _picked.every((v) => v);

  void _toggle(int index) {
    setState(() => _picked[index] = !_picked[index]);
  }

  void _openDispatch() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DispatchOrderScreen(order: order),
      ),
    );
  }

  void _scanNext() {
    final index = _picked.indexWhere((v) => !v);
    if (index < 0) return;
    setState(() => _picked[index] = true);
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final maxWidth = contentMaxWidth(context);
    final horizontal = tablet ? 32.0 : 20.0;
    final percent = (_progress * 100).round();

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
                  padding: EdgeInsets.fromLTRB(horizontal - 8, 2, horizontal, 0),
                  child: _Header(onScan: _scanNext),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(horizontal, 6, horizontal, 12),
                    children: [
                      _OrderCard(order: order),
                      const SizedBox(height: 8),
                      _ProgressCard(
                        picked: _pickedCount,
                        total: _totalCount,
                        percent: percent,
                        progress: _progress,
                      ),
                      const SizedBox(height: 8),
                      _ItemsCard(
                        items: order.items,
                        picked: _picked,
                        onToggle: _toggle,
                      ),
                      const SizedBox(height: 8),
                      _ScanBar(onTap: _scanNext),
                      const SizedBox(height: 8),
                      const _HintBanner(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontal, 6, horizontal, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.inventory_2_outlined,
                          label: 'Mark as Packed',
                          filled: true,
                          onTap: _openDispatch,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _ActionButton(
                          icon: Icons.check_circle_outline,
                          label: 'Complete Picking',
                          filled: false,
                          enabled: _allPicked,
                          onTap: _allPicked ? _openDispatch : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: WorkspaceBottomNav(
        currentIndex: 1,
        onTap: (index) {
          if (index != 1) Navigator.of(context).pop();
        },
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onScan});

  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.fromLTRB(4, 6, 8, 6),
            child: Icon(Icons.chevron_left, size: 24, color: AppColors.coffee),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Pick & Pack',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              Text(
                'Scan and pick items to fulfil this order.',
                textAlign: TextAlign.center,
                style: AppTypography.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Material(
          color: AppColors.card,
          shape: StadiumBorder(
            side: BorderSide(color: AppColors.sand.withValues(alpha: 0.55)),
          ),
          child: InkWell(
            onTap: onScan,
            customBorder: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 12, 6),
              child: Row(
                children: [
                  const Icon(Icons.qr_code_scanner, size: 14, color: AppColors.coffee),
                  const SizedBox(width: 5),
                  Text(
                    'Scan Item',
                    style: AppTypography.inter(
                      fontSize: 11,
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

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final StoreOrder order;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #${order.id}',
                    style: AppTypography.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coffee,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  decoration: BoxDecoration(
                    color: AppColors.priorityBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 12, color: Color(0xFF5B8FB8)),
                      const SizedBox(width: 4),
                      Text(
                        'Picking',
                        style: AppTypography.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF5B8FB8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        _MetaRow(icon: Icons.person_outline, text: order.customer),
                        const SizedBox(height: 5),
                        _MetaRow(icon: Icons.phone_outlined, text: order.phone),
                        const SizedBox(height: 5),
                        _MetaRow(
                          icon: Icons.location_on_outlined,
                          text: '${order.addressLines.first}, ${order.addressLines.length > 1 ? order.addressLines[1] : ''}\n${order.addressLines.last}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    child: VerticalDivider(
                      width: 1,
                      thickness: 1,
                      color: AppColors.sand.withValues(alpha: 0.35),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _MetaRow(icon: Icons.calendar_today_outlined, text: order.placedAt),
                        const SizedBox(height: 5),
                        _MetaRow(
                          icon: Icons.inventory_2_outlined,
                          text: '${order.itemCount} item${order.itemCount == 1 ? '' : 's'}',
                        ),
                        const SizedBox(height: 5),
                        const _MetaRow(
                          icon: Icons.local_shipping_outlined,
                          text: 'Standard Delivery',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: AppColors.bronze),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: AppTypography.inter(
              fontSize: 11,
              color: AppColors.coffee,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({
    required this.picked,
    required this.total,
    required this.percent,
    required this.progress,
  });

  final int picked;
  final int total;
  final int percent;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Pick Progress',
                  style: AppTypography.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coffee,
                  ),
                ),
                const Spacer(),
                Text(
                  '$picked of $total items picked',
                  style: AppTypography.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: AppColors.creamDark,
                      color: AppColors.bronze,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$percent%',
                  style: AppTypography.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
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

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({
    required this.items,
    required this.picked,
    required this.onToggle,
  });

  final List<OrderLineItem> items;
  final List<bool> picked;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Items to Pick (${items.length})',
              style: AppTypography.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.coffee,
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < items.length; i++) ...[
              _PickRow(
                item: items[i],
                picked: picked[i],
                onTap: () => onToggle(i),
              ),
              if (i != items.length - 1)
                Divider(height: 22, color: AppColors.sand.withValues(alpha: 0.28)),
            ],
          ],
        ),
      ),
    );
  }
}

class _PickRow extends StatelessWidget {
  const _PickRow({
    required this.item,
    required this.picked,
    required this.onTap,
  });

  final OrderLineItem item;
  final bool picked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(item.image, width: 58, height: 58, fit: BoxFit.cover),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                style: AppTypography.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              Text(
                'SKU: ${item.sku}',
                style: AppTypography.inter(fontSize: 10, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 12, color: AppColors.bronze),
                  const SizedBox(width: 3),
                  Text(
                    'Location: ${item.location}',
                    style: AppTypography.inter(fontSize: 10, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Qty: ${item.qty}',
              style: AppTypography.inter(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Material(
              color: picked ? const Color(0xFFE3F0E6) : Colors.transparent,
              shape: StadiumBorder(
                side: BorderSide(
                  color: picked ? const Color(0xFF4C9A62) : AppColors.sand,
                ),
              ),
              child: InkWell(
                onTap: onTap,
                customBorder: const StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: Row(
                    children: [
                      Icon(
                        picked ? Icons.check_circle : Icons.circle_outlined,
                        size: 13,
                        color: picked ? const Color(0xFF4C9A62) : AppColors.sand,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        picked ? 'Picked' : 'Not Picked',
                        style: AppTypography.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: picked ? const Color(0xFF4C9A62) : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
    );
  }
}

class _ScanBar extends StatelessWidget {
  const _ScanBar({required this.onTap});

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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              const Icon(Icons.qr_code_scanner, size: 18, color: AppColors.coffee),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Scan barcode to pick item',
                  style: AppTypography.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coffee,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HintBanner extends StatelessWidget {
  const _HintBanner();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.creamDark.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.28)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Row(
          children: [
            const Icon(Icons.info_outline, size: 14, color: AppColors.bronze),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Scan the product barcode to confirm and pick the item.',
                style: AppTypography.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.filled,
    this.enabled = true,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = filled ? AppColors.bronze : AppColors.card;
    final fg = !enabled
        ? AppColors.sand
        : filled
            ? Colors.white
            : AppColors.coffee;
    return Material(
      color: enabled ? color : AppColors.creamDark.withValues(alpha: 0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: enabled
              ? (filled ? AppColors.bronze : AppColors.sand.withValues(alpha: 0.55))
              : AppColors.sand.withValues(alpha: 0.4),
        ),
      ),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: fg),
              const SizedBox(width: 5),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: AppTypography.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: fg,
                    ),
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
