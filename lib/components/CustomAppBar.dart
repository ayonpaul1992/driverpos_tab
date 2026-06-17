// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
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
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(72);
}

class _CustomAppBarState extends State<CustomAppBar> {
  String selectedCourse = "Salt Lake Golf Course";
  String selectedTeeSheet = "Tee sheet";
  bool isCourseMenuOpen = false;
  bool isTeeSheetMenuOpen = false;
  bool isProfileMenuOpen = false;
  bool isClockedIn = false;
  Map<int, bool> employeeClockStatus = {};
  final TextEditingController employeeController =
  TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool obscurePin = true;
  bool autoValidate = false;
  List<Employee> employees = [
    Employee(employeeId: 1, employeeName: "Arkaprava Bera"),
    Employee(employeeId: 2, employeeName: "John Doe"),
    Employee(employeeId: 3, employeeName: "David Smith"),
    Employee(employeeId: 4, employeeName: "Robert Johnson"),
  ];
  Employee? selectedEmployee;
  bool showTimeClockActions = false;

  PopupMenuItem<String> buildCourseItem(String course) {
    final isSelected = selectedCourse == course;

    return PopupMenuItem<String>(
      value: course,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: isSelected ? const Color(0xFFEAF3E7) : Colors.transparent,
        child: Text(
          course,
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: const Color(0xFF244065),
          ),
        ),
      ),
    );
  }

  final Map<String, List<String>> teeSheetOptions = {
    "Eden Gardens Golf Course": [
      "Morning Tee Sheet",
      "Afternoon Tee Sheet",
      "Weekend Tee Sheet",
    ],
    "Greater Kolkata Golf Course": [
      "Member Tee Sheet",
      "Guest Tee Sheet",
      "Tournament Tee Sheet",
    ],
    "Salt Lake Golf Course": [
      "Regular Tee Sheet",
      "VIP Tee Sheet",
      "Practice Tee Sheet",
    ],
  };

  PopupMenuItem<String> buildProfileMenuItem({
    required String value,
    required String title,
  }) {
    return PopupMenuItem<String>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF9ECF9A),
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.nunito(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  void showTopMessage(
      BuildContext context,
      String message,
      ) {
    final overlay = Overlay.of(context);

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 30,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E),
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  DateTime now = DateTime.now();
  Timer? timer;

  String weatherText = "°F";
  IconData weatherIcon = Icons.wb_sunny_rounded;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

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
            width: 108,
            height: 87,
            child: Image.asset(
              'assets/images/drvrpos_tablogo.png',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(width: 20),

          // Course name + arrow
          Row(
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

              PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                offset: const Offset(-30, 45), // move dropdown downward

                onOpened: () {
                  setState(() {
                    isCourseMenuOpen = true;
                  });
                },

                onCanceled: () {
                  setState(() {
                    isCourseMenuOpen = false;
                  });
                },

                onSelected: (value) {
                  setState(() {
                    selectedCourse = value;

                    selectedTeeSheet = teeSheetOptions[value]!.first;

                    isCourseMenuOpen = false;
                  });
                },

                itemBuilder: (context) => [
                  buildCourseItem("Eden Gardens Golf Course"),
                  buildCourseItem("Greater Kolkata Golf Course"),
                  buildCourseItem("Salt Lake Golf Course"),
                ],

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      selectedCourse,
                      style: GoogleFonts.nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF244065),
                      ),
                    ),
                    Icon(
                      isCourseMenuOpen
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: const Color(0xFF244065),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          // Tee sheet pill
          PopupMenuButton<String>(
            offset: const Offset(0, 45),

            onOpened: () {
              setState(() {
                isTeeSheetMenuOpen = true;
              });
            },

            onCanceled: () {
              setState(() {
                isTeeSheetMenuOpen = false;
              });
            },

            onSelected: (value) {
              setState(() {
                selectedTeeSheet = value;
                isTeeSheetMenuOpen = false;
              });
            },

            itemBuilder: (context) {
              final items = teeSheetOptions[selectedCourse] ?? [];

              return items.map((item) {
                final isSelected = item == selectedTeeSheet;

                return PopupMenuItem<String>(
                  value: item,
                  padding: EdgeInsets.zero,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    color: isSelected
                        ? const Color(0xFFEAF3E7)
                        : Colors.transparent,
                    child: Text(
                      item,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: const Color(0xFF244065),
                      ),
                    ),
                  ),
                );
              }).toList();
            },

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F3F3),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedTeeSheet,
                    style: GoogleFonts.nunito(
                      fontSize: 17,
                      color: const Color(0xFF212529),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),

                  Icon(
                    isTeeSheetMenuOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF212529),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Date pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Color(0xFFEDF3EC),
              border: Border.all(color: const Color(0xFFD0D5DD)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 20,
                  color: Color(0xFF799C74),
                ),
                const SizedBox(width: 6),
                Text(
                  DateFormat('EEE, MMM d').format(now),
                  style: GoogleFonts.nunito(
                    fontSize: 17,
                    color: const Color(0xFF212529),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 18),
                // Time
                Text(
                  DateFormat('hh:mm a').format(now),
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    color: const Color(0xFF212529),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Weather
          GestureDetector(
            onTap: () {
              // Future: Open weather details screen/dialog
              print("Weather clicked");
            },
            child: Container(
              // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              // decoration: BoxDecoration(
              //   color: const Color(0xFFF3F3F3),
              //   borderRadius: BorderRadius.circular(6),
              //   border: Border.all(color: const Color(0xFFE5E7EB)),
              // ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(weatherIcon, color: Colors.amber, size: 22),
                  const SizedBox(width: 6),
                  Text(
                    weatherText,
                    style: GoogleFonts.nunito(
                      fontSize: 17,
                      color: const Color(0xFF212529),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.edit_outlined, color: Color(0xFF244065), size: 22),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              print("Open in new clicked");

              // Future:
              // launch URL
              // open screen
              // open dialog
            },
            child: Container(
              child: const Icon(
                Icons.open_in_new_rounded,
                color: Color(0xFF244065),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              print("Refresh clicked");

              // Future:
              // Reload data
              // Refresh API
              // Refresh page
            },
            child: Container(
              child: const Icon(
                Icons.refresh_rounded,
                color: Color(0xFF244065),
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Avatar + name
          PopupMenuButton<String>(
            offset: const Offset(0, 60),
            color: Colors.white,
            elevation: 4,

            constraints: const BoxConstraints(minWidth: 210, maxWidth: 210),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),

            onOpened: () {
              setState(() {
                isProfileMenuOpen = true;
              });
            },

            onCanceled: () {
              setState(() {
                isProfileMenuOpen = false;
              });
            },

            onSelected: (value) {
              setState(() {
                isProfileMenuOpen = false;
              });

              switch (value) {
                case "verify_pin":
                  print("Verify Pin");
                  _showVerifyPinPopup(context);
                  break;

                case "time_clock":
                  print("Time Clock");
                  _showTimeClockPopup(context);
                  break;

                case "cash_register":
                  print("Cash Register");
                  break;

                case "logout":
                  print("Logout");
                  break;
              }
            },

            itemBuilder: (context) => [
              buildProfileMenuItem(value: "verify_pin", title: "Verify Pin"),

              buildProfileMenuItem(value: "time_clock", title: "Time clock"),

              buildProfileMenuItem(
                value: "cash_register",
                title: "Cash Register",
              ),

              buildProfileMenuItem(value: "logout", title: "Logout"),
            ],

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF9ECF9A),
                  child: Icon(
                    Icons.person_outline,
                    color: Colors.white,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 7),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dev',
                      style: GoogleFonts.nunito(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212529),
                      ),
                    ),
                    Text(
                      'Admin',
                      style: GoogleFonts.nunito(
                        fontSize: 17,
                        color: const Color(0xFF212529),
                      ),
                    ),
                  ],
                ),

                Icon(
                  isProfileMenuOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: const Color(0xFF212529),
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

  void _showVerifyPinPopup(BuildContext context) {
    final TextEditingController pinController = TextEditingController();
    bool obscurePin = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 450,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Header
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFF244065),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Employee Pin",
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(dialogContext),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pin Number",
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      Form(
                        key: formKey,
                        autovalidateMode: autoValidate
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: TextFormField(
                          controller: pinController,
                          obscureText: obscurePin,

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter your PIN";
                            }

                            if (value.trim().length < 4) {
                              return "PIN must be at least 4 characters";
                            }

                            return null;
                          },

                          decoration: InputDecoration(
                            hintText: "Enter your Pin Number",
                            filled: true,
                            fillColor: Colors.white,

                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePin
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setDialogState(() {
                                  obscurePin = !obscurePin;
                                });
                              },
                            ),

                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF9ECF9A),
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF9ECF9A),
                                width: 1.5,
                              ),
                            ),

                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Colors.red),
                            ),

                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 22),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 110,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE74C3C),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                "Close",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 20),

                          SizedBox(
                            width: 110,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                setDialogState(() {
                                  autoValidate = true;
                                });

                                if (formKey.currentState!.validate()) {
                                  final pin = pinController.text.trim();

                                  print("Entered PIN: $pin");

                                  Navigator.pop(dialogContext);

                                  // Verify PIN API
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9ECF9A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              child: const Text(
                                "Proceed",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTimeClockPopup(BuildContext context) {
    final employeeController = TextEditingController();
    final pinController = TextEditingController();

    bool obscurePin = true;
    String? pinError;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 720,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Header
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF244065),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Time clock",
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(dialogContext),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      Text(
                        "GREATER WORK STATION",
                        style: GoogleFonts.nunito(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF244065),
                        ),
                      ),

                      const SizedBox(height: 28),

                      /// Employee Name
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Employee Name",
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          RawAutocomplete<Employee>(
                            displayStringForOption: (employee) =>
                            employee.employeeName,

                            optionsBuilder: (TextEditingValue value) {
                              if (value.text.isEmpty) {
                                return employees;
                              }

                              return employees.where(
                                    (employee) => employee.employeeName
                                    .toLowerCase()
                                    .contains(value.text.toLowerCase()),
                              );
                            },

                            onSelected: (employee) {
                              setDialogState(() {
                                selectedEmployee = employee;
                                showTimeClockActions = true;
                              });

                              print(employee.employeeId);
                              print(employee.employeeName);
                            },

                            fieldViewBuilder: (
                                context,
                                controller,
                                focusNode,
                                onFieldSubmitted,
                                ) {
                              return TextFormField(
                                controller: controller,
                                focusNode: focusNode,

                                decoration: InputDecoration(
                                  hintText: "Select Employee",

                                  prefixIcon: const Icon(Icons.search),

                                  filled: true,
                                  fillColor: Colors.white,

                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFD0D5DD),
                                    ),
                                  ),

                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF9ECF9A),
                                    ),
                                  ),

                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              );
                            },

                            optionsViewBuilder: (
                                context,
                                onSelected,
                                options,
                                ) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.75,

                                    constraints: const BoxConstraints(
                                      maxHeight: 180,
                                    ),

                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),

                                      border: Border.all(
                                        color: const Color(0xFFD0D5DD),
                                      ),
                                    ),

                                    child: ListView.separated(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      itemCount: options.length,

                                      separatorBuilder: (_, __) =>
                                      const Divider(height: 1),

                                      itemBuilder: (context, index) {
                                        final employee =
                                        options.elementAt(index);

                                        return InkWell(
                                          onTap: () {
                                            onSelected(employee);
                                          },

                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 14,
                                            ),

                                            child: Text(
                                              "${employee.employeeId}. ${employee.employeeName}",
                                              style: GoogleFonts.nunito(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// PIN
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Pin Number ( P-18 Emp )",
                          style: GoogleFonts.nunito(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextFormField(
                        controller: pinController,
                        obscureText: obscurePin,

                        onChanged: (value) {
                          setDialogState(() {
                            if (value.trim().length >= 4) {
                              pinError = null;
                            }
                          });
                        },

                        decoration: InputDecoration(
                          hintText: "Enter your pin number",
                          errorText: pinError,
                          filled: true,
                          fillColor: Colors.white,

                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePin
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                            onPressed: () {
                              setDialogState(() {
                                obscurePin = !obscurePin;
                              });
                            },
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF9ECF9A),
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFF9ECF9A),
                            ),
                          ),

                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.red),
                          ),

                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),

                      if (showTimeClockActions) ...[
                        const SizedBox(height: 25),

                        Center(
                          child: SizedBox(
                            width: 120,
                            height: 42,
                            child: ElevatedButton(
                              onPressed: () {
                                // PIN Validation
                                if (pinController.text.trim().length < 4) {
                                  setDialogState(() {
                                    pinError = "PIN must be at least 4 characters";
                                  });
                                  return;
                                }

                                setDialogState(() {
                                  pinError = null;
                                });

                                print(selectedEmployee?.employeeId);
                                print(pinController.text);

                                if (!isClockedIn) {
                                  setState(() {
                                    isClockedIn = true;
                                  });

                                  showTopMessage(context, "Clock In Successfully");

                                  Future.delayed(const Duration(seconds: 1), () {
                                    Navigator.pop(dialogContext);
                                  });
                                } else {
                                  setState(() {
                                    isClockedIn = false;
                                  });

                                  showTopMessage(context, "Clock Out Successfully");

                                  Future.delayed(const Duration(seconds: 1), () {
                                    Navigator.pop(dialogContext);
                                  });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFA4C89A),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                              child: Text(
                                isClockedIn ? "Clock Out" : "Clock In",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () {
                            print("Hide Timeclock history");
                            // Show/Hide history logic
                          },
                          child: Text(
                            "Hide Timeclock history",
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],

                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

}

class EmployeeSearchDelegate extends SearchDelegate<String> {
  final List<String> employees;

  EmployeeSearchDelegate(this.employees);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, '')
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildEmployeeList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildEmployeeList(context);
  }

  Widget _buildEmployeeList(BuildContext context) {
    final filtered = employees
        .where(
          (e) => e.toLowerCase().contains(query.toLowerCase()),
    )
        .toList();

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filtered[index]),
          onTap: () {
            close(context, filtered[index]);
          },
        );
      },
    );
  }
}
class Employee {
  final int employeeId;
  final String employeeName;

  Employee({
    required this.employeeId,
    required this.employeeName,
  });
}
