import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'create_order_screen.dart';
import 'order_detail_screen.dart';
import 'order_models.dart';

enum _OrderFilter { all, pending, packing, shipped, delivered }

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final _query = TextEditingController();
  final _chipKeys = {
    _OrderFilter.all: GlobalKey(),
    _OrderFilter.pending: GlobalKey(),
    _OrderFilter.packing: GlobalKey(),
    _OrderFilter.shipped: GlobalKey(),
    _OrderFilter.delivered: GlobalKey(),
  };
  var _filter = _OrderFilter.all;
  var _showSearch = false;
  var _showBanner = true;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  List<StoreOrder> get _visible {
    final q = _query.text.trim().toLowerCase();
    return kOrders.where((order) {
      final matchesFilter = switch (_filter) {
        _OrderFilter.all => true,
        _OrderFilter.pending => order.status == OrderStatus.pending,
        _OrderFilter.packing => order.status == OrderStatus.packing,
        _OrderFilter.shipped => order.status == OrderStatus.shipped,
        _OrderFilter.delivered => order.status == OrderStatus.delivered,
      };
      if (!matchesFilter) return false;
      if (q.isEmpty) return true;
      return order.id.toLowerCase().contains(q) ||
          order.customer.toLowerCase().contains(q);
    }).toList();
  }

  void _selectFilter(_OrderFilter filter) {
    setState(() => _filter = filter);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _chipKeys[filter]?.currentContext;
      if (ctx == null) return;
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
        alignment: 0.5,
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      );
    });
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
          child: _OrdersHeader(
            searchOpen: _showSearch,
            onSearchTap: () => setState(() => _showSearch = !_showSearch),
            onNewOrder: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const CreateOrderScreen(),
                ),
              );
            },
          ),
        ),
        if (_showSearch) ...[
          const SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontal),
            child: TextField(
              controller: _query,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              style: AppTypography.inter(fontSize: 12, color: AppColors.coffee),
              cursorColor: AppColors.bronze,
              decoration: InputDecoration(
                isDense: true,
                hintText: 'Search orders or customers...',
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
        ],
        const SizedBox(height: 12),
        Padding(
          padding: EdgeInsets.only(left: horizontal),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _OrderChip(
                  key: _chipKeys[_OrderFilter.all],
                  label: 'All',
                  count: 24,
                  selected: _filter == _OrderFilter.all,
                  onTap: () => _selectFilter(_OrderFilter.all),
                ),
                const SizedBox(width: 5),
                _OrderChip(
                  key: _chipKeys[_OrderFilter.pending],
                  label: 'Pending',
                  count: 6,
                  selected: _filter == _OrderFilter.pending,
                  onTap: () => _selectFilter(_OrderFilter.pending),
                ),
                const SizedBox(width: 5),
                _OrderChip(
                  key: _chipKeys[_OrderFilter.packing],
                  label: 'Packing',
                  count: 8,
                  selected: _filter == _OrderFilter.packing,
                  onTap: () => _selectFilter(_OrderFilter.packing),
                ),
                const SizedBox(width: 5),
                _OrderChip(
                  key: _chipKeys[_OrderFilter.shipped],
                  label: 'Shipped',
                  count: 6,
                  selected: _filter == _OrderFilter.shipped,
                  onTap: () => _selectFilter(_OrderFilter.shipped),
                ),
                const SizedBox(width: 5),
                _OrderChip(
                  key: _chipKeys[_OrderFilter.delivered],
                  label: 'Delivered',
                  count: 4,
                  selected: _filter == _OrderFilter.delivered,
                  onTap: () => _selectFilter(_OrderFilter.delivered),
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
                    'No orders match this filter.',
                    textAlign: TextAlign.center,
                    style: AppTypography.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              else
                for (var i = 0; i < visible.length; i++) ...[
                  _OrderRow(order: visible[i]),
                  if (i != visible.length - 1) const SizedBox(height: 6),
                ],
            ],
          ),
        ),
        if (_showBanner)
          Padding(
            padding: EdgeInsets.fromLTRB(horizontal, 4, horizontal, 10),
            child: _OrdersBanner(onClose: () => setState(() => _showBanner = false)),
          ),
      ],
    );
  }
}

class _OrdersHeader extends StatelessWidget {
  const _OrdersHeader({
    required this.searchOpen,
    required this.onSearchTap,
    required this.onNewOrder,
  });

  final bool searchOpen;
  final VoidCallback onSearchTap;
  final VoidCallback onNewOrder;

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
                'Orders',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Track and manage all customer orders.',
                style: AppTypography.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.white.withValues(alpha: 0.55),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onSearchTap,
            customBorder: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                searchOpen ? Icons.close : Icons.search,
                size: 18,
                color: AppColors.coffee,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: AppColors.bronze,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onNewOrder,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 7, 12, 7),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.add, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    'New Order',
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

class _OrderChip extends StatelessWidget {
  const _OrderChip({
    super.key,
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

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order});

  final StoreOrder order;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.sand.withValues(alpha: 0.22)),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => OrderDetailScreen(order: order),
            ),
          );
        },
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 80,
                child: Image.asset(
                  order.image,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 11, 8, 11),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              order.id,
                              style: AppTypography.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.coffee,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              order.customer,
                              style: AppTypography.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              order.placedAt,
                              style: AppTypography.inter(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _StatusChip(status: order.status),
                          const Spacer(),
                          Text(
                            order.totalLabel,
                            style: AppTypography.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.coffee,
                            ),
                          ),
                          Text(
                            order.itemCount == 1 ? '1 item' : '${order.itemCount} items',
                            style: AppTypography.inter(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: AppColors.textSecondary.withValues(alpha: 0.7),
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

class _OrdersBanner extends StatelessWidget {
  const _OrdersBanner({required this.onClose});

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
                    'Need to fulfil orders faster?',
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
                    'Use barcode scanning to speed up packing.',
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
                    'Start Scanning',
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

