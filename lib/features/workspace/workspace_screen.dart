import 'package:flutter/material.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/rk_logo.dart';
import '../../widgets/workspace_bottom_nav.dart';
import 'inventory_screen.dart';
import 'notifications_screen.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

/// Staff workspace home — UI preview with mock data (no backend yet).
class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key, this.onSignOut});

  final VoidCallback? onSignOut;

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  var _navIndex = 0;
  final _bodyScroll = ScrollController();

  static const _staffName = 'Kwame';

  @override
  void dispose() {
    _bodyScroll.dispose();
    super.dispose();
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
            child: switch (_navIndex) {
              1 => const SizedBox.expand(child: OrdersScreen()),
              2 => const SizedBox.expand(child: InventoryScreen()),
              4 => SizedBox.expand(
                  child: ProfileScreen(onSignOut: widget.onSignOut),
                ),
              _ => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(horizontal, 0, horizontal, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _WorkspaceHeader(staffName: _staffName),
                      SizedBox(height: tablet ? 14 : 8),
                      _GreetingBlock(staffName: _staffName),
                      SizedBox(height: tablet ? 12 : 8),
                      const _OperationHero(),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: _bodyScroll,
                    padding: EdgeInsets.fromLTRB(
                      horizontal,
                      tablet ? 20 : 16,
                      horizontal,
                      16,
                    ),
                    children: [
                      _SectionHeader(
                        title: 'Today’s Priorities',
                        actionLabel: 'See all',
                        titleSize: 15,
                        onAction: () {},
                      ),
                      const SizedBox(height: 10),
                      const _PrioritiesRow(),
                      const SizedBox(height: 20),
                      _SectionHeader(
                        title: 'Orders',
                        actionLabel: 'View all',
                        titleSize: 15,
                        onAction: () {},
                      ),
                      const SizedBox(height: 10),
                      const _OrdersPanel(),
                      const SizedBox(height: 20),
                      _SectionHeader(
                        title: 'Needs Attention',
                        actionLabel: 'View all',
                        titleSize: 15,
                        onAction: () {},
                      ),
                      const SizedBox(height: 10),
                      const _NeedsAttentionPanel(),
                      const SizedBox(height: 20),
                      Text(
                        'Quick Actions',
                        style: AppTypography.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.coffee,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const _QuickActionsRow(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
            },
          ),
        ),
      ),
      bottomNavigationBar: WorkspaceBottomNav(
        currentIndex: _navIndex,
        onTap: (i) => setState(() => _navIndex = i),
      ),
    );
  }
}

class _WorkspaceHeader extends StatelessWidget {
  const _WorkspaceHeader({required this.staffName});

  final String staffName;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: RkLogo(
              monogramSize: 44,
              compact: true,
              showWordmark: false,
            ),
          ),
        ),
        IconButton(
          key: const ValueKey('notifications-button'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const NotificationsScreen(),
              ),
            );
          },
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none, color: AppColors.coffee),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE05252),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        _ProfileChip(name: staffName),
      ],
    );
  }
}

class _ProfileChip extends StatelessWidget {
  const _ProfileChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.sand.withValues(alpha: 0.22)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 5, 6, 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: AppColors.bronze,
                child: Text(
                  initial,
                  style: AppTypography.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.coffee,
                    ),
                  ),
                  Text(
                    'Warehouse Staff',
                    style: AppTypography.inter(
                      fontSize: 9,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreetingBlock extends StatelessWidget {
  const _GreetingBlock({required this.staffName});

  final String staffName;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _formattedDate() {
    const weekdays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    final now = DateTime.now();
    return '${weekdays[now.weekday - 1]}, ${now.day} '
        '${months[now.month - 1]} ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  '${_greeting()}, $staffName!',
                  maxLines: 1,
                  softWrap: false,
                  style: AppTypography.inter(
                    fontSize: tablet ? 18 : 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.coffee,
                    height: 1.05,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  'Let’s keep things moving today.',
                  maxLines: 1,
                  softWrap: false,
                  style: AppTypography.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formattedDate(),
              style: AppTypography.inter(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'SAME GOODS',
              style: AppTypography.inter(
                fontSize: 7,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.6,
                color: AppColors.bronze,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              'BIGGER THINGS',
              style: AppTypography.inter(
                fontSize: 7,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.6,
                color: AppColors.bronze,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OperationHero extends StatelessWidget {
  const _OperationHero();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: isTablet(context) ? 152 : 124,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/images/operation_today_banner.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0.72, 0),
              width: double.infinity,
              height: double.infinity,
              filterQuality: FilterQuality.high,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColors.coffee.withValues(alpha: 0.78),
                    AppColors.coffee.withValues(alpha: 0.28),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.42, 0.78],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'OPERATION TODAY',
                    style: AppTypography.inter(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.3,
                      color: Colors.white.withValues(alpha: 0.85),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pick. Pack.',
                    style: AppTypography.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.08,
                    ),
                  ),
                  Text(
                    'Deliver.',
                    style: AppTypography.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.08,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Every order makes',
                    style: AppTypography.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.2,
                    ),
                  ),
                  Text(
                    'someone smile.',
                    style: AppTypography.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.2,
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onAction,
    this.titleSize = 16,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;
  final double titleSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTypography.inter(
              fontSize: titleSize,
              fontWeight: FontWeight.w700,
              color: AppColors.coffee,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.bronze,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                actionLabel,
                style: AppTypography.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 2),
              const Icon(Icons.chevron_right, size: 18),
            ],
          ),
        ),
      ],
    );
  }
}

class _PrioritiesRow extends StatelessWidget {
  const _PrioritiesRow();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _PriorityCard(
              background: AppColors.priorityBlush,
              icon: Icons.shopping_bag_outlined,
              count: '12',
              label: 'Orders to pack',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _PriorityCard(
              background: AppColors.priorityBlue,
              icon: Icons.local_shipping_outlined,
              count: '6',
              label: 'Out for delivery',
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _PriorityCard(
              background: AppColors.priorityRose,
              icon: Icons.inventory_2_outlined,
              count: '28',
              label: 'Low stock items',
            ),
          ),
        ],
      ),
    );
  }
}

class _PriorityCard extends StatelessWidget {
  const _PriorityCard({
    required this.background,
    required this.icon,
    required this.count,
    required this.label,
  });

  final Color background;
  final IconData icon;
  final String count;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 16, color: AppColors.coffeeMuted),
              const SizedBox(height: 8),
              Text(
                count,
                style: AppTypography.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.coffeeMuted,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  _CircleChevron(onTap: () {}),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleChevron extends StatelessWidget {
  const _CircleChevron({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.65),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const Padding(
          padding: EdgeInsets.all(2),
          child: Icon(Icons.chevron_right, size: 14, color: AppColors.coffee),
        ),
      ),
    );
  }
}

class _OrdersPanel extends StatelessWidget {
  const _OrdersPanel();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          _OrderRow(
            icon: Icons.description_outlined,
            iconBg: AppColors.orderConfirmed,
            title: 'Confirmed',
            count: 12,
          ),
          Divider(height: 1, color: AppColors.sand.withValues(alpha: 0.22)),
          _OrderRow(
            icon: Icons.inventory_2_outlined,
            iconBg: AppColors.orderPacked,
            title: 'Packed',
            count: 8,
          ),
          Divider(height: 1, color: AppColors.sand.withValues(alpha: 0.22)),
          _OrderRow(
            icon: Icons.local_shipping_outlined,
            iconBg: AppColors.orderDelivery,
            title: 'Out for delivery',
            count: 6,
          ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.count,
  });

  final IconData icon;
  final Color iconBg;
  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: AppColors.coffee),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$count',
                      style: AppTypography.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.coffee,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: AppTypography.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        height: 1.15,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NeedsAttentionPanel extends StatelessWidget {
  const _NeedsAttentionPanel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AttentionCard(
          background: AppColors.alertRose,
          icon: Icons.error_outline,
          iconColor: AppColors.alertRoseIcon,
          title: '6 products are out of stock.',
          subtitle: 'Restock to avoid missed sales.',
        ),
        const SizedBox(height: 8),
        _AttentionCard(
          background: AppColors.alertAmber,
          icon: Icons.warning_amber_outlined,
          iconColor: AppColors.alertAmberIcon,
          title: '28 products are low in stock.',
          subtitle: 'Consider reordering soon.',
        ),
      ],
    );
  }
}

class _AttentionCard extends StatelessWidget {
  const _AttentionCard({
    required this.background,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final Color background;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 10, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coffee,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionTile(
            primary: true,
            icon: Icons.qr_code_scanner,
            title: 'Scan Barcode',
            subtitle: 'Find product',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.note_add_outlined,
            title: 'New Order',
            subtitle: 'Create manually',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _QuickActionTile(
            icon: Icons.unarchive_outlined,
            title: 'Adjust Stock',
            subtitle: 'Update quantity',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.primary = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final bg = primary ? AppColors.bronze : AppColors.card;
    final fg = primary ? Colors.white : AppColors.coffee;
    final subFg = primary
        ? Colors.white.withValues(alpha: 0.85)
        : AppColors.textSecondary;

    return SizedBox(
      height: 72,
      child: Material(
        color: bg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: primary
              ? BorderSide.none
              : BorderSide(color: AppColors.sand.withValues(alpha: 0.22)),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: fg, size: 18),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: fg,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.inter(
                    fontSize: 10,
                    color: subFg,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
