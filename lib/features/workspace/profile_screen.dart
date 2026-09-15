import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/responsive.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/rk_logo.dart';
import 'notifications_screen.dart';

const _profilePhotoAsset = 'assets/images/kwame_asante.jpg';
const _profilePhotoHeroTag = 'profile-photo';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, this.onSignOut});

  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    final tablet = isTablet(context);
    final horizontal = tablet ? 32.0 : 20.0;

    return ListView(
      padding: EdgeInsets.fromLTRB(horizontal, 4, horizontal, 20),
      children: [
        const _ProfileHeader(),
        const SizedBox(height: 12),
        const _IdentityRow(),
        const SizedBox(height: 12),
        const _ContactStrip(),
        const SizedBox(height: 16),
        Text(
          'Account',
          style: AppTypography.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.coffee,
          ),
        ),
        const SizedBox(height: 8),
        _SettingsCard(
          rows: [
            _SettingsRowData(
              icon: Icons.person_outline,
              title: 'Personal Information',
              subtitle: 'Update your name, phone and profile photo',
            ),
            _SettingsRowData(
              icon: Icons.lock_outline,
              title: 'Security',
              subtitle: 'Change your password',
            ),
            _SettingsRowData(
              icon: Icons.notifications_none,
              title: 'Notifications',
              subtitle: 'Manage what you get notified about',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const NotificationsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          'App',
          style: AppTypography.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.coffee,
          ),
        ),
        const SizedBox(height: 8),
        const _SettingsCard(
          rows: [
            _SettingsRowData(
              icon: Icons.settings_outlined,
              title: 'App Settings',
              subtitle: 'Scanner, sound, and app preferences',
            ),
            _SettingsRowData(
              icon: Icons.help_outline,
              title: 'Help & Support',
              subtitle: 'Get help or contact the team',
            ),
            _SettingsRowData(
              icon: Icons.description_outlined,
              title: 'About',
              subtitle: 'App version, terms and privacy',
            ),
          ],
        ),
        const SizedBox(height: 12),
        _SignOutRow(onTap: onSignOut),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

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
                'Profile',
                style: AppTypography.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Your account and app settings.',
                style: AppTypography.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        const RkLogo(monogramSize: 36),
      ],
    );
  }
}

class _IdentityRow extends StatelessWidget {
  const _IdentityRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          key: const ValueKey('profile-photo'),
          onTap: () => _openExpandedProfilePhoto(context),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Hero(
                tag: _profilePhotoHeroTag,
                child: Material(
                  color: Colors.transparent,
                  child: ClipOval(
                    child: Image(
                      image: AssetImage(_profilePhotoAsset),
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                      alignment: Alignment(0, -0.35),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4C9A62),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.cream, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kwame Asante',
                style: AppTypography.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.coffee,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Warehouse Staff',
                style: AppTypography.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.creamDark.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.badge_outlined, size: 12, color: AppColors.coffeeMuted),
                        const SizedBox(width: 4),
                        Text(
                          'Employee',
                          style: AppTypography.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.coffee,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Material(
                    color: Colors.transparent,
                    shape: StadiumBorder(
                      side: BorderSide(color: AppColors.sand.withValues(alpha: 0.7)),
                    ),
                    child: InkWell(
                      onTap: () {},
                      customBorder: const StadiumBorder(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.edit_outlined, size: 13, color: AppColors.coffeeMuted),
                            const SizedBox(width: 4),
                            Text(
                              'Edit',
                              style: AppTypography.inter(
                                fontSize: 11,
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
              ),
              const SizedBox(height: 6),
              Text(
                'Picking. Packing. Delivering.\nSame goods. Bigger things.',
                style: AppTypography.inter(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContactStrip extends StatelessWidget {
  const _ContactStrip();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.creamDark.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: const [
            Expanded(
              child: _ContactCell(
                icon: Icons.mail_outline,
                label: 'Email',
                value: 'kwame.asante@rajkollections.com',
              ),
            ),
            _ContactDivider(),
            Expanded(
              child: _ContactCell(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: '+233 24 123 4567',
              ),
            ),
            _ContactDivider(),
            Expanded(
              child: _ContactCell(
                icon: Icons.calendar_today_outlined,
                label: 'Member since',
                value: '12 Aug 2025',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactDivider extends StatelessWidget {
  const _ContactDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: AppColors.sand.withValues(alpha: 0.35),
    );
  }
}

class _ContactCell extends StatelessWidget {
  const _ContactCell({
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.bronze),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTypography.inter(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.inter(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: AppColors.coffee,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.rows});

  final List<_SettingsRowData> rows;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.creamDark.withValues(alpha: 0.38),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.sand.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            _SettingsRow(data: rows[i]),
            if (i != rows.length - 1)
              Divider(height: 1, color: AppColors.sand.withValues(alpha: 0.22)),
          ],
        ],
      ),
    );
  }
}

class _SettingsRowData {
  const _SettingsRowData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({required this.data});

  final _SettingsRowData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: data.onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 8, 10),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  shape: BoxShape.circle,
                ),
                child: Icon(data.icon, size: 15, color: AppColors.bronze),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: AppTypography.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.coffee,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.subtitle,
                      style: AppTypography.inter(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.textSecondary.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SignOutRow extends StatelessWidget {
  const _SignOutRow({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.alertRose,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
          child: Row(
            children: [
              const Icon(Icons.logout, size: 16, color: AppColors.alertRoseIcon),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Sign Out',
                  style: AppTypography.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.alertRoseIcon,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: AppColors.alertRoseIcon.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _openExpandedProfilePhoto(BuildContext context) {
  Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: true,
      barrierColor: AppColors.coffee.withValues(alpha: 0.88),
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const _ExpandedProfilePhoto();
      },
    ),
  );
}

class _ExpandedProfilePhoto extends StatefulWidget {
  const _ExpandedProfilePhoto();

  @override
  State<_ExpandedProfilePhoto> createState() => _ExpandedProfilePhotoState();
}

class _ExpandedProfilePhotoState extends State<_ExpandedProfilePhoto> {
  var _closing = false;

  void _close() {
    if (_closing) return;
    _closing = true;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: _close,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 48, 24, 16),
                        child: Center(
                          child: Hero(
                            tag: _profilePhotoHeroTag,
                            child: Material(
                              color: Colors.transparent,
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: const Image(
                                    key: ValueKey('profile-photo-expanded'),
                                    image: AssetImage(_profilePhotoAsset),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Kwame Asante',
                      style: AppTypography.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.cream,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Warehouse Staff',
                      style: AppTypography.inter(
                        fontSize: 12,
                        color: AppColors.sand,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
                Positioned(
                  top: 8,
                  right: 12,
                  child: Material(
                    color: AppColors.cream.withValues(alpha: 0.94),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _close,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.close, size: 18, color: AppColors.coffee),
                      ),
                    ),
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
