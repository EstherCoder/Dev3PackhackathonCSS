import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// NeuCard — a neumorphic raised container
// ─────────────────────────────────────────────────────────────────────────────
class NeuCard extends StatelessWidget {
  const NeuCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 20,
    this.isPressed = false,
    this.glowColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final bool isPressed;
  final Color? glowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: glowColor != null
          ? AppTheme.glowCard(radius: radius, glowColor: glowColor)
          : AppTheme.card(radius: radius, isPressed: isPressed),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NeuButton — animated press neumorphic button
// ─────────────────────────────────────────────────────────────────────────────
class NeuButton extends StatefulWidget {
  const NeuButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 28),
    this.radius = 14,
    this.width,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final EdgeInsets padding;
  final double radius;
  final double? width;

  @override
  State<NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<NeuButton>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.width,
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.color ?? AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(widget.radius),
          boxShadow: _pressed
              ? [
                  BoxShadow(
                    color: AppTheme.shadowDark.withOpacity(0.9),
                    offset: const Offset(2, 2),
                    blurRadius: 6,
                  ),
                ]
              : [
                  BoxShadow(
                    color: AppTheme.shadowDark.withOpacity(0.8),
                    offset: const Offset(5, 5),
                    blurRadius: 12,
                  ),
                  BoxShadow(
                    color: AppTheme.shadowLight.withOpacity(0.4),
                    offset: const Offset(-3, -3),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: (widget.color ?? AppTheme.primaryColor)
                        .withOpacity(0.30),
                    blurRadius: 16,
                    spreadRadius: 1,
                  ),
                ],
        ),
        child: widget.child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NeuIconButton — circular icon button with neumorphic press
// ─────────────────────────────────────────────────────────────────────────────
class NeuIconButton extends StatefulWidget {
  const NeuIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 48,
    this.iconColor,
    this.bgColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color? iconColor;
  final Color? bgColor;

  @override
  State<NeuIconButton> createState() => _NeuIconButtonState();
}

class _NeuIconButtonState extends State<NeuIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.bgColor ?? AppTheme.bgRaised,
          shape: BoxShape.circle,
          boxShadow: _pressed ? AppTheme.press() : AppTheme.raise(),
        ),
        child: Icon(widget.icon,
            color: widget.iconColor ?? AppTheme.primaryColor,
            size: widget.size * 0.45),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// NeuBadge — small status indicator chip
// ─────────────────────────────────────────────────────────────────────────────
class NeuBadge extends StatelessWidget {
  const NeuBadge({
    super.key,
    required this.label,
    this.color,
    this.icon,
  });

  final String label;
  final Color? color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primaryColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: c.withOpacity(0.35), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: c, size: 12),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: c,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}