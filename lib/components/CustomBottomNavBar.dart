// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../extras/CustomerScreen.dart';
import '../extras/ProShopScreen.dart';
import '../extras/SettingsScreen.dart';
import '../extras/TransactionScreen.dart';
import '../screens/TeaSheet.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int>? onTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    this.onTap,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String memberName = '';

  final List<Map<String, dynamic>> items = [
    {'icon': Icons.receipt_long_outlined, 'label': 'Transaction'},
    {'icon': Icons.shopping_cart_outlined, 'label': 'Pro Shop'},
    {'icon': Icons.list_alt_outlined, 'label': 'Tea Sheet'},
    {'icon': Icons.people_outline_rounded, 'label': 'Customers'},
    {'icon': Icons.settings_outlined, 'label': 'Settings'},
  ];

  // ── Handles tab navigation with a smooth fade transition ──
  // Lives here (inside the State class) so it has access to
  // `widget` and `context` automatically — no manual declaration needed.
  void _navigateTo(int index) {
    if (index == widget.selectedIndex) return;

    Widget screen;

    switch (index) {
      case 0:
        screen = TransactionScreen(userId: '');
        break;
      case 1:
        screen = ProshopScreen(userId: '');
        break;
      case 2:
        screen = TeaSheet(userId: '');
        break;
      case 3:
        screen = CustomerScreen(userId: '');
        break;
      case 4:
        screen = SettingScreen(userId: '');
        break;
      default:
        screen = TeaSheet(userId: '');
    }

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        reverseTransitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (_, animation, secondaryAnimation) => screen,
        transitionsBuilder: (
            context,
            animation,
            secondaryAnimation,
            child,
            ) {
          const begin = Offset(0.08, 0.0);
          const end = Offset.zero;

          final slideAnimation = Tween(
            begin: begin,
            end: end,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          );

          final fadeAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          );

          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadMemberName();
  }

  Future<void> _loadMemberName() async {
    final storedName = await secureStorage.read(key: 'user_name');
    if (!mounted) return;
    setState(() => memberName = storedName ?? 'Guest');
  }

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).padding.bottom;

    // ── Sizing tokens ──
    const double barHeight = 68.0;
    const double circleRadius = 28.0;
    const double notchMargin = 0;
    const double circleElevation = 0;
    const double iconSize = 24.0;
    const double activeIconSize = 28.0;
    const double labelFontSize = 15;
    const double activeLabelFontSize = 15;

    final double totalHeight =
        barHeight + circleElevation + circleRadius + bottomPadding;

    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double totalWidth = constraints.maxWidth;
          final double itemWidth = totalWidth / items.length;
          final double activeCenter =
              itemWidth * widget.selectedIndex + itemWidth / 2;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              // ── 1. Notched green bar ──
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: barHeight + bottomPadding,
                child: ClipPath(
                  clipper: NotchedClipper(
                    activeCenter: activeCenter,
                    notchRadius: circleRadius + notchMargin,
                    totalWidth: totalWidth,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFA4C49F),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),

              // ── 2. Drop shadow behind the bar ──
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: barHeight + bottomPadding,
                child: CustomPaint(
                  painter: NotchedShadowPainter(
                    activeCenter: activeCenter,
                    notchRadius: circleRadius + notchMargin,
                    barHeight: barHeight + bottomPadding,
                    totalWidth: totalWidth,
                  ),
                ),
              ),

              // ── 3. Tab items ──
              Positioned(
                bottom: bottomPadding,
                left: 0,
                right: 0,
                height: barHeight,
                child: Row(
                  children: List.generate(items.length, (index) {
                    final bool isSelected = index == widget.selectedIndex;

                    return Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          if (widget.onTap != null) {
                            widget.onTap!(index);
                          } else {
                            _navigateTo(index);
                          }
                        },
                        child: isSelected
                            ? const SizedBox.shrink()
                            : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              items[index]['icon'] as IconData,
                              size: iconSize,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              items[index]['label'] as String,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                fontSize: labelFontSize,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // ── 4. Floating active circle ──
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutCubic,
                bottom:
                barHeight + bottomPadding + circleElevation - circleRadius,
                left: activeCenter - circleRadius,
                width: circleRadius * 2,
                height: circleRadius * 2,
                child: GestureDetector(
                  onTap: () {
                    if (widget.onTap != null) {
                      widget.onTap!(widget.selectedIndex);
                    }
                  },
                  child: Container(
                    decoration:  BoxDecoration(
                      color: Color(0xFF799C74),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD0E8CE),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF799C74).withOpacity(0.30),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 350),
                      tween: Tween(begin: 0.85, end: 1),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: child,
                        );
                      },
                      child: Icon(
                        items[widget.selectedIndex]['icon'] as IconData,
                        size: activeIconSize,
                        color: Colors.white,
                      ),
                    )
                  ),
                ),
              ),

              // ── 5. Active label inside bar ──
              Positioned(
                bottom: bottomPadding + 8,
                left: activeCenter - itemWidth / 2,
                width: itemWidth,
                child: Text(
                  items[widget.selectedIndex]['label'] as String,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: activeLabelFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Clips a smooth circular notch at the top of the bar ──
class NotchedClipper extends CustomClipper<Path> {
  final double activeCenter;
  final double notchRadius;
  final double totalWidth;

  NotchedClipper({
    required this.activeCenter,
    required this.notchRadius,
    required this.totalWidth,
  });

  @override
  Path getClip(Size size) {
    const double cornerRadius = 20.0;
    const double notchSweepExtra = 10.0;

    final Path path = Path();

    path.moveTo(cornerRadius, 0);

    final double notchLeft = activeCenter - notchRadius - notchSweepExtra;
    final double notchRight = activeCenter + notchRadius + notchSweepExtra;

    path.lineTo(notchLeft, 0);

    path.arcToPoint(
      Offset(notchRight, 0),
      radius: Radius.circular(notchRadius + notchSweepExtra * 0.5),
      clockwise: false,
    );

    path.lineTo(size.width - cornerRadius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(NotchedClipper oldClipper) =>
      oldClipper.activeCenter != activeCenter;
}

// ── Paints the shadow beneath the notched bar shape ──
class NotchedShadowPainter extends CustomPainter {
  final double activeCenter;
  final double notchRadius;
  final double barHeight;
  final double totalWidth;

  NotchedShadowPainter({
    required this.activeCenter,
    required this.notchRadius,
    required this.barHeight,
    required this.totalWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // intentionally empty — shadow handled by circle widget itself
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}