import 'package:flutter/material.dart';
import '../../constants/theme/app_theme.dart';

class ModernBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const ModernBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 18),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardElevated,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppTheme.glassBorderStrong,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.38),
            blurRadius: 26,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppTheme.violet.withOpacity(0.10),
            blurRadius: 22,
            spreadRadius: -4,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(
            icon: Icons.dashboard_rounded,
            label: 'Dashboard',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavItem(
            icon: Icons.contacts_rounded,
            label: 'Contacts',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavItem(
            icon: Icons.book_rounded,
            label: 'Cashbook',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavItem(
            icon: Icons.account_balance_wallet_rounded,
            label: 'Accounts',
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        width: isSelected ? 88 : 62,
        height: 64,
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? AppTheme.violetGlowGradient
              : null,
          color: isSelected
              ? null
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: isSelected
              ? Border.all(
                  color: AppTheme.violetBright.withOpacity(0.20),
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.violet.withOpacity(0.24),
                    blurRadius: 16,
                    spreadRadius: -3,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutBack,
              scale: isSelected ? 1.08 : 1.0,
              child: Icon(
                icon,
                size: 23,
                color: isSelected
                    ? AppTheme.violetBright
                    : AppTheme.textSecondary,
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeOutCubic,
              child: isSelected
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}