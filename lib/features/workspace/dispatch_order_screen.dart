import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/workspace_bottom_nav.dart';
import 'order_models.dart';

class DispatchOrderScreen extends StatefulWidget {
  const DispatchOrderScreen({super.key, required this.order});

  final StoreOrder order;

  @override
  State<DispatchOrderScreen> createState() => _DispatchOrderScreenState();
}

class _DispatchOrderScreenState extends State<DispatchOrderScreen> {
  final _notes = TextEditingController();
  final _tracking = TextEditingController();
  var _inHouse = true;
  var _driver = _kDrivers.first;
  var _eta = _kEtas.first;
  var _method = 'Standard Delivery';
  var _courier = _kCouriers.first;

  StoreOrder get order => widget.order;

  @override
  void dispose() {
    _notes.dispose();
    _tracking.dispose();
    super.dispose();
  }

  Future<void> _pickDriver() async {
    final picked = await showModalBottomSheet<_Driver>(
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
                'Select Driver',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 8),
              for (final driver in _kDrivers)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: _DriverAvatar(driver: driver),
                  title: Text(
                    driver.name,
                    style: AppTypography.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                  subtitle: Text(
                    driver.phone,
                    style: AppTypography.inter(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  trailing: driver == _driver
                      ? const Icon(Icons.check, size: 18, color: AppColors.bronze)
                      : null,
                  onTap: () => Navigator.pop(context, driver),
                ),
            ],
          ),
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() => _driver = picked);
  }

  Future<void> _pickEta() async {
    final picked = await showModalBottomSheet<_Eta>(
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
                'Estimated Delivery',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 8),
              for (final eta in _kEtas)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    eta.label,
                    style: AppTypography.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                  subtitle: Text(
                    eta.date,
                    style: AppTypography.inter(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  trailing: eta == _eta
                      ? const Icon(Icons.check, size: 18, color: AppColors.bronze)
                      : null,
                  onTap: () => Navigator.pop(context, eta),
                ),
            ],
          ),
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() => _eta = picked);
  }

  Future<void> _pickString({
    required String title,
    required List<String> options,
    required String current,
    required ValueChanged<String> onPicked,
  }) async {
    final result = await showModalBottomSheet<String>(
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
                title,
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 8),
              for (final option in options)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    option,
                    style: AppTypography.inter(
                      fontSize: 13,
                      fontWeight: option == current ? FontWeight.w700 : FontWeight.w500,
                      color: AppColors.coffee,
                    ),
                  ),
                  trailing: option == current
                      ? const Icon(Icons.check, size: 18, color: AppColors.bronze)
                      : null,
                  onTap: () => Navigator.pop(context, option),
                ),
            ],
          ),
        );
      },
    );
    if (result == null || !mounted) return;
    onPicked(result);
  }

  Future<void> _pickCourier() async {
    final picked = await showModalBottomSheet<_Courier>(
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
                'Select Courier',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 8),
              for (final courier in _kCouriers)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: _CourierLogo(courier: courier),
                  title: Text(
                    courier.name,
                    style: AppTypography.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                  subtitle: Text(
                    '${courier.detail}  ·  ${courier.eta}',
                    style: AppTypography.inter(fontSize: 11, color: AppColors.textSecondary),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        courier.price,
                        style: AppTypography.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.coffee,
                        ),
                      ),
                      if (courier == _courier) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check, size: 18, color: AppColors.bronze),
                      ],
                    ],
                  ),
                  onTap: () => Navigator.pop(context, courier),
                ),
            ],
          ),
        );
      },
    );
    if (picked == null || !mounted) return;
    setState(() => _courier = picked);
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
                  padding: EdgeInsets.fromLTRB(horizontal - 8, 2, horizontal, 0),
                  child: const _Header(),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(horizontal, 6, horizontal, 12),
                    children: [
                      _OrderCard(order: order),
                      const SizedBox(height: 8),
                      _ItemsCard(items: order.items),
                      const SizedBox(height: 8),
                      _AssignCard(
                        inHouse: _inHouse,
                        driver: _driver,
                        eta: _eta,
                        notes: _notes,
                        onInHouse: (v) => setState(() => _inHouse = v),
                        onPickDriver: _pickDriver,
                        onPickEta: _pickEta,
                      ),
                      if (!_inHouse) ...[
                        const SizedBox(height: 8),
                        _DeliveryDetailsCard(
                          method: _method,
                          eta: _eta,
                          onPickMethod: () => _pickString(
                            title: 'Delivery Method',
                            options: _kMethods,
                            current: _method,
                            onPicked: (v) => setState(() => _method = v),
                          ),
                          onPickEta: _pickEta,
                        ),
                        const SizedBox(height: 8),
                        _CourierPickerCard(
                          courier: _courier,
                          onPick: _pickCourier,
                        ),
                        const SizedBox(height: 8),
                        _TrackingCard(tracking: _tracking, notes: _notes),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontal, 6, horizontal, 10),
                  child: _inHouse
                      ? Row(
                          children: [
                            Expanded(
                              child: _ActionButton(
                                icon: Icons.close,
                                label: 'Cancel',
                                filled: false,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _ActionButton(
                                icon: Icons.send_outlined,
                                label: 'Mark as Dispatched',
                                filled: true,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                            ),
                          ],
                        )
                      : _ActionButton(
                          icon: Icons.send_outlined,
                          label: 'Mark as Dispatched',
                          filled: true,
                          onTap: () => Navigator.of(context).pop(),
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
  const _Header();

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
                'Dispatch Order',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              Text(
                'Assign delivery and mark as dispatched.',
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
            onTap: () {},
            customBorder: const StadiumBorder(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 12, 6),
              child: Row(
                children: [
                  const Icon(Icons.inventory_2_outlined, size: 14, color: AppColors.coffee),
                  const SizedBox(width: 5),
                  Text(
                    'Track',
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          'Order #${order.id}',
                          style: AppTypography.inter(
                            fontSize: 15,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Ready to Dispatch',
                      style: AppTypography.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coffee,
                      ),
                    ),
                    Text(
                      '16 Sep 2025, 1:45 PM',
                      style: AppTypography.inter(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            const _PackedChip(),
            const SizedBox(height: 8),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 32,
                    height: 32,
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
                  const SizedBox(width: 8),
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
                        Text(
                          order.phone,
                          style: AppTypography.inter(fontSize: 10, color: AppColors.textSecondary),
                        ),
                        Text(
                          order.email,
                          style: AppTypography.inter(fontSize: 10, color: AppColors.textSecondary),
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
                            const SizedBox(width: 4),
                            Text(
                              'Delivery Address',
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

class _PackedChip extends StatelessWidget {
  const _PackedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(7, 3, 8, 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F0E6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle, size: 12, color: Color(0xFF4C9A62)),
          const SizedBox(width: 4),
          Text(
            'Packed',
            style: AppTypography.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4C9A62),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.items});

  final List<OrderLineItem> items;

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
                  'Items (${items.length})',
                  style: AppTypography.inter(
                    fontSize: 13,
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
            for (var i = 0; i < items.length; i++) ...[
              _PackedItemRow(item: items[i]),
              if (i != items.length - 1)
                Divider(height: 14, color: AppColors.sand.withValues(alpha: 0.28)),
            ],
          ],
        ),
      ),
    );
  }
}

class _PackedItemRow extends StatelessWidget {
  const _PackedItemRow({required this.item});

  final OrderLineItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(item.image, width: 48, height: 48, fit: BoxFit.cover),
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
              Text(
                'SKU: ${item.sku}',
                style: AppTypography.inter(fontSize: 10, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Qty: ${item.qty}',
              style: AppTypography.inter(fontSize: 10, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.fromLTRB(7, 3, 8, 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F0E6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, size: 12, color: Color(0xFF4C9A62)),
                  const SizedBox(width: 4),
                  Text(
                    'Packed',
                    style: AppTypography.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF4C9A62),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AssignCard extends StatelessWidget {
  const _AssignCard({
    required this.inHouse,
    required this.driver,
    required this.eta,
    required this.notes,
    required this.onInHouse,
    required this.onPickDriver,
    required this.onPickEta,
  });

  final bool inHouse;
  final _Driver driver;
  final _Eta eta;
  final TextEditingController notes;
  final ValueChanged<bool> onInHouse;
  final VoidCallback onPickDriver;
  final VoidCallback onPickEta;

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
              'Assign Delivery',
              style: AppTypography.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.coffee,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _ModeChip(
                    icon: Icons.local_shipping_outlined,
                    label: 'In-house Driver',
                    selected: inHouse,
                    onTap: () => onInHouse(true),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _ModeChip(
                    icon: Icons.inventory_2_outlined,
                    label: 'Courier Partner',
                    selected: !inHouse,
                    onTap: () => onInHouse(false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (inHouse) ...[
              Row(
                children: [
                  Expanded(
                    child: _PickerField(
                      label: 'Select Driver',
                      onTap: onPickDriver,
                      child: Row(
                        children: [
                          _DriverAvatar(driver: driver, size: 28),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  driver.name,
                                  style: AppTypography.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.coffee,
                                  ),
                                ),
                                Text(
                                  driver.phone,
                                  style: AppTypography.inter(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: AppColors.textSecondary.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _PickerField(
                      label: 'Estimated Delivery',
                      onTap: onPickEta,
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.bronze),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  eta.label,
                                  style: AppTypography.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.coffee,
                                  ),
                                ),
                                Text(
                                  eta.date,
                                  style: AppTypography.inter(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 18,
                            color: AppColors.textSecondary.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.description_outlined, size: 14, color: AppColors.bronze),
                  const SizedBox(width: 6),
                  Text(
                    'Dispatch Notes (Optional)',
                    style: AppTypography.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.coffee,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              TextField(
                controller: notes,
                minLines: 2,
                maxLines: 3,
                style: AppTypography.inter(fontSize: 12, color: AppColors.coffee),
                cursorColor: AppColors.bronze,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Add any notes for the driver...',
                  hintStyle: AppTypography.inter(fontSize: 11, color: AppColors.textSecondary),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.7),
                  contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.sand.withValues(alpha: 0.35)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.sand.withValues(alpha: 0.35)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.bronze),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.bronze : AppColors.cream.withValues(alpha: 0.8),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: selected ? Colors.white : AppColors.coffee),
              const SizedBox(width: 6),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    label,
                    maxLines: 1,
                    style: AppTypography.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.coffee,
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

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.onTap,
    required this.child,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.coffee,
          ),
        ),
        const SizedBox(height: 4),
        Material(
          color: Colors.white.withValues(alpha: 0.7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.sand.withValues(alpha: 0.35)),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}

class _DriverAvatar extends StatelessWidget {
  const _DriverAvatar({required this.driver, this.size = 32});

  final _Driver driver;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        driver.photo,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: size,
          height: size,
          color: AppColors.creamDark,
          alignment: Alignment.center,
          child: Text(
            driver.initials,
            style: AppTypography.inter(
              fontSize: size * 0.32,
              fontWeight: FontWeight.w700,
              color: AppColors.coffee,
            ),
          ),
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
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.bronze : AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: filled ? AppColors.bronze : AppColors.sand.withValues(alpha: 0.55),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 15, color: filled ? Colors.white : AppColors.coffee),
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
                      color: filled ? Colors.white : AppColors.coffee,
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

class _Driver {
  const _Driver({required this.name, required this.phone, required this.photo});

  final String name;
  final String phone;
  final String photo;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class _Eta {
  const _Eta({required this.label, required this.date});

  final String label;
  final String date;
}

const _kDrivers = [
  _Driver(
    name: 'Kofi Mensah',
    phone: '+233 54 321 9876',
    photo: 'assets/images/kwame_asante.jpg',
  ),
  _Driver(
    name: 'Yaw Boateng',
    phone: '+233 24 778 1120',
    photo: 'assets/images/kwame_asante.jpg',
  ),
];

const _kEtas = [
  _Eta(label: 'Today', date: '16 Sep 2025'),
  _Eta(label: 'Tomorrow', date: '17 Sep 2025'),
  _Eta(label: '18 Sep', date: '18 Sep 2025'),
];

const _kMethods = ['Standard Delivery', 'Express Delivery', 'Pickup Point'];

class _Courier {
  const _Courier({
    required this.name,
    required this.detail,
    required this.price,
    required this.eta,
    required this.logo,
  });

  final String name;
  final String detail;
  final String price;
  final String eta;
  final String logo;
}

const _kCouriers = [
  _Courier(
    name: 'Uber',
    detail: 'Fast  ·  Citywide',
    price: 'GH₵ 28.00',
    eta: '1-2 hrs',
    logo: 'assets/images/courier_uber.png',
  ),
  _Courier(
    name: 'Bolt',
    detail: 'Affordable  ·  Citywide',
    price: 'GH₵ 22.00',
    eta: '1-2 hrs',
    logo: 'assets/images/courier_bolt.png',
  ),
  _Courier(
    name: 'Yango',
    detail: 'Accra & major cities',
    price: 'GH₵ 20.00',
    eta: '1-3 hrs',
    logo: 'assets/images/courier_yango.png',
  ),
  _Courier(
    name: 'Speedaf',
    detail: 'Accra & major cities',
    price: 'GH₵ 30.00',
    eta: 'Same day (Accra)',
    logo: 'assets/images/courier_speedaf.png',
  ),
];

class _DeliveryDetailsCard extends StatelessWidget {
  const _DeliveryDetailsCard({
    required this.method,
    required this.eta,
    required this.onPickMethod,
    required this.onPickEta,
  });

  final String method;
  final _Eta eta;
  final VoidCallback onPickMethod;
  final VoidCallback onPickEta;

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
              'Delivery Details',
              style: AppTypography.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.coffee,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _PickerField(
                    label: 'Delivery Method',
                    onTap: onPickMethod,
                    child: Row(
                      children: [
                        const Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.bronze),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            method,
                            style: AppTypography.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.coffee,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          size: 18,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _PickerField(
                    label: 'Expected Delivery Date',
                    onTap: onPickEta,
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 16, color: AppColors.bronze),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            eta.date,
                            style: AppTypography.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.coffee,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.calendar_month_outlined,
                          size: 16,
                          color: AppColors.textSecondary.withValues(alpha: 0.8),
                        ),
                      ],
                    ),
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

class _CourierLogo extends StatelessWidget {
  const _CourierLogo({required this.courier, this.size = 32});

  final _Courier courier;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Image.asset(courier.logo, width: size, height: size, fit: BoxFit.cover),
    );
  }
}

class _CourierPickerCard extends StatelessWidget {
  const _CourierPickerCard({required this.courier, required this.onPick});

  final _Courier courier;
  final VoidCallback onPick;

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
        child: _PickerField(
          label: 'Assign Courier',
          onTap: onPick,
          child: Row(
            children: [
              _CourierLogo(courier: courier, size: 28),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      courier.name,
                      style: AppTypography.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffee,
                      ),
                    ),
                    Text(
                      '${courier.detail}  ·  ${courier.eta}',
                      style: AppTypography.inter(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                courier.price,
                style: AppTypography.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: AppColors.textSecondary.withValues(alpha: 0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrackingCard extends StatelessWidget {
  const _TrackingCard({required this.tracking, required this.notes});

  final TextEditingController tracking;
  final TextEditingController notes;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: AppColors.sand.withValues(alpha: 0.35)),
    );
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
              'Tracking Information',
              style: AppTypography.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.coffee,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tracking Number (Optional)',
              style: AppTypography.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.coffee,
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: tracking,
              style: AppTypography.inter(fontSize: 12, color: AppColors.coffee),
              cursorColor: AppColors.bronze,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Enter tracking number',
                hintStyle: AppTypography.inter(fontSize: 11, color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.local_shipping_outlined, size: 16, color: AppColors.bronze),
                prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.7),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: const BorderSide(color: AppColors.bronze),
                ),
              ),
            ),
            const SizedBox(height: 8),
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.creamDark.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(10),
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
                        'Tracking number will be shared with the customer via SMS/Email.',
                        style: AppTypography.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.description_outlined, size: 14, color: AppColors.bronze),
                const SizedBox(width: 6),
                Text(
                  'Notes (Optional)',
                  style: AppTypography.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coffee,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            TextField(
              controller: notes,
              minLines: 2,
              maxLines: 3,
              style: AppTypography.inter(fontSize: 12, color: AppColors.coffee),
              cursorColor: AppColors.bronze,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Add any notes about the dispatch...',
                hintStyle: AppTypography.inter(fontSize: 11, color: AppColors.textSecondary),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.7),
                contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: border,
                enabledBorder: border,
                focusedBorder: border.copyWith(
                  borderSide: const BorderSide(color: AppColors.bronze),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
