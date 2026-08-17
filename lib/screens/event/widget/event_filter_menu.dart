import 'package:flutter/material.dart';
import 'package:lifeos/constants/theme/app_theme.dart';

class EventFilterMenu extends StatelessWidget {
  final String currentFilter;
  final ValueChanged<String> onSelected;

  const EventFilterMenu({
    super.key,
    required this.currentFilter,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Filter events',
      color: AppTheme.cardElevated,
      surfaceTintColor: Colors.transparent,
      elevation: 12,
      offset: const Offset(0, 48),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(
          color: AppTheme.cardBorder,
        ),
      ),
      onSelected: onSelected,
      itemBuilder: (_) => [
        _buildItem(
          value: 'ALL',
          label: 'All',
          icon: Icons.view_agenda_outlined,
        ),
        _buildItem(
          value: 'UPCOMING',
          label: 'Upcoming',
          icon: Icons.upcoming_outlined,
        ),
        _buildItem(
          value: 'PAST',
          label: 'Past',
          icon: Icons.history_rounded,
        ),
      ],
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppTheme.cardElevated,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: AppTheme.cardBorder,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.filter_list_rounded,
              color: AppTheme.textPrimary,
              size: 20,
            ),

            if (currentFilter != 'ALL')
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppTheme.orangeBright,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildItem({
    required String value,
    required String label,
    required IconData icon,
  }) {
    final selected = currentFilter == value;

    return PopupMenuItem<String>(
      value: value,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 4,
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.violetSoft
                    : AppTheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 17,
                color: selected
                    ? AppTheme.violetBright
                    : AppTheme.textSecondary,
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: selected
                      ? AppTheme.textPrimary
                      : AppTheme.textSecondary,
                  fontFamily: 'Outfit',
                  fontSize: 13,
                  fontWeight: selected
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
            ),

            if (selected)
              const Icon(
                Icons.check_rounded,
                color: AppTheme.violetBright,
                size: 17,
              ),
          ],
        ),
      ),
    );
  }
}