import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lumiere/src/core/enum/enum.dart';
import 'package:lumiere/src/core/theme/theme.dart';

import '../../routers/views.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumiere/src/presentation/blocs/application/application_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;

  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<double> _subTitleFade;
  late Animation<double> _buttonFade;
  late Animation<double> _swipeFade;
  late Animation<Offset> _logoSlide;
  late Animation<Offset> _textSlide;
  late Animation<double> _arrowBounce;
  late Animation<double> _circleScale;

  double _dragOffset = 0.0;
  bool _isNavigating = false;

  Color _bg = AppColors.get(appColors.background);
  Color _dark = AppColors.get(appColors.primary_action);
  Color _gold = AppColors.get(appColors.highlight);
  Color _olive = AppColors.get(appColors.accent_success);
  Color _muted = const Color(0xFF8A8070);
  Color _circle = const Color(0xFFDDD5C8);

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _logoFade = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
    );
    _textFade = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.25, 0.55, curve: Curves.easeOut),
    );
    _subTitleFade = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.45, 0.70, curve: Curves.easeOut),
    );
    _buttonFade = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.60, 0.82, curve: Curves.easeOut),
    );
    _swipeFade = CurvedAnimation(
      parent: _fadeController,
      curve: const Interval(0.75, 1.0, curve: Curves.easeOut),
    );
    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
    ));
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
    ));
    _arrowBounce = Tween<double>(begin: 0.0, end: 6.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _circleScale = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToNext() {
    if (_isNavigating) return;
    setState(() => _isNavigating = true);
    HapticFeedback.lightImpact();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const AuthWrapperScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  TextStyle _ts({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    FontStyle fontStyle = FontStyle.normal,
    required Color color,
    double? letterSpacing,
    double? height,
  }) {
    return TextStyle(
      fontFamily: 'Georgia',
      fontFamilyFallback: const ['Times New Roman', 'serif'],
      fontSize: fontSize,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, state) {
        // Resolve dynamic fields — fall back to defaults while loading
        final appName    = state is ApplicationLoaded ? state.application.name     : 'LUMIÈRE';
        final subTitle   = state is ApplicationLoaded ? state.application.subTitle : 'LUXURY SKINCARE';
        final tagLine    = state is ApplicationLoaded ? state.application.tagLine  : 'Crafted for skin that deserves\nnothing less than extraordinary';

        return Scaffold(
          backgroundColor: _bg,
          body: LayoutBuilder(
            builder: (context, constraints) {
              final w = constraints.maxWidth;
              final h = constraints.maxHeight;
              final contentWidth = w.clamp(0.0, 520.0);

              return GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < 0) {
                    setState(() => _dragOffset -= details.delta.dy);
                  }
                },
                onVerticalDragEnd: (details) {
                  if (_dragOffset > 80 ||
                      details.velocity.pixelsPerSecond.dy < -600) {
                    _navigateToNext();
                  } else {
                    setState(() => _dragOffset = 0);
                  }
                },
                child: AnimatedSlide(
                  offset: Offset(0, -(_dragOffset / h).clamp(0.0, 1.0)),
                  duration: _dragOffset == 0
                      ? const Duration(milliseconds: 300)
                      : Duration.zero,
                  curve: Curves.easeOut,
                  child: SizedBox(
                    width: w,
                    height: h,
                    child: Stack(
                      children: [
                        // Ambient background circle
                        Positioned(
                          top: h * 0.08,
                          left: w * 0.5 - contentWidth * 0.42,
                          child: ScaleTransition(
                            scale: _circleScale,
                            child: Container(
                              width: contentWidth * 0.84,
                              height: contentWidth * 0.84,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _circle.withValues(alpha: 0.6),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Main content
                        Center(
                          child: SizedBox(
                            width: contentWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: h * 0.04),

                                // Logo mark
                                FadeTransition(
                                  opacity: _logoFade,
                                  child: SlideTransition(
                                    position: _logoSlide,
                                    child: _LogoMark(size: contentWidth * 0.28),
                                  ),
                                ),

                                SizedBox(height: h * 0.038),

                                // Brand name + subtitle
                                FadeTransition(
                                  opacity: _textFade,
                                  child: SlideTransition(
                                    position: _textSlide,
                                    child: Column(
                                      children: [
                                        Text(
                                          appName.toUpperCase(),
                                          style: _ts(
                                            fontSize: contentWidth * 0.115,
                                            color: _dark,
                                            letterSpacing: contentWidth * 0.022,
                                            height: 1,
                                          ),
                                        ),
                                        SizedBox(height: h * 0.012),
                                        Container(
                                          width: contentWidth * 0.3,
                                          height: 1,
                                          color: _gold,
                                        ),
                                        SizedBox(height: h * 0.014),
                                        Text(
                                          tagLine.toUpperCase(),
                                          style: _ts(
                                            fontSize: contentWidth * 0.032,
                                            color: _olive,
                                            letterSpacing: contentWidth * 0.014,
                                            height: 1,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(height: h * 0.055),

                                // Tagline — from database
                                FadeTransition(
                                  opacity: _subTitleFade,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: contentWidth * 0.1),
                                    child: Text(
                                      subTitle,
                                      textAlign: TextAlign.center,
                                      style: _ts(
                                        fontSize: contentWidth * 0.042,
                                        fontStyle: FontStyle.italic,
                                        color: _dark.withValues(alpha: 0.75),
                                        height: 1.55,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: h * 0.06),

                                // Enter button
                                FadeTransition(
                                  opacity: _buttonFade,
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: _navigateToNext,
                                      child: Container(
                                        width: contentWidth * 0.48,
                                        height: h * 0.062,
                                        decoration: BoxDecoration(
                                          color: _dark,
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'ENTER',
                                          style: _ts(
                                            fontSize: contentWidth * 0.038,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            letterSpacing: contentWidth * 0.018,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: h * 0.032),

                                // Swipe hint
                                FadeTransition(
                                  opacity: _swipeFade,
                                  child: Column(
                                    children: [
                                      Text(
                                        'or swipe up',
                                        style: _ts(
                                          fontSize: contentWidth * 0.03,
                                          fontStyle: FontStyle.italic,
                                          color: _muted,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                      SizedBox(height: h * 0.008),
                                      AnimatedBuilder(
                                        animation: _arrowBounce,
                                        builder: (context, child) =>
                                            Transform.translate(
                                              offset: Offset(0, _arrowBounce.value),
                                              child: child,
                                            ),
                                        child: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: _olive,
                                          size: contentWidth * 0.06,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // EST. footer
                        Positioned(
                          bottom: h * 0.045,
                          left: 0,
                          right: 0,
                          child: FadeTransition(
                            opacity: _swipeFade,
                            child: Text(
                              'EST. 2026  ·  PARIS',
                              textAlign: TextAlign.center,
                              style: _ts(
                                fontSize: contentWidth * 0.028,
                                color: _muted.withValues(alpha: 0.7),
                                letterSpacing: contentWidth * 0.012,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ── Logo Mark Widget ──────────────────────────────────────────────────────────

class _LogoMark extends StatelessWidget {
  final double size;
  _LogoMark({required this.size});

  Color _olive = AppColors.get(appColors.accent_success);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _LogoMarkPainter(),
        child: Center(
          child: Text(
            'L',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontFamilyFallback: const ['Times New Roman', 'serif'],
              fontSize: size * 0.42,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
              color: _olive,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoMarkPainter extends CustomPainter {
  Color _olive = AppColors.get(appColors.accent_success);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _olive.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.46;
    final innerR = size.width * 0.38;

    // Outer circle
    canvas.drawCircle(Offset(cx, cy), r, paint);

    // Inner circle
    paint.strokeWidth = 0.5;
    canvas.drawCircle(Offset(cx, cy), innerR, paint);

    // Cross lines
    final linePaint = Paint()
      ..color = _olive.withValues(alpha: 0.4)
      ..strokeWidth = 0.6;

    canvas.drawLine(Offset(cx - r, cy), Offset(cx + r, cy), linePaint);
    canvas.drawLine(Offset(cx, cy - r), Offset(cx, cy + r), linePaint);

    // Diamond markers at NESW
    _drawDiamond(canvas, Offset(cx, cy - r), size.width * 0.04, _olive);
    _drawDiamond(canvas, Offset(cx, cy + r), size.width * 0.04, _olive);
    _drawDiamond(canvas, Offset(cx - r, cy), size.width * 0.04, _olive);
    _drawDiamond(canvas, Offset(cx + r, cy), size.width * 0.04, _olive);
  }

  void _drawDiamond(Canvas canvas, Offset center, double half, Color color) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(center.dx, center.dy - half)
      ..lineTo(center.dx + half * 0.55, center.dy)
      ..lineTo(center.dx, center.dy + half)
      ..lineTo(center.dx - half * 0.55, center.dy)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}