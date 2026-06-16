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

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
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
    const double barHeight = 102.0;
    const double circleRadius = 40.0; // radius of the floating circle
    const double notchMargin = 0;
    const double circleElevation = 0; // how high circle floats above bar top

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

              // ── 2. Drop shadow behind the bar (drawn separately so notch shadow works) ──
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
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    items[index]['label'] as String,
                                    textAlign: TextAlign.center,
                                    style:  GoogleFonts.nunito(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400,
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
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
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
                    decoration: BoxDecoration(
                      color: Color(0xFF799C74),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD0E8CE),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      items[widget.selectedIndex]['icon'] as IconData,
                      size: 50,
                      color:  Colors.white,
                    ),
                  ),
                ),
              ),

              // ── 5. Active label inside bar ──
              Positioned(
                bottom: bottomPadding + 10,
                left: activeCenter - itemWidth / 2,
                width: itemWidth,
                child: Text(
                  items[widget.selectedIndex]['label'] as String,
                  textAlign: TextAlign.center,
                  style:  GoogleFonts.nunito(
                    fontSize: 24,
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
    const double notchSweepExtra = 18.0; // extra width around notch curve

    final Path path = Path();

    // Start top-left corner
    path.moveTo(cornerRadius, 0);

    // Top edge going right until notch start
    final double notchLeft = activeCenter - notchRadius - notchSweepExtra;
    final double notchRight = activeCenter + notchRadius + notchSweepExtra;

    path.lineTo(notchLeft, 0);

    // Arc downward for the notch (semicircle dip)
    path.arcToPoint(
      Offset(notchRight, 0),
      radius: Radius.circular(notchRadius + notchSweepExtra * 0.5),
      clockwise: false,
    );

    // Continue to top-right
    path.lineTo(size.width - cornerRadius, 0);

    // Top-right rounded corner
    path.quadraticBezierTo(size.width, 0, size.width, cornerRadius);

    // Right edge down
    path.lineTo(size.width, size.height);

    // Bottom edge
    path.lineTo(0, size.height);

    // Left edge up
    path.lineTo(0, cornerRadius);

    // Top-left rounded corner
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
    // Add custom shadow logic here if needed
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
