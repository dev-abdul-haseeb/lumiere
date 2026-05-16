import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../blocs/application/application_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../routers/views.dart';

// Lumière palette
class _C {
  static const dark       = Color(0xFF2C2C2C);
  static const cream      = Color(0xFFF5F0E8);
  static const card       = Color(0xFFFAF7F2);
  static const border     = Color(0xFFD4CFC7);
  static const gold       = Color(0xFFC9A96E);
  static const olive      = Color(0xFF6B7C4A);
  static const sidebar    = Color(0xFF2C2C2C);
}

// Nav destinations
enum _Dest { home, cart, orders, profile }

extension _DestX on _Dest {
  String get label {
    switch (this) {
      case _Dest.home:    return 'Main Menu';
      case _Dest.cart:    return 'Cart';
      case _Dest.orders:  return 'Orders';
      case _Dest.profile: return 'Profile';
    }
  }

  IconData get icon {
    switch (this) {
      case _Dest.home:    return Icons.storefront_outlined;
      case _Dest.cart:    return Icons.shopping_bag_outlined;
      case _Dest.orders:  return Icons.receipt_long_outlined;
      case _Dest.profile: return Icons.person_outline;
    }
  }

  IconData get iconFilled {
    switch (this) {
      case _Dest.home:    return Icons.storefront;
      case _Dest.cart:    return Icons.shopping_bag;
      case _Dest.orders:  return Icons.receipt_long;
      case _Dest.profile: return Icons.person;
    }
  }
}

const double _kSidebarBreak = 720;
const double _kSidebarWidth = 220;

// ════════════════════════════════════════════════════════════════════
//  BuyerHomeScreen
// ════════════════════════════════════════════════════════════════════
class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key});

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  _Dest _selected = _Dest.home;

  late final Map<_Dest, Widget> _screens = {
    _Dest.home:    const BuyerMainMenuScreen(),
    _Dest.cart:    const BuyerCartScreen(),
    _Dest.orders:  const BuyerOrdersScreen(),
    _Dest.profile: const BuyerProfileScreen(),
  };

  void _select(_Dest dest) {
    setState(() => _selected = dest);
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  // ── Helpers to read blocs ──────────────────────────────────────────

  /// Returns (appName, appSubtitle) from ApplicationBloc,
  /// falling back to hardcoded strings if not yet loaded.
  (String, String) _appInfo(ApplicationState appState) {
    if (appState is ApplicationLoaded) {
      return (appState.application.name, appState.application.tagLine);
    }
    return ('LUMIÈRE', 'LUXURY SKINCARE');
  }

  /// Returns (initials, displayName, role) from AuthBloc.
  (String, String, String) _userInfo(AuthState authState) {
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      final firstName = user.first_name.trim();
      final lastName  = user.last_name.trim();

      final displayName = (firstName.isNotEmpty || lastName.isNotEmpty)
          ? '$firstName $lastName'.trim()
          : user.email;

      final initials = [
        if (firstName.isNotEmpty) firstName[0],
        if (lastName.isNotEmpty)  lastName[0],
      ].join().toUpperCase();

      final role = user.is_admin ? 'Admin' : 'Member';
      return (initials.isNotEmpty ? initials : 'U', displayName, role);
    }
    return ('U', 'Guest User', 'Member');
  }

  // ── AppBar (mobile) ────────────────────────────────────────────────
  AppBar _appBar(String appName, String appSubtitle) => AppBar(
    backgroundColor: _C.dark,
    elevation: 0,
    surfaceTintColor: Colors.transparent,
    iconTheme: const IconThemeData(color: _C.cream),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(appName.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 15, fontWeight: FontWeight.w500,
            letterSpacing: 3.5, color: _C.card,
          ),
        ),
        Text(appSubtitle.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 10, fontWeight: FontWeight.w400,
            letterSpacing: 2.5, color: _C.gold,
          ),
        ),
      ],
    ),
  );

  // ── Sidebar ────────────────────────────────────────────────────────
  Widget _sidebar({
    required String appName,
    required String appSubtitle,
    required String initials,
    required String displayName,
    required String role,
  }) =>
      Container(
        width: _kSidebarWidth,
        color: _C.sidebar,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo block
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 48, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appName.toUpperCase(),
                    style: GoogleFonts.dmSans(
                      fontSize: 16, fontWeight: FontWeight.w500,
                      letterSpacing: 3.5, color: _C.cream,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(appSubtitle.toUpperCase(),
                    style: GoogleFonts.dmSans(
                      fontSize: 10, fontWeight: FontWeight.w400,
                      letterSpacing: 2.5,
                      color: _C.gold,
                    ),
                  ),
                ],
              ),
            ),

            // Section label
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: Text('MAIN MENU',
                style: GoogleFonts.dmSans(
                  fontSize: 9, fontWeight: FontWeight.w500,
                  letterSpacing: 2.0,
                  color: _C.cream.withOpacity(0.35),
                ),
              ),
            ),

            // Nav items
            ..._Dest.values.map((d) => _SidebarItem(
              dest: d,
              selected: _selected == d,
              onTap: () => _select(d),
            )),

            const Spacer(),

            // Divider above footer
            Divider(
              height: 1, thickness: 1,
              color: _C.cream.withOpacity(0.08),
              indent: 16, endIndent: 16,
            ),
            const SizedBox(height: 8),

            // User footer
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: _C.gold.withOpacity(0.25),
                    child: Text(initials,
                      style: GoogleFonts.dmSans(
                        fontSize: 13, fontWeight: FontWeight.w600,
                        color: _C.gold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(displayName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.dmSans(
                            fontSize: 12, fontWeight: FontWeight.w500,
                            color: _C.cream,
                          ),
                        ),
                        Text(role,
                          style: GoogleFonts.dmSans(
                            fontSize: 10, fontWeight: FontWeight.w400,
                            color: _C.cream.withOpacity(0.45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  // ── Drawer (mobile) ────────────────────────────────────────────────
  Drawer _drawer({
    required String appName,
    required String appSubtitle,
    required String initials,
    required String displayName,
    required String role,
  }) =>
      Drawer(
        backgroundColor: _C.card,
        width: _kSidebarWidth,
        child: _sidebar(
          appName: appName,
          appSubtitle: appSubtitle,
          initials: initials,
          displayName: displayName,
          role: role,
        ),
      );

  // ── Build ──────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ApplicationBloc, ApplicationState>(
      builder: (context, appState) {
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            final (appName, appSubtitle) = _appInfo(appState);
            final (initials, displayName, role) = _userInfo(authState);

            final width      = MediaQuery.of(context).size.width;
            final useSidebar = width >= _kSidebarBreak;
            final body       = _screens[_selected]!;

            final sidebarWidget = _sidebar(
              appName: appName,
              appSubtitle: appSubtitle,
              initials: initials,
              displayName: displayName,
              role: role,
            );

            if (useSidebar) {
              return Scaffold(
                backgroundColor: _C.cream,
                body: Row(
                  children: [
                    sidebarWidget,
                    const VerticalDivider(
                      width: 1, thickness: 1,
                      color: Color(0xFFE8E3DA),
                    ),
                    Expanded(child: body),
                  ],
                ),
              );
            } else {
              return Scaffold(
                backgroundColor: _C.cream,
                appBar: _appBar(appName, appSubtitle),
                drawer: _drawer(
                  appName: appName,
                  appSubtitle: appSubtitle,
                  initials: initials,
                  displayName: displayName,
                  role: role,
                ),
                body: body,
              );
            }
          },
        );
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════
//  _SidebarItem
// ════════════════════════════════════════════════════════════════════
class _SidebarItem extends StatelessWidget {
  final _Dest dest;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.dest,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? _C.olive.withOpacity(0.30) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: selected
              ? Border.all(color: _C.olive.withOpacity(0.40), width: 1)
              : null,
        ),
        child: Row(
          children: [
            Icon(
              selected ? dest.iconFilled : dest.icon,
              size: 18,
              color: selected ? _C.gold : _C.cream.withOpacity(0.65),
            ),
            const SizedBox(width: 12),
            Text(
              dest.label,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: selected ? _C.cream : _C.cream.withOpacity(0.65),
                letterSpacing: 0.3,
              ),
            ),
            if (selected) ...[
              const Spacer(),
              Container(
                width: 4, height: 4,
                decoration: const BoxDecoration(
                  color: _C.gold,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}