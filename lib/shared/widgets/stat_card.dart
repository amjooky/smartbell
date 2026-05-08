import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class StatCard extends StatefulWidget {
  final String value;
  final String label;
  final Color? color;
  final IconData? icon;
  final VoidCallback? onTap;
  final String? trend;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    this.color,
    this.icon,
    this.onTap,
    this.trend,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color ?? AppTheme.primary;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: widget.onTap != null ? (_) => setState(() => _pressed = true) : null,
      onTapUp: widget.onTap != null ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: widget.onTap != null ? () => setState(() => _pressed = false) : null,
      child: AnimatedScale(
        scale: (_pressed && !disableAnimations) ? 0.97 : 1.0,
        duration: disableAnimations ? Duration.zero : const Duration(milliseconds: 120),
        curve: Curves.easeOutExpo,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                c.withValues(alpha: 0.1),
                c.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: c.withValues(alpha: 0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: c.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.icon != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: c.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(widget.icon, color: c, size: 24),
                    ),
                    if (widget.trend != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: widget.trend!.startsWith('+')
                              ? AppTheme.success.withValues(alpha: 0.2)
                              : AppTheme.error.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.trend!.startsWith('+')
                                ? AppTheme.success.withValues(alpha: 0.5)
                                : AppTheme.error.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          widget.trend!,
                          style: TextStyle(
                            color: widget.trend!.startsWith('+')
                                ? AppTheme.success
                                : AppTheme.error,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
              Text(
                widget.value,
                style: TextStyle(
                  color: c,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.label.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
