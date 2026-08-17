import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';
import 'package:lifeos/screens/settings/widget/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,

      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          32,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppTheme.violetGlowGradient,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppTheme.glassBorderStrong,
              ),
              boxShadow: AppTheme.violetGlow,
            ),
            child: const Row(
              children: [
                _SettingsHeaderIcon(),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LifeOS Settings',
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontFamily: 'Outfit',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage your LifeOS preferences',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontFamily: 'Outfit',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          const _SectionLabel(
            label: 'GENERAL',
          ),

          const SizedBox(height: 10),

          SettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About LifeOS',
          ),

          const SizedBox(height: 10),

          SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            subtitle: 'Coming soon',
          ),

          const SizedBox(height: 10),

          SettingsTile(
            icon: Icons.palette_outlined,
            title: 'Theme',
            subtitle: 'Coming soon',
          ),

          const SizedBox(height: 10),

          SettingsTile(
            icon: Icons.backup_outlined,
            title: 'Backup & Restore',
            subtitle: 'Coming soon',
          ),
        ],
      ),
    );
  }
}

class _SettingsHeaderIcon extends StatelessWidget {
  const _SettingsHeaderIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: AppTheme.violet.withOpacity(0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.violetBright.withOpacity(0.25),
        ),
      ),
      child: const Icon(
        Icons.settings_rounded,
        color: AppTheme.violetBright,
        size: 26,
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 2),
      child: Text(
        'GENERAL',
        style: TextStyle(
          color: AppTheme.textSecondary,
          fontFamily: 'Outfit',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}