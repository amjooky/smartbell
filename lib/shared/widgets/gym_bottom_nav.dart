import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class GymNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badgeCount;
  const GymNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount = 0,
  });
}

class GymBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<GymNavItem> items;

  const GymBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final duration = disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 300);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1E1E), Color(0xFF161616)],
        ),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppTheme.border.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final selected = currentIndex == i;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: duration,
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: selected
                          ? LinearGradient(
                              colors: [
                                AppTheme.primary.withValues(alpha: 0.2),
                                AppTheme.primary.withValues(alpha: 0.1),
                              ],
                            )
                          : null,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          duration: disableAnimations
                              ? Duration.zero
                              : const Duration(milliseconds: 200),
                          child: Icon(
                            selected ? item.activeIcon : item.icon,
                            key: ValueKey('${i}_$selected'),
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.textSecondary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 3),
                        AnimatedDefaultTextStyle(
                          duration: disableAnimations
                              ? Duration.zero
                              : const Duration(milliseconds: 200),
                          style: TextStyle(
                            color: selected
                                ? AppTheme.primary
                                : AppTheme.textSecondary,
                            fontSize: 11,
                            fontWeight:
                                selected ? FontWeight.w600 : FontWeight.w500,
                          ),
                          child: Text(item.label),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
