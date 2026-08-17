import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class AccountActionSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AccountActionSheet({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.cardElevated,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
        border: Border(
          top: BorderSide(
            color: AppTheme.cardBorder,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 18),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Options',
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontFamily: 'Outfit',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              _ActionTile(
                icon: Icons.edit_rounded,
                title: 'Edit',
                color: AppTheme.violetBright,
                onTap: onEdit,
              ),

              const SizedBox(height: 8),

              _ActionTile(
                icon: Icons.delete_outline_rounded,
                title: 'Delete',
                color: AppTheme.expense,
                onTap: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontFamily: 'Outfit',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}