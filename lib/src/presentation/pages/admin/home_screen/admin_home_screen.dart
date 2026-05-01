import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumiere/src/core/theme/theme.dart';
import 'package:lumiere/src/core/enum/enum.dart';
import 'package:lumiere/src/presentation/blocs/auth/auth_bloc.dart';

import '../../../routers/views.dart';

// PALETTE  (mirrors AppColors — kept local so this file is self-contained)
class _C {
  static Color bg      = AppColors.get(appColors.background);
  static Color dark    = AppColors.get(appColors.primary_action);
  static Color olive   = AppColors.get(appColors.accent_success);
  static Color gold    = AppColors.get(appColors.highlight);
  static Color card    = AppColors.get(appColors.card);
  static Color border  = AppColors.get(appColors.border);
  static Color sidebar = AppColors.get(appColors.sidebar_bg);
  static Color activeNav = AppColors.get(appColors.active_nav_item);

  // status colours
  static const shipped   = Color(0xFF6B7C4A);
  static const pending   = Color(0xFFC9A96E);
  static const delivered = Color(0xFF27500A);
  static const cancelled = Color(0xFF791F1F);
  static const muted     = Color(0xFF8A8070);
}

// DATA MODELS

class StatCardData {
  final String label;
  final String value;
  final String subtitle;
  final bool   subtitleIsWarning;
  const StatCardData({
    required this.label,
    required this.value,
    required this.subtitle,
    this.subtitleIsWarning = false,
  });
}

class RecentOrder {
  final String id;
  final String customer;
  final String product;
  final String total;
  final String status; // 'Shipped' | 'Pending' | 'Delivered' | 'Cancelled'
  const RecentOrder({
    required this.id,
    required this.customer,
    required this.product,
    required this.total,
    required this.status,
  });
}

class TopSeller {
  final String name;
  final String sold;
  final Color  avatarColor;
  const TopSeller({required this.name, required this.sold, required this.avatarColor});
}

class WeekBar {
  final String label;
  final double revenue; // 0–1 normalised
  final double orders;  // 0–1 normalised
  const WeekBar({required this.label, required this.revenue, required this.orders});
}

String fetchAdminRole() => 'Super Admin';

String fetchGreeting() {
  final h = DateTime.now().hour;
  if (h < 12) return 'Good morning';
  if (h < 17) return 'Good afternoon';
  return 'Good evening';
}

String fetchDateString() {
  final now = DateTime.now();
  const days   = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
  const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
  return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day} · ${now.year}';
}

// NAV ITEMS
class _NavItem {
  final IconData icon;
  final String   label;
  const _NavItem(this.icon, this.label);
}

const _navItems = [
  _NavItem(Icons.grid_view_rounded,       'Dashboard'),
  _NavItem(Icons.receipt_long_outlined,   'Orders'),
  _NavItem(Icons.inventory_2_outlined,    'Products'),
  _NavItem(Icons.people_outline_rounded,  'Customers'),
  _NavItem(Icons.settings_outlined,       'Settings'),
];

// BREAKPOINTS
const double _kSidebarBreakpoint = 800;

// ADMIN HOME SCREEN

class AdminHomeScreen extends StatefulWidget {
  final String admin_name;
  const AdminHomeScreen({super.key, required this.admin_name});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedNav = 0;

  final screens = [
    AdminDashboardScreen(),
    AdminOrdersScreen(),
    AdminProductsScreen(),
    AdminCustomersScreen(),
    AdminSettingsScreen(),
  ];

  final String _adminRole = fetchAdminRole();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= _kSidebarBreakpoint;

        if (isWide) {
          return Scaffold(
            backgroundColor: _C.bg,
            body: Row(
              children: [
                _Sidebar(
                  selectedIndex: _selectedNav,
                  adminName: widget.admin_name,
                  adminRole: _adminRole,
                  onNavTap: (i) => setState(() => _selectedNav = i),
                ),
                Expanded(
                  child: screens[_selectedNav],
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            backgroundColor: _C.bg,
            drawer: _SidebarDrawer(
              selectedIndex: _selectedNav,
              adminName: widget.admin_name,
              adminRole: _adminRole,
              onNavTap: (i) {
                setState(() => _selectedNav = i);
                Navigator.pop(context);
              },
            ),
            appBar: _MobileAppBar(),
            body: screens[_selectedNav],
          );
        }
      },
    );
  }
}

// MOBILE APP BAR

class _MobileAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: _C.bg,
      elevation: 0,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: Icon(Icons.menu_rounded, color: _C.dark),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      title: Text('LUMIÈRE',
          style: GoogleFonts.dmSans(
            fontSize: 14, fontWeight: FontWeight.w600,
            color: _C.dark, letterSpacing: 3,
          )),
      actions: [
        _NotificationBell(),
        const SizedBox(width: 12),
      ],
    );
  }
}

// SIDEBAR (persistent)

class _Sidebar extends StatelessWidget {
  final int selectedIndex;
  final String adminName;
  final String adminRole;
  final ValueChanged<int> onNavTap;
  const _Sidebar({
    required this.selectedIndex, required this.adminName,
    required this.adminRole,     required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 188,
      color: _C.sidebar,
      child: _SidebarContent(
        selectedIndex: selectedIndex,
        adminName: adminName,
        adminRole: adminRole,
        onNavTap: onNavTap,
      ),
    );
  }
}

// SIDEBAR (drawer — mobile)

class _SidebarDrawer extends StatelessWidget {
  final int selectedIndex;
  final String adminName;
  final String adminRole;
  final ValueChanged<int> onNavTap;
  const _SidebarDrawer({
    required this.selectedIndex, required this.adminName,
    required this.adminRole,     required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: _C.sidebar,
      child: _SidebarContent(
        selectedIndex: selectedIndex,
        adminName: adminName,
        adminRole: adminRole,
        onNavTap: onNavTap,
      ),
    );
  }
}

// SIDEBAR CONTENT (shared)

class _SidebarContent extends StatelessWidget {
  final int selectedIndex;
  final String adminName;
  final String adminRole;
  final ValueChanged<int> onNavTap;
  const _SidebarContent({
    required this.selectedIndex, required this.adminName,
    required this.adminRole,     required this.onNavTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo
        const SizedBox(height: 36),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('LUMIÈRE',
                  style: GoogleFonts.dmSans(
                    fontSize: 15, fontWeight: FontWeight.w600,
                    color: Colors.white, letterSpacing: 3.5,
                  )),
              const SizedBox(height: 3),
              Text('ADMIN PANEL',
                  style: GoogleFonts.dmSans(
                    fontSize: 9, fontWeight: FontWeight.w400,
                    color: _C.gold, letterSpacing: 2.5,
                  )),
            ],
          ),
        ),
        const SizedBox(height: 36),

        // Nav items
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: _navItems.length,
            itemBuilder: (_, i) {
              final item     = _navItems[i];
              final isActive = i == selectedIndex;
              return MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => onNavTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    decoration: BoxDecoration(
                      color: isActive ? _C.activeNav : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(item.icon, size: 17,
                            color: isActive ? Colors.white : Colors.white38),
                        const SizedBox(width: 11),
                        Text(item.label,
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                              color: isActive ? Colors.white : Colors.white60,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Admin profile
        Column(
          children: [
            // Logout button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => context.read<AuthBloc>().add(AuthLogOut()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.logout_rounded, size: 17, color: Colors.white38),
                        const SizedBox(width: 11),
                        Text('Logout',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Colors.white60,
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Admin profile
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: _C.activeNav,
                    child: Text(adminName[0],
                        style: GoogleFonts.dmSans(
                          fontSize: 13, fontWeight: FontWeight.w600,
                          color: Colors.white,
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(adminName,
                            style: GoogleFonts.dmSans(
                              fontSize: 12, fontWeight: FontWeight.w600,
                              color: Colors.white,
                            )),
                        Text(adminRole,
                            style: GoogleFonts.dmSans(
                              fontSize: 10, color: _C.gold,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _NotificationBell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: _C.card,
            shape: BoxShape.circle,
            border: Border.all(color: _C.border),
          ),
          child: Icon(Icons.notifications_none_rounded, size: 18, color: _C.dark),
        ),
        Positioned(
          top: -2, right: -2,
          child: Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              color: _C.gold,
              shape: BoxShape.circle,
              border: Border.all(color: _C.bg, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}