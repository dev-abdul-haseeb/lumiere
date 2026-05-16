import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// Button types observed across all Lumière screens.
///
///  [primary]    Filled dark — "SIGN IN", "PUBLISH", "ADD TO BAG", "PROCEED TO CHECKOUT"
///  [secondary]  Outlined    — "SAVE DRAFT", "Change password", "Reset store"
///  [ghost]      Text only   — subtle inline actions, nav items
///  [social]     Bordered cream card — Facebook / Google login buttons
///  [danger]     Red-tinted border  — destructive actions in danger zone
enum ButtonType { primary, secondary, ghost, social, danger }

/// Button sizes observed across screens.
///
///  [small]   Filter chips, status pills, inline actions   (~36 h)
///  [medium]  Standard form actions, admin table buttons   (~48 h)
///  [large]   Full-width CTA — Sign In, Publish, Checkout  (~52 h)
enum ButtonSize { small, medium, large }

// Lumière palette
class _C {
  static const dark       = Color(0xFF2C2C2C);
  static const cream      = Color(0xFFF5F0E8);
  static const card       = Color(0xFFFAF7F2);
  static const border     = Color(0xFFD4CFC7);
  static const gold       = Color(0xFFC9A96E);
  static const olive      = Color(0xFF6B7C4A);
  static const dangerText = Color(0xFF791F1F);
  static const dangerBg   = Color(0xFFFCEBEB);
  static const dangerBdr  = Color(0xFFE8C5C5);
}

class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonSize size;
  final Color? color;
  final Color? bgcolor;

  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final bool isLoading;

  /// true  → stretch to type-aware width (primary = 88 %, others = 60 %)
  /// false → shrink-wrap content (icon buttons, chips)
  final bool fullWidth;

  const AppButton(
      this.text, {
        super.key,
        this.onPressed,
        this.type    = ButtonType.primary,
        this.size    = ButtonSize.medium,
        this.color,
        this.bgcolor,
        this.leadingIcon,
        this.trailingIcon,
        this.isLoading = false,
        this.fullWidth = true,
      });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double>   _scale;

  @override
  void initState() {
    super.initState();
    _ctrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _down(_) {
    if (widget.onPressed != null && !widget.isLoading) {
      _ctrl.forward();
      HapticFeedback.lightImpact();
    }
  }
  void _up(_)     => _ctrl.reverse();
  void _cancel()  => _ctrl.reverse();

  // Sizing

  double _height(BuildContext ctx) {
    final s = MediaQuery.of(ctx).size.width / 375;
    switch (widget.size) {
      case ButtonSize.small:  return (36 * s).clamp(32, 40);
      case ButtonSize.medium: return (44 * s).clamp(44, 52);
      case ButtonSize.large:  return (52 * s).clamp(50, 58);
    }
  }

  double _fontSize(BuildContext ctx) {
    final s = MediaQuery.of(ctx).size.width / 375;
    switch (widget.size) {
      case ButtonSize.small:  return (11 * s).clamp(11, 13);
      case ButtonSize.medium: return (13 * s).clamp(13, 15);
      case ButtonSize.large:  return (13 * s).clamp(13, 15);
    }
  }

  double _iconSize() {
    switch (widget.size) {
      case ButtonSize.small:  return 16;
      case ButtonSize.medium: return 18;
      case ButtonSize.large:  return 20;
    }
  }

  EdgeInsets _padding() {
    switch (widget.size) {
      case ButtonSize.small:  return const EdgeInsets.symmetric(horizontal: 12, vertical: 4);
      case ButtonSize.medium: return const EdgeInsets.symmetric(horizontal: 18, vertical: 6);
      case ButtonSize.large:  return const EdgeInsets.symmetric(horizontal: 20, vertical: 8);
    }
  }

  double _width(double screenW) {
    if (!widget.fullWidth) return double.nan; // shrink-wrap via MainAxisSize.min
    if (screenW > 600) {
      return widget.type == ButtonType.primary ? 420 : 300;
    }
    return widget.type == ButtonType.primary ? screenW * 0.88 : screenW * 0.62;
  }

  // Per-type defaults

  Color _fgColor() {
    if (widget.color != null) return widget.color!;
    switch (widget.type) {
      case ButtonType.primary:   return Colors.white;
      case ButtonType.secondary: return _C.dark;
      case ButtonType.ghost:     return _C.dark;
      case ButtonType.social:    return _C.dark;
      case ButtonType.danger:    return _C.dangerText;
    }
  }

  Color _bgColor() {
    if (widget.bgcolor != null) return widget.bgcolor!;
    switch (widget.type) {
      case ButtonType.primary:   return _C.dark;
      case ButtonType.secondary: return Colors.transparent;
      case ButtonType.ghost:     return Colors.transparent;
      case ButtonType.social:    return _C.card;
      case ButtonType.danger:    return _C.dangerBg;
    }
  }

  Border? _border() {
    switch (widget.type) {
      case ButtonType.secondary: return Border.all(color: _C.dark,      width: 1.5);
      case ButtonType.social:    return Border.all(color: _C.border,    width: 1.0);
      case ButtonType.danger:    return Border.all(color: _C.dangerBdr, width: 1.0);
      default:                   return null;
    }
  }

  List<BoxShadow>? _shadow(bool disabled) {
    if (disabled || widget.type != ButtonType.primary) return null;
    return [
      BoxShadow(
        color: _C.dark.withOpacity(0.25),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ];
  }

  double _letterSpacing() {
    // Caps-spaced text for primary/secondary, tighter for social/ghost
    switch (widget.type) {
      case ButtonType.primary:
      case ButtonType.secondary:
        return widget.size == ButtonSize.small ? 1.2 : 2.0;
      default:
        return 0.3;
    }
  }

  // Build

  @override
  Widget build(BuildContext context) {
    final screenW  = MediaQuery.of(context).size.width;
    final h        = _height(context);
    final fs       = _fontSize(context);
    final disabled = widget.onPressed == null;
    final fg       = _fgColor();
    final w        = _width(screenW);
    final useMaxW  = widget.fullWidth;

    return GestureDetector(
      onTapDown:   _down,
      onTapUp:     _up,
      onTapCancel: _cancel,
      onTap: (!disabled && !widget.isLoading) ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: disabled ? 0.45 : 1.0,
          child: Container(
            height: h,
            width:  useMaxW ? w : null,
            padding: _padding(),
            decoration: BoxDecoration(
              color:        _bgColor(),
              borderRadius: BorderRadius.circular(12),
              border:       _border(),
              boxShadow:    _shadow(disabled),
            ),
            child: widget.isLoading
                ? Center(
              child: SizedBox(
                height: h * 0.38,
                width:  h * 0.38,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: fg,
                ),
              ),
            )
                : Row(
              mainAxisSize:      useMaxW ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.leadingIcon != null) ...[
                  Icon(widget.leadingIcon,  size: _iconSize(), color: fg),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.text,
                  style: GoogleFonts.dmSans(
                    fontSize:      fs,
                    fontWeight:    FontWeight.w600,
                    color:         fg,
                    letterSpacing: _letterSpacing(),
                  ),
                ),
                if (widget.trailingIcon != null) ...[
                  const SizedBox(width: 8),
                  Icon(widget.trailingIcon, size: _iconSize(), color: fg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}