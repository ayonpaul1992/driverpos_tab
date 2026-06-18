import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../components/CustomAppBar.dart';
import '../components/CustomBottomNavBar.dart';

class TeaSheet extends StatefulWidget {
  final String userId;
  const TeaSheet({super.key, required this.userId});

  @override
  State<StatefulWidget> createState() => TeaSheetState();
}

class TeaSheetState extends State<TeaSheet> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  final TextEditingController _searchController = TextEditingController();
  String _activeButton = 'notes';
  final FocusNode searchFocusNode = FocusNode();
  List<String> teeSheetData = [
    "Arkaprava Bera",
    "John Doe",
    "David Smith",
    "Robert Johnson",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  void _showReservationPopup(BuildContext context, String time) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _ReservationDialog(time: time),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        scaffoldKey: _scaffoldKey,
        userId: widget.userId,
        showLeading: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          searchFocusNode.unfocus();
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            color: const Color(0xFFF4F4F4),
            width: double.infinity,
            child: Column(
              children: [
                _buildToolbar(),
                _buildHeaderRow(),
                _buildTeeSheetGrid(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(selectedIndex: 2),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _buildTabButton(
            label: 'Notes',
            id: 'notes',
            activeColor: const Color(0xFFF5A623),
          ),
          const SizedBox(width: 6),
          _buildTabButton(
            label: 'Toggle Back',
            id: 'toggleBack',
            activeColor: const Color(0xFF7B61FF),
          ),
          const SizedBox(width: 6),
          _buildTabButton(
            label: 'Side By Side',
            id: 'sideBySide',
            activeColor: const Color(0xFF244065),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1.5),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  }
                  return teeSheetData.where(
                        (item) => item.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    ),
                  );
                },
                onSelected: (String selection) {
                  print("Selected: $selection");
                },
                fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: GoogleFonts.nunito(
                      fontSize: 16,
                      color: const Color(0xFF374151),
                    ),
                    decoration: InputDecoration(
                      hintText: "Search here...",
                      hintStyle: GoogleFonts.nunito(
                        fontSize: 16,
                        color: const Color(0xFF9CA3AF),
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 10, right: 6),
                        child: Icon(Icons.search, size: 20, color: Color(0xFF9CA3AF)),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 34,
                        minHeight: 34,
                      ),
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 0,
                      ),
                    ),
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 350,
                        constraints: const BoxConstraints(maxHeight: 200),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              dense: true,
                              title: Text(option, style: GoogleFonts.nunito(fontSize: 14)),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 10),
          _buildIconButton('assets/images/info_tea.png'),
          const SizedBox(width: 4),
          _buildIconButton('assets/images/print_tea_data.png'),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Color(0xFF6B7280),
              size: 24,
            ),
          ),
          const SizedBox(width: 4),
          Container(width: 1, height: 24, color: const Color(0xFFA8CE9F)),
          const SizedBox(width: 8),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFF9ECF9A),
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/images/andr_cpytp.png', width: 17, height: 17),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required String label,
    required String id,
    required Color activeColor,
  }) {
    final isActive = _activeButton == id;
    return GestureDetector(
      onTap: () => setState(() => _activeButton = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive ? activeColor : const Color(0xFFD1D5DB),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 17,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? activeColor : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(String imagePath) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Image.asset(imagePath, width: 20, height: 20),
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
      child: Row(
        children: [
          Container(
            width: 107,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF9ECF9A),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Time',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFF9ECF9A),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Front',
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeeSheetGrid() {
    final List<String> times = [];
    DateTime startTime = DateTime(2025, 1, 1, 9, 30);
    DateTime endTime = DateTime(2025, 1, 1, 17, 0);

    while (!startTime.isAfter(endTime)) {
      times.add(DateFormat('h:mma').format(startTime));
      startTime = startTime.add(const Duration(minutes: 15));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD9D9D9)),
      ),
      child: Column(
        children: times.map((time) {
          return Row(
            children: [
              // Time column — NOT tappable
              Container(
                width: 104,
                height: 54,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Color(0xFFD9D9D9)),
                    bottom: BorderSide(color: Color(0xFFD9D9D9)),
                  ),
                ),
                child: Text(
                  time,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),

              // Front column — tappable → opens reservation popup
              Expanded(
                child: GestureDetector(
                  onTap: () => _showReservationPopup(context, time),
                  child: Container(
                    height: 54,
                    decoration: const BoxDecoration(
                    color: Colors.transparent,
                      border: Border(
                        bottom: BorderSide(color: Color(0xFFD9D9D9)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reservation Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _ReservationDialog extends StatefulWidget {
  final String time;

  const _ReservationDialog({required this.time});

  @override
  State<_ReservationDialog> createState() => _ReservationDialogState();
}

class _ReservationDialogState extends State<_ReservationDialog> {
  String selectedTab = 'tee_times';
  String selectedPlayers = '1';
  String selectedHoles = '18';
  final TextEditingController cartOneController = TextEditingController();
  final TextEditingController cartTwoController = TextEditingController();
  String selectedSplit = '4 Per Split';
  bool splitShot = false;
  final TextEditingController notesController = TextEditingController();

  final int rowCount = 6;
  late List<TextEditingController> emailControllers;
  late List<TextEditingController> phoneControllers;
  late List<TextEditingController> membershipControllers;
  late List<TextEditingController> amountControllers;

  @override
  void initState() {
    super.initState();
    emailControllers = List.generate(rowCount, (_) => TextEditingController());
    phoneControllers = List.generate(rowCount, (_) => TextEditingController());
    membershipControllers = List.generate(rowCount, (_) => TextEditingController());
    amountControllers = List.generate(rowCount, (_) => TextEditingController());
  }

  @override
  void dispose() {
    notesController.dispose();
    cartOneController.dispose();
    cartTwoController.dispose();
    for (int i = 0; i < rowCount; i++) {
      emailControllers[i].dispose();
      phoneControllers[i].dispose();
      membershipControllers[i].dispose();
      amountControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Container(
        width: 820,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(formattedDate),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTabRow(),
                    const SizedBox(height: 16),
                    _buildAddNewTeeTimeRow(),
                    const SizedBox(height: 12),
                    _buildPlayerRows(),
                    const SizedBox(height: 8),
                    _buildAddMore(),
                    const SizedBox(height: 8),
                    _buildSplitShot(),
                    const SizedBox(height: 12),
                    _buildNotesAndButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(String date) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: const BoxDecoration(
        color: Color(0xFF9ECF9A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Pending Reservation - on $date @ ${widget.time}",
              style: GoogleFonts.nunito(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  // ── Tabs ──────────────────────────────────────────────────────────────────
  Widget _buildTabRow() {
    return Row(
      children: [
        _buildTab('Tee Times', 'tee_times'),
        const SizedBox(width: 8),
        _buildTab('Events', 'events'),
        const SizedBox(width: 8),
        _buildTab('Block', 'block'),
      ],
    );
  }

  Widget _buildTab(String label, String id) {
    final isActive = selectedTab == id;
    return GestureDetector(
      onTap: () => setState(() => selectedTab = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF9ECF9A) : Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isActive ? const Color(0xFF9ECF9A) : const Color(0xFFD1D5DB),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : const Color(0xFF374151),
          ),
        ),
      ),
    );
  }

  // ── Add New Tee Time Row ──────────────────────────────────────────────────
  Widget _buildAddNewTeeTimeRow() {
    return Row(
      children: [
        Text(
          "Add New Tee Time",
          style: GoogleFonts.nunito(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF244065),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFF244065),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_outline, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 6),
        _buildSmallDropdown(
          value: selectedPlayers,
          items: ['1', '2', '3', '4'],
          onChanged: (v) => setState(() => selectedPlayers = v!),
        ),
        const SizedBox(width: 8),
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFF5A623),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.flag_outlined, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 6),
        _buildSmallDropdown(
          value: selectedHoles,
          items: ['9', '18'],
          onChanged: (v) => setState(() => selectedHoles = v!),
        ),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallField("Enter cart one", cartOneController)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallField("Enter cart two", cartTwoController)),
        const SizedBox(width: 8),
        _buildSmallDropdown(
          value: selectedSplit,
          items: ['4 Per Split', '3 Per Split', '2 Per Split'],
          onChanged: (v) => setState(() => selectedSplit = v!),
          width: 120,
        ),
      ],
    );
  }

  Widget _buildSmallDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    double width = 72,
  }) {
    return Container(
      height: 34,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(6),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          style: GoogleFonts.nunito(fontSize: 13, color: const Color(0xFF374151)),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildSmallField(String hint, TextEditingController controller) {
    return SizedBox(
      height: 34,
      child: TextField(
        controller: controller,
        style: GoogleFonts.nunito(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(fontSize: 13, color: const Color(0xFF9CA3AF)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFF9ECF9A), width: 1.5),
          ),
        ),
      ),
    );
  }

  // ── Player Rows ───────────────────────────────────────────────────────────
  Widget _buildPlayerRows() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: List.generate(rowCount, (index) {
          return Column(
            children: [
              _buildPlayerRow(index),
              if (index < rowCount - 1)
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildPlayerRow(int index) {
    final number = (index + 1).toString().padLeft(2, '0');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              number,
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF244065),
              ),
            ),
          ),
          const Icon(Icons.search, size: 18, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 6),
          Expanded(
            child: _buildRowField(emailControllers[index], "Email address"),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.edit_outlined, size: 15, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Expanded(
            child: _buildRowField(phoneControllers[index], "Phone number"),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.edit_outlined, size: 15, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Expanded(
            child: _buildRowField(membershipControllers[index], "Membership"),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.edit_outlined, size: 15, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          Expanded(
            child: _buildRowField(amountControllers[index], "Amount"),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.edit_outlined, size: 15, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 8),
          const Text("👋", style: TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          const Icon(Icons.accessible_outlined, size: 18, color: Color(0xFF9CA3AF)),
          const SizedBox(width: 4),
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: Color(0xFF9ECF9A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.golf_course, size: 13, color: Colors.white),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.delete_outline, size: 18, color: Color(0xFFE74C3C)),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => print("No show tapped for row ${index + 1}"),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF9ECF9A),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                "No show",
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowField(TextEditingController controller, String hint) {
    return SizedBox(
      height: 30,
      child: TextField(
        controller: controller,
        style: GoogleFonts.nunito(fontSize: 12),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(
            fontSize: 12,
            color: const Color(0xFF9CA3AF),
          ),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 6),
        ),
      ),
    );
  }

  // ── Add More ──────────────────────────────────────────────────────────────
  Widget _buildAddMore() {
    return GestureDetector(
      onTap: () {
        // TODO: dynamically add more player rows
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline, size: 16, color: Color(0xFF9CA3AF)),
            const SizedBox(width: 6),
            Text(
              "Add More",
              style: GoogleFonts.nunito(fontSize: 13, color: const Color(0xFF9CA3AF)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Split Shot ────────────────────────────────────────────────────────────
  Widget _buildSplitShot() {
    return Row(
      children: [
        Checkbox(
          value: splitShot,
          activeColor: const Color(0xFF9ECF9A),
          onChanged: (v) => setState(() => splitShot = v ?? false),
        ),
        Text(
          "Split Shot",
          style: GoogleFonts.nunito(fontSize: 14, color: const Color(0xFF374151)),
        ),
      ],
    );
  }

  // ── Notes + Buttons ───────────────────────────────────────────────────────
  Widget _buildNotesAndButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: notesController,
              maxLines: null,
              expands: true,
              style: GoogleFonts.nunito(fontSize: 13),
              decoration: InputDecoration(
                hintText: "Write Notes",
                hintStyle: GoogleFonts.nunito(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          children: [
            SizedBox(
              width: 130,
              height: 38,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF244065),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Reserve",
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 130,
              height: 38,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5A623),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Reserve & Pay",
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}