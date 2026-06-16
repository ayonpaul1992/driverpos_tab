// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback? onBackPressed;
  final VoidCallback? onTitleTapped;
  final String userId;
  final bool showLeading;
  final bool isOnProfilePage;

  const CustomAppBar({
    super.key,
    required this.scaffoldKey,
    required this.userId,
    this.onBackPressed,
    this.onTitleTapped,
    this.showLeading = true,
    this.isOnProfilePage = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.black12,
      automaticallyImplyLeading: false,
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: 0,
      toolbarHeight: 72,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 16),

          // Logo
          SizedBox(
            width: 74,
            height: 35,
            child: Image.asset(
              'assets/images/drvrpos_tablogo.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 12),

          // Course name + arrow
          GestureDetector(
            onTap: onTitleTapped ?? () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 29,
                  height: 29,
                  child: Image.asset(
                    'assets/images/drvrpos_tabflg.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'Salt Lake Golf Course',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF244065),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF244065),
                  size: 24,
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Tee sheet pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD0D5DD)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Tee sheet',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color(0xFF244065),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF244065),
                  size: 22,
                ),
              ],
            ),
          ),

          const Spacer(),

          // Date pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD0D5DD)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 17,
                  color: Color(0xFF244065),
                ),
                const SizedBox(width: 6),
                Text(
                  'Fri, May 29',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color(0xFF244065),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Time
          Text(
            '01:21 PM',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF244065),
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(width: 12),

          // Weather
          const Icon(Icons.wb_sunny_rounded, color: Colors.amber, size: 22),
          const SizedBox(width: 4),
          Text(
            'F',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xFF244065),
            ),
          ),

          const SizedBox(width: 12),
          const Icon(Icons.edit_outlined, color: Color(0xFF244065), size: 22),
          const SizedBox(width: 12),
          const Icon(
            Icons.open_in_new_rounded,
            color: Color(0xFF244065),
            size: 22,
          ),
          const SizedBox(width: 12),
          const Icon(Icons.refresh_rounded, color: Color(0xFF244065), size: 22),
          const SizedBox(width: 14),

          // Avatar + name
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF9ECF9A),
                  child: Text(
                    'D',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dev',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF244065),
                      ),
                    ),
                    Text(
                      'Admin',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Color(0xFF244065),
                  size: 22,
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72);
}
