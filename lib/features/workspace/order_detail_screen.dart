import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/workspace_bottom_nav.dart';
import 'order_models.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key, required this.order});

  final StoreOrder order;

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  late String? _notes = widget.order.notes;

  StoreOrder get order => widget.order;

  Future<void> _openNoteBox() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) => _NoteSheet(initial: _notes),
    );
    if (result == null || !mounted) return;
    setState(() => _notes = result.isEmpty ? null : result);
  }

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
                  child: _Header(onBack: () => Navigator.of(context).pop()),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(horizontal, 2, horizontal, 8),
                    children: [
                      _OrderHero(order: order),
                      const SizedBox(height: 6),
                      _ItemsCard(order: order),
                      const SizedBox(height: 6),
                      _SummaryCard(order: order),
                      const SizedBox(height: 6),
                      _StatusCard(order: order),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontal, 6, horizontal, 8),
                  child: Column(
                    children: [
                      _NotesCard(notes: _notes, onAddNote: _openNoteBox),
                      const SizedBox(height: 6),
                      _ActionBar(order: order),
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
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
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
                'Order Details',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              Text(
                'View order information and update status.',
                style: AppTypography.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.more_horiz, size: 22, color: AppColors.coffee),
        ),
      ],
    );
  }
}

class _OrderHero extends StatelessWidget {
  const _OrderHero({required this.order});

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
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Order #${order.id}',
                          style: AppTypography.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.coffee,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => Clipboard.setData(ClipboardData(text: order.id)),
                        child: Icon(
                          Icons.copy_outlined,
                          size: 13,
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: order.status),
              ],
            ),
            const SizedBox(height: 1),
            Text(
              order.placedAt,
              style: AppTypography.inter(
                fontSize: 10,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.creamDark,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      order.initials,
                      style: AppTypography.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffee,
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.customer,
                          style: AppTypography.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.coffee,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          order.phone,
                          style: AppTypography.inter(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          order.email,
                          style: AppTypography.inter(
                            fontSize: 10,
                            color: AppColors.textSecondary,
                          ),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 13, color: AppColors.bronze),
                            const SizedBox(width: 3),
                            Text(
                              order.addressTitle,
                              style: AppTypography.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.coffee,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        for (final line in order.addressLines)
                          Text(
                            line,
                            style: AppTypography.inter(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              height: 1.25,
                            ),
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

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.order});

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
          children: [
            Row(
              children: [
                Text(
                  'Items (${order.itemCount})',
                  style: AppTypography.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coffee,
                  ),
                ),
                const Spacer(),
                Text(
                  'View All  →',
                  style: AppTypography.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.bronze,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < order.items.length; i++) ...[
              _ItemRow(item: order.items[i]),
              if (i != order.items.length - 1)
                Divider(height: 14, color: AppColors.sand.withValues(alpha: 0.28)),
            ],
          ],
        ),
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final OrderLineItem item;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child:             Image.asset(
              item.image,
              width: 46,
              height: 46,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coffee,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'SKU: ${item.sku}',
                  style: AppTypography.inter(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.unitPriceLabel,
                  style: AppTypography.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.coffee,
                  ),
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
              const Spacer(),
              Text(
                item.lineTotalLabel,
                style: AppTypography.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.order});

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
            Text(
              'Order Summary',
              style: AppTypography.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.coffee,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _SummaryLine(
                        icon: Icons.inventory_2_outlined,
                        label: 'Subtotal',
                        value: order.subtotalLabel,
                      ),
                      const SizedBox(height: 8),
                      _SummaryLine(
                        icon: Icons.local_shipping_outlined,
                        label: 'Delivery Fee',
                        value: order.deliveryLabel,
                      ),
                      const SizedBox(height: 8),
                      _SummaryLine(
                        icon: Icons.percent,
                        label: 'Discount',
                        value: order.discountLabel,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            'Total',
                            style: AppTypography.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.coffee,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            order.totalLabel,
                            style: AppTypography.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.coffee,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 132,
                  child: Column(
                    children: [
                      _PaymentTile(
                        icon: Icons.account_balance_wallet_outlined,
                        label: 'Payment Method',
                        value: order.paymentMethod,
                      ),
                      const SizedBox(height: 8),
                      _PaymentTile(
                        icon: Icons.credit_card_outlined,
                        label: 'Payment Status',
                        value: order.paymentStatus,
                        paid: order.paymentPaid,
                      ),
                    ],
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

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.bronze),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.inter(
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: AppTypography.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.coffee,
          ),
        ),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  const _PaymentTile({
    required this.icon,
    required this.label,
    required this.value,
    this.paid,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool? paid;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.cream.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 14, color: AppColors.bronze),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.inter(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  if (paid == null)
                    Text(
                      value,
                      style: AppTypography.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffee,
                      ),
                    )
                  else
                    Row(
                      children: [
                        Icon(
                          paid! ? Icons.check_circle : Icons.cancel,
                          size: 12,
                          color: paid! ? const Color(0xFF4C9A62) : AppColors.alertRoseIcon,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          value,
                          style: AppTypography.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: paid! ? const Color(0xFF4C9A62) : AppColors.alertRoseIcon,
                          ),
                        ),
                      ],
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

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.order});

  final StoreOrder order;

  @override
  Widget build(BuildContext context) {
    const steps = [
      (Icons.description_outlined, 'Pending'),
      (Icons.inventory_2_outlined, 'Packing'),
      (Icons.local_shipping_outlined, 'Shipped'),
      (Icons.check_circle_outline, 'Delivered'),
    ];
    final active = order.status == OrderStatus.cancelled ? -1 : order.status.stepIndex;
    final times = [
      order.pendingAt,
      order.packingAt,
      order.shippedAt,
      order.deliveredAt,
    ];

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
            Text(
              'Order Status',
              style: AppTypography.inter(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.coffee,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 28,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Row(
                      children: [
                        for (var i = 0; i < steps.length - 1; i++)
                          Expanded(
                            child: Container(
                              height: 1.5,
                              color: i < active
                                  ? AppColors.bronze
                                  : AppColors.sand.withValues(alpha: 0.55),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < steps.length; i++)
                        Expanded(
                          child: Center(
                            child: Container(
                              width: 28,
                              height: 28,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: i <= active ? AppColors.bronze : AppColors.creamDark,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: i <= active ? AppColors.bronze : AppColors.sand,
                                ),
                              ),
                              child: Icon(
                                i < active ? Icons.check : steps[i].$1,
                                size: 14,
                                color: i <= active ? Colors.white : AppColors.sand,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (var i = 0; i < steps.length; i++)
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          steps[i].$2,
                          textAlign: TextAlign.center,
                          style: AppTypography.inter(
                            fontSize: 10,
                            fontWeight: i == active ? FontWeight.w700 : FontWeight.w500,
                            color: i <= active ? AppColors.coffee : AppColors.textSecondary,
                          ),
                        ),
                        if (times[i] != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            times[i]!,
                            textAlign: TextAlign.center,
                            style: AppTypography.inter(
                              fontSize: 9,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
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

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.notes, required this.onAddNote});

  final String? notes;
  final VoidCallback onAddNote;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.22)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
        child: Row(
          children: [
            const Icon(Icons.description_outlined, size: 16, color: AppColors.bronze),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notes',
                    style: AppTypography.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coffee,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    notes ?? 'No notes yet.',
                    style: AppTypography.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.white.withValues(alpha: 0.7),
              shape: StadiumBorder(
                side: BorderSide(color: AppColors.sand.withValues(alpha: 0.45)),
              ),
              child: InkWell(
                onTap: onAddNote,
                customBorder: const StadiumBorder(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.add, size: 13, color: AppColors.coffee),
                      const SizedBox(width: 4),
                      Text(
                        'Add Note',
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
        ),
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.order});

  final StoreOrder order;

  @override
  Widget build(BuildContext context) {
    final next = order.status.nextAction;
    final showCancel = order.status != OrderStatus.cancelled &&
        order.status != OrderStatus.delivered;
    return Row(
      children: [
        if (showCancel)
          Expanded(
            flex: 4,
            child: _OutlineButton(
              icon: Icons.close,
              label: 'Cancel Order',
              onTap: () {},
            ),
          ),
        if (showCancel) const SizedBox(width: 6),
        Expanded(
          flex: 3,
          child: _OutlineButton(
            icon: Icons.print_outlined,
            label: 'Print',
            onTap: () {},
          ),
        ),
        if (next != null) ...[
          const SizedBox(width: 6),
          Expanded(
            flex: 5,
            child: Material(
              color: AppColors.bronze,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(order.status.nextActionIcon, size: 13, color: Colors.white),
                      const SizedBox(width: 4),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            next,
                            maxLines: 1,
                            style: AppTypography.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
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
        side: BorderSide(color: AppColors.sand.withValues(alpha: 0.55)),
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
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: AppTypography.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(7, 3, 8, 3),
      decoration: BoxDecoration(
        color: status.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: status.dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            status.label,
            style: AppTypography.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: status.fg,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteSheet extends StatefulWidget {
  const _NoteSheet({this.initial});

  final String? initial;

  @override
  State<_NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends State<_NoteSheet> {
  late final _controller = TextEditingController(text: widget.initial ?? '');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final inset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 16 + inset),
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
            'Add Note',
            style: AppTypography.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.coffee,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'This note is saved on the order.',
            style: AppTypography.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            minLines: 4,
            maxLines: 6,
            style: AppTypography.inter(fontSize: 13, color: AppColors.coffee),
            cursorColor: AppColors.bronze,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              hintText: 'Write a note for this order...',
              hintStyle: AppTypography.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              filled: true,
              fillColor: AppColors.card,
              contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.sand.withValues(alpha: 0.4)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.sand.withValues(alpha: 0.4)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.bronze),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Material(
                  color: AppColors.card,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.sand.withValues(alpha: 0.55)),
                  ),
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Cancel',
                        textAlign: TextAlign.center,
                        style: AppTypography.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.coffee,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Material(
                  color: AppColors.bronze,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: _save,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Save Note',
                        textAlign: TextAlign.center,
                        style: AppTypography.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
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
