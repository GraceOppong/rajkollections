import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/workspace_bottom_nav.dart';

enum _NotifFilter { all, orders, inventory, shipments }

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  var _filter = _NotifFilter.all;
  var _unreadCleared = false;

  static const _items = <_NotifItem>[
    _NotifItem(
      group: _NotifGroup.today,
      filter: _NotifFilter.orders,
      icon: Icons.shopping_cart_outlined,
      iconBg: Color(0xFFF3E4E0),
      iconColor: Color(0xFFC45C4A),
      title: 'New order received',
      body: 'Order RK-10234 from Ama Osei (2 items)',
      time: '10:24 AM',
      dot: Color(0xFFE05252),
      showChevron: true,
    ),
    _NotifItem(
      group: _NotifGroup.today,
      filter: _NotifFilter.inventory,
      icon: Icons.inventory_2_outlined,
      iconBg: Color(0xFFF8EDD8),
      iconColor: Color(0xFFD4923A),
      title: 'Low stock alert',
      body: 'Wireless Earbuds (WE-BLK) is running low (5 left).',
      time: '9:18 AM',
      dot: Color(0xFFE8A23A),
      showChevron: true,
    ),
    _NotifItem(
      group: _NotifGroup.today,
      filter: _NotifFilter.orders,
      icon: Icons.local_shipping_outlined,
      iconBg: Color(0xFFDCE8F2),
      iconColor: Color(0xFF5B8FB8),
      title: 'Order out for delivery',
      body: 'Order RK-10231 is out for delivery with Rider: Kojo (024 123 4567).',
      time: '8:45 AM',
      dot: Color(0xFF4A8FD4),
    ),
    _NotifItem(
      group: _NotifGroup.today,
      filter: _NotifFilter.shipments,
      icon: Icons.inventory_2_outlined,
      iconBg: Color(0xFFEBE3D6),
      iconColor: AppColors.bronze,
      title: 'Shipment updated',
      body: 'Shipment SH-001 from China is now in transit.',
      time: '8:12 AM',
      dot: AppColors.bronze,
      showChevron: true,
    ),
    _NotifItem(
      group: _NotifGroup.yesterday,
      filter: _NotifFilter.orders,
      icon: Icons.check_circle_outline,
      iconBg: Color(0xFFE3F0E6),
      iconColor: Color(0xFF4C9A62),
      title: 'Order delivered',
      body: 'Order RK-10228 has been delivered successfully.',
      time: '5:32 PM',
      dot: Color(0xFF4C9A62),
    ),
    _NotifItem(
      group: _NotifGroup.yesterday,
      filter: _NotifFilter.inventory,
      icon: Icons.error_outline,
      iconBg: Color(0xFFF5E8E5),
      iconColor: Color(0xFFC45C4A),
      title: 'Out of stock',
      body: 'Yoga Mat (YM-GRY) is now out of stock.',
      time: '2:15 PM',
      dot: Color(0xFFE05252),
      showChevron: true,
      thumb: _ThumbKind.mat,
    ),
    _NotifItem(
      group: _NotifGroup.yesterday,
      filter: _NotifFilter.all,
      icon: Icons.group_outlined,
      iconBg: Color(0xFFEBE3D6),
      iconColor: AppColors.bronze,
      title: 'New team member',
      body: 'Esi Mensah joined the warehouse team.',
      time: '11:03 AM',
      dot: AppColors.bronze,
    ),
    _NotifItem(
      group: _NotifGroup.week,
      filter: _NotifFilter.inventory,
      icon: Icons.inventory_2_outlined,
      iconBg: Color(0xFFEBE3D6),
      iconColor: AppColors.bronze,
      title: 'Stock adjusted',
      body: '+20 units added to T-Shirt (TS-WHT-L).',
      time: 'Thu, 12 Sep',
      dot: AppColors.bronze,
      showChevron: true,
      thumb: _ThumbKind.shirt,
    ),
  ];

  List<_NotifItem> get _visible {
    if (_filter == _NotifFilter.all) return _items;
    return _items
        .where(
          (item) =>
              item.filter == _filter ||
              (item.filter == _NotifFilter.all && _filter == _NotifFilter.all),
        )
        .toList();
  }

  int _count(_NotifFilter filter) {
    if (filter == _NotifFilter.all) return _items.length;
    return _items.where((item) => item.filter == filter).length;
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final maxWidth = contentMaxWidth(context);
    final horizontal = tablet ? 32.0 : 20.0;
    final visible = _visible;

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
                  padding: EdgeInsets.fromLTRB(horizontal, 4, horizontal, 0),
                  child: _NotificationsHeader(
                    onBack: () => Navigator.of(context).pop(),
                    onMarkAllRead: () => setState(() => _unreadCleared = true),
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(left: horizontal),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _FilterChip(
                          label: 'All',
                          count: _count(_NotifFilter.all),
                          selected: _filter == _NotifFilter.all,
                          onTap: () => setState(() => _filter = _NotifFilter.all),
                        ),
                        const SizedBox(width: 6),
                        _FilterChip(
                          label: 'Orders',
                          count: _count(_NotifFilter.orders),
                          selected: _filter == _NotifFilter.orders,
                          onTap: () =>
                              setState(() => _filter = _NotifFilter.orders),
                        ),
                        const SizedBox(width: 6),
                        _FilterChip(
                          label: 'Inventory',
                          count: _count(_NotifFilter.inventory),
                          selected: _filter == _NotifFilter.inventory,
                          onTap: () =>
                              setState(() => _filter = _NotifFilter.inventory),
                        ),
                        const SizedBox(width: 6),
                        _FilterChip(
                          label: 'Shipments',
                          count: _count(_NotifFilter.shipments),
                          selected: _filter == _NotifFilter.shipments,
                          onTap: () =>
                              setState(() => _filter = _NotifFilter.shipments),
                        ),
                        SizedBox(width: horizontal),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 16),
                    children: [
                      ..._group(visible, _NotifGroup.today, 'Today', 'Tue, 16 Sep 2025'),
                      ..._group(
                        visible,
                        _NotifGroup.yesterday,
                        'Yesterday',
                        'Mon, 15 Sep 2025',
                      ),
                      ..._group(
                        visible,
                        _NotifGroup.week,
                        'This Week',
                        '8 – 14 Sep 2025',
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
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) Navigator.of(context).pop();
        },
      ),
    );
  }

  List<Widget> _group(
    List<_NotifItem> items,
    _NotifGroup group,
    String title,
    String date,
  ) {
    final rows = items.where((item) => item.group == group).toList();
    if (rows.isEmpty) return const [];

    return [
      Row(
        children: [
          Text(
            title,
            style: AppTypography.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.coffee,
            ),
          ),
          const Spacer(),
          Text(
            date,
            style: AppTypography.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
      const SizedBox(height: 8),
      ...[
        for (var i = 0; i < rows.length; i++) ...[
          _NotificationCard(
            item: rows[i],
            showUnread: !_unreadCleared,
          ),
          if (i != rows.length - 1) const SizedBox(height: 6),
        ],
      ],
      const SizedBox(height: 16),
    ];
  }
}

class _NotificationsHeader extends StatelessWidget {
  const _NotificationsHeader({
    required this.onBack,
    required this.onMarkAllRead,
  });

  final VoidCallback onBack;
  final VoidCallback onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: onBack,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          icon: const Icon(Icons.chevron_left, size: 24, color: AppColors.coffee),
        ),
        const SizedBox(width: 2),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Stay updated with what’s happening in your warehouse.',
                style: AppTypography.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Material(
          color: AppColors.creamDark.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onMarkAllRead,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 10, 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.settings_outlined, size: 14, color: AppColors.coffeeMuted),
                  const SizedBox(width: 4),
                  Text(
                    'Mark all as read',
                    style: AppTypography.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
      color: selected ? AppColors.bronze : AppColors.creamDark.withValues(alpha: 0.7),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTypography.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.coffee,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? Colors.white.withValues(alpha: 0.22)
                      : Colors.white.withValues(alpha: 0.65),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$count',
                  style: AppTypography.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: selected ? Colors.white : AppColors.coffee,
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

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.showUnread,
  });

  final _NotifItem item;
  final bool showUnread;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: AppColors.sand.withValues(alpha: 0.18)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, size: 15, color: item.iconColor),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffee,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.body,
                      style: AppTypography.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              if (item.thumb != null) ...[
                const SizedBox(width: 6),
                _ProductThumb(kind: item.thumb!),
              ],
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.time,
                    style: AppTypography.inter(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showUnread)
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: item.dot,
                            shape: BoxShape.circle,
                          ),
                        ),
                      if (item.showChevron) ...[
                        const SizedBox(width: 2),
                        Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: AppColors.textSecondary.withValues(alpha: 0.7),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductThumb extends StatelessWidget {
  const _ProductThumb({required this.kind});

  final _ThumbKind kind;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        width: 32,
        height: 32,
        child: ColoredBox(
          color: kind == _ThumbKind.shirt ? const Color(0xFFF7F4EF) : const Color(0xFF6B6B6B),
          child: Icon(
            kind == _ThumbKind.shirt ? Icons.checkroom_outlined : Icons.fitness_center,
            size: 15,
            color: kind == _ThumbKind.shirt ? AppColors.coffeeMuted : Colors.white70,
          ),
        ),
      ),
    );
  }
}

enum _NotifGroup { today, yesterday, week }

enum _ThumbKind { mat, shirt }

class _NotifItem {
  const _NotifItem({
    required this.group,
    required this.filter,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    required this.dot,
    this.showChevron = false,
    this.thumb,
  });

  final _NotifGroup group;
  final _NotifFilter filter;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  final Color dot;
  final bool showChevron;
  final _ThumbKind? thumb;
}
