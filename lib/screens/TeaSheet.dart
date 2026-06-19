import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
                  debugPrint("Selected: $selection");
                },
                fieldViewBuilder:
                    (context, controller, focusNode, onFieldSubmitted) {
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
                            child: Icon(
                              Icons.search,
                              size: 20,
                              color: Color(0xFF9CA3AF),
                            ),
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
                              title: Text(
                                option,
                                style: GoogleFonts.nunito(fontSize: 14),
                              ),
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
            child: Image.asset(
              'assets/images/andr_cpytp.png',
              width: 17,
              height: 17,
            ),
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
      child: Center(child: Image.asset(imagePath, width: 20, height: 20)),
    );
  }

  Widget _buildHeaderRow() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF9ECF9A),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Container(
            width: 107,
            height: 36,
            alignment: Alignment.center,
            child: Text(
              'Time',
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 36,
              alignment: Alignment.center,
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
    final DateTime endTime = DateTime(2025, 1, 1, 17, 0);

    while (!startTime.isAfter(endTime)) {
      times.add(DateFormat('h:mma').format(startTime));
      startTime = startTime.add(const Duration(minutes: 15));
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD9D9D9)),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      child: Column(
        children: List.generate(times.length, (index) {
          final time = times[index];
          return Row(
            children: [
              Container(
                width: 104,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                    right: const BorderSide(color: Color(0xFFD9D9D9)),
                    bottom: index == times.length - 1
                        ? BorderSide.none
                        : const BorderSide(color: Color(0xFFD9D9D9)),
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
              Expanded(
                child: GestureDetector(
                  onTap: () => _showReservationPopup(context, time),
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border(
                        bottom: index == times.length - 1
                            ? BorderSide.none
                            : const BorderSide(color: Color(0xFFD9D9D9)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Customer Model
// ─────────────────────────────────────────────────────────────────────────────

class Customer {
  final String name;
  final String phone;
  const Customer({required this.name, required this.phone});
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
  String selectedHoles = '9';
  String selectedSplit = '4 Per Split';
  bool splitShot = false;

  // ── Submission state ──────────────────────────────────────────────────────
  bool _isLoading = false;
  bool _submitted = false; // true after first submit attempt → show errors

  // ── Per-row validation error flags (name required, phone required) ────────
  // Populated on submit; rebuilt whenever rows change.
  List<bool> _nameErrors = [];
  List<bool> _phoneErrors = [];

  final TextEditingController cartOneController = TextEditingController();
  final TextEditingController cartTwoController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController playersController = TextEditingController(
    text: '1',
  );

  final List<Customer> customers = const [
    Customer(name: 'Arkaprava Bera', phone: '9732860229'),
    Customer(name: 'John Smith', phone: '9876543210'),
    Customer(name: 'David Miller', phone: '9123456789'),
    Customer(name: 'James Wilson', phone: '9988776655'),
  ];

  // Initial fixed rows (01–05). Rows added via "Add More" start from index 5+
  // and are tracked by [addedRowCount]. [isAddedRow] marks which rows are
  // dynamically added so we can show the red remove button only on those.
  static const int _fixedRowCount = 5;
  int _addedRowCount = 0;
  int get _totalRows => _fixedRowCount + _addedRowCount;

  late List<TextEditingController> nameControllers;
  late List<TextEditingController> phoneControllers;
  late List<TextEditingController> membershipControllers;
  late List<TextEditingController> amountControllers;
  late List<List<bool>> editingState;
  late List<List<FocusNode>> focusNodes;

  @override
  void initState() {
    super.initState();
    nameControllers = List.generate(
      _fixedRowCount,
      (_) => TextEditingController(),
    );
    phoneControllers = List.generate(
      _fixedRowCount,
      (_) => TextEditingController(),
    );
    membershipControllers = List.generate(
      _fixedRowCount,
      (_) => TextEditingController(),
    );
    amountControllers = List.generate(
      _fixedRowCount,
      (_) => TextEditingController(),
    );
    editingState = List.generate(_fixedRowCount, (_) => [false, false, false]);
    focusNodes = List.generate(
      _fixedRowCount,
      (_) => List.generate(3, (_) => FocusNode()),
    );
    _nameErrors = List.generate(_fixedRowCount, (_) => false);
    _phoneErrors = List.generate(_fixedRowCount, (_) => false);
  }

  // ── Validate all rows; returns true if form is valid ──────────────────────
  bool _validate() {
    bool valid = true;
    final newNameErrors = List.generate(_totalRows, (i) {
      final empty = nameControllers[i].text.trim().isEmpty;
      if (empty) valid = false;
      return empty;
    });
    final newPhoneErrors = List.generate(_totalRows, (i) {
      // Only require phone if name is filled
      if (nameControllers[i].text.trim().isEmpty) return false;
      final phone = phoneControllers[i].text.trim();
      final invalid = phone.isEmpty || phone.length < 7;
      if (invalid) valid = false;
      return invalid;
    });
    setState(() {
      _submitted = true;
      _nameErrors = newNameErrors;
      _phoneErrors = newPhoneErrors;
    });
    return valid;
  }

  // ── Build reservation payload for API ────────────────────────────────────
  Map<String, dynamic> _buildPayload() {
    final players = <Map<String, dynamic>>[];
    for (int i = 0; i < _totalRows; i++) {
      final name = nameControllers[i].text.trim();
      if (name.isEmpty) continue;
      players.add({
        'name': name,
        'phone': phoneControllers[i].text.trim(),
        'membership': membershipControllers[i].text.trim(),
        'amount': amountControllers[i].text.trim(),
      });
    }
    return {
      'date': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'time': widget.time,
      'holes': selectedHoles,
      'split': selectedSplit,
      'cart_one': cartOneController.text.trim(),
      'cart_two': cartTwoController.text.trim(),
      'split_shot': splitShot,
      'notes': notesController.text.trim(),
      'players': players,
    };
  }

  // ── Reserve only ──────────────────────────────────────────────────────────
  Future<void> _onReserve() async {
    if (!_validate()) return;
    setState(() => _isLoading = true);
    try {
      final payload = _buildPayload();
      // TODO: replace with real API call
      // await ReservationApi.reserve(payload);
      await Future.delayed(const Duration(seconds: 1)); // simulate network
      debugPrint('Reserve payload: $payload');
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reservation confirmed for ${widget.time}',
              style: GoogleFonts.nunito(fontSize: 13),
            ),
            backgroundColor: const Color(0xFF9ECF9A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to reserve. Please try again.',
              style: GoogleFonts.nunito(fontSize: 13),
            ),
            backgroundColor: const Color(0xFFE74C3C),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Reserve & Pay ─────────────────────────────────────────────────────────
  Future<void> _onReserveAndPay() async {
    if (!_validate()) return;
    setState(() => _isLoading = true);
    try {
      final payload = _buildPayload();
      // TODO: replace with real API call
      // final result = await ReservationApi.reserveAndPay(payload);
      await Future.delayed(const Duration(seconds: 1)); // simulate network
      debugPrint('Reserve & Pay payload: $payload');
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Reservation & payment confirmed for ${widget.time}',
              style: GoogleFonts.nunito(fontSize: 13),
            ),
            backgroundColor: const Color(0xFF9ECF9A),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Payment failed. Please try again.',
              style: GoogleFonts.nunito(fontSize: 13),
            ),
            backgroundColor: const Color(0xFFE74C3C),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Adds a new dynamic row with fresh controllers/focus nodes ─────────────
  void _addRow() {
    setState(() {
      nameControllers.add(TextEditingController());
      phoneControllers.add(TextEditingController());
      membershipControllers.add(TextEditingController());
      amountControllers.add(TextEditingController());
      editingState.add([false, false, false]);
      focusNodes.add(List.generate(3, (_) => FocusNode()));
      _nameErrors.add(false);
      _phoneErrors.add(false);
      _addedRowCount++;
    });
  }

  // ── Removes a dynamic row by its absolute index ───────────────────────────
  void _removeRow(int index) {
    setState(() {
      nameControllers[index].dispose();
      phoneControllers[index].dispose();
      membershipControllers[index].dispose();
      amountControllers[index].dispose();
      for (final fn in focusNodes[index]) fn.dispose();
      nameControllers.removeAt(index);
      phoneControllers.removeAt(index);
      membershipControllers.removeAt(index);
      amountControllers.removeAt(index);
      editingState.removeAt(index);
      focusNodes.removeAt(index);
      _nameErrors.removeAt(index);
      _phoneErrors.removeAt(index);
      _addedRowCount--;
    });
  }

  @override
  void dispose() {
    notesController.dispose();
    cartOneController.dispose();
    cartTwoController.dispose();
    playersController.dispose();
    for (int i = 0; i < _totalRows; i++) {
      nameControllers[i].dispose();
      phoneControllers[i].dispose();
      membershipControllers[i].dispose();
      amountControllers[i].dispose();
      for (final fn in focusNodes[i]) fn.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox(
        width: 1020,
        height: MediaQuery.of(context).size.height * 0.88,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildHeader(formattedDate),
              Expanded(
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
      ),
    );
  }

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
          child: const Icon(
            Icons.person_outline,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 72,
          height: 34,
          child: TextField(
            controller: playersController,
            keyboardType: TextInputType.number,
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: const Color(0xFF374151),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
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
        PopupMenuButton<String>(
          initialValue: selectedHoles,
          onSelected: (v) => setState(() => selectedHoles = v),
          itemBuilder: (context) => [
            '9',
            '18',
          ].map((e) => PopupMenuItem(value: e, child: Text(e))).toList(),
          child: Container(
            width: 58,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD1D5DB)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  selectedHoles,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallField("Enter cart one", cartOneController)),
        const SizedBox(width: 8),
        Expanded(child: _buildSmallField("Enter cart two", cartTwoController)),
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          initialValue: selectedSplit,
          onSelected: (v) => setState(() => selectedSplit = v),
          itemBuilder: (context) =>
              ['4 Per Split', '3 Per Split', '2 Per Split']
                  .map(
                    (e) => PopupMenuItem<String>(
                      value: e,
                      child: Text(
                        e,
                        style: GoogleFonts.nunito(
                          fontSize: 13,
                          color: const Color(0xFF374151),
                        ),
                      ),
                    ),
                  )
                  .toList(),
          child: Container(
            width: 120,
            height: 34,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD1D5DB)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedSplit,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ],
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
          hintStyle: GoogleFonts.nunito(
            fontSize: 13,
            color: const Color(0xFF9CA3AF),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
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

  Widget _buildPlayerRows() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(_totalRows, (index) {
              final isAdded = index >= _fixedRowCount;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildPlayerRow(index, isAdded: isAdded),
                  if (index < _totalRows - 1)
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFE5E7EB),
                    ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerRow(int index, {bool isAdded = false}) {
    final number = (index + 1).toString().padLeft(2, '0');
    final hasNameError =
        _submitted && index < _nameErrors.length && _nameErrors[index];
    final hasPhoneError =
        _submitted && index < _phoneErrors.length && _phoneErrors[index];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
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
              const SizedBox(width: 6),
              // ── Name field with red border on error ──────────────────────
              Expanded(
                child: Container(
                  decoration: hasNameError
                      ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xFFE74C3C),
                              width: 1.5,
                            ),
                          ),
                        )
                      : null,
                  child: _buildNameSearchField(index: index),
                ),
              ),
              const SizedBox(width: 8),
              // ── Phone field with red border on error ─────────────────────
              Expanded(
                child: Container(
                  decoration: hasPhoneError
                      ? BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xFFE74C3C),
                              width: 1.5,
                            ),
                          ),
                        )
                      : null,
                  child: _buildEditableField(
                    controller: phoneControllers[index],
                    hint: "Phone number",
                    rowIndex: index,
                    fieldIndex: 0,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildEditableField(
                  controller: membershipControllers[index],
                  hint: "Membership",
                  rowIndex: index,
                  fieldIndex: 1,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildEditableField(
                  controller: amountControllers[index],
                  hint: "Amount",
                  rowIndex: index,
                  fieldIndex: 2,
                ),
              ),
              const SizedBox(width: 8),
              const Text("👋", style: TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              const Icon(
                Icons.accessible_outlined,
                size: 18,
                color: Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 4),
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Color(0xFF9ECF9A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.golf_course,
                  size: 13,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 4),
              // ── delete icon for fixed rows ─────────────────────────────────
              if (!isAdded)
                const Icon(
                  Icons.delete_outline,
                  size: 18,
                  color: Color(0xFFE74C3C),
                ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () => debugPrint("No show tapped for row ${index + 1}"),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
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
              // ── Red X remove button AFTER No show, only for added rows ────
              if (isAdded) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _removeRow(index),
                    child: const Icon(
                      Icons.close,
                      size: 13,
                      color: Colors.red,
                    ),
                ),
              ],
            ],
          ),
        ),
        // ── Inline error messages below the row ───────────────────────────
        if (hasNameError || hasPhoneError)
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 4, right: 10),
            child: Row(
              children: [
                if (hasNameError)
                  Expanded(
                    child: Text(
                      'Name is required',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        color: const Color(0xFFE74C3C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                if (hasNameError && hasPhoneError) const SizedBox(width: 8),
                if (hasPhoneError)
                  Expanded(
                    child: Text(
                      'Valid phone required',
                      style: GoogleFonts.nunito(
                        fontSize: 11,
                        color: const Color(0xFFE74C3C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                // spacer to align with remaining columns
                const Expanded(child: SizedBox()),
                const Expanded(child: SizedBox()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String hint,
    required int rowIndex,
    required int fieldIndex,
  }) {
    final isEditing = editingState[rowIndex][fieldIndex];
    final focusNode = focusNodes[rowIndex][fieldIndex];

    return Row(
      children: [
        Expanded(
          child: isEditing
              ? SizedBox(
                  height: 30,
                  child: TextField(
                    controller: controller,
                    focusNode: focusNode,
                    style: GoogleFonts.nunito(fontSize: 12),
                    onSubmitted: (_) => setState(
                      () => editingState[rowIndex][fieldIndex] = false,
                    ),
                    onTapOutside: (_) => setState(
                      () => editingState[rowIndex][fieldIndex] = false,
                    ),
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
                )
              : Text(
                  controller.text.isEmpty ? hint : controller.text,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: controller.text.isEmpty
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF374151),
                  ),
                ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () {
            setState(() => editingState[rowIndex][fieldIndex] = !isEditing);
            if (!isEditing) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                focusNode.requestFocus();
              });
            } else {
              focusNode.unfocus();
            }
          },
          child: const Icon(
            Icons.edit_outlined,
            size: 15,
            color: Color(0xFF9CA3AF),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Name Search Field — fixed: Add Customer always visible,
  // "No result found" shown only when search has no matches
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildNameSearchField({required int index}) {
    return SizedBox(
      height: 30,
      child: TypeAheadField<Object?>(
        controller: nameControllers[index],
        hideOnEmpty: false,
        hideOnLoading: true,
        hideOnError: true,
        suggestionsCallback: (search) {
          // Empty search — show only Add Customer, no "No result found"
          if (search.isEmpty) return [null];

          final matches = customers
              .where((c) => c.name.toLowerCase().contains(search.toLowerCase()))
              .toList();

          // No matches — show Add Customer + "No result found" sentinel
          if (matches.isEmpty) {
            return [null, '__no_results__'];
          }

          // Has matches — show Add Customer + matched customers
          return [null, ...matches];
        },
        itemBuilder: (context, item) {
          // ── "Add Customer" sentinel row ──────────────────────────────────
          if (item == null) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => const _AddCustomerDialog(),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      size: 15,
                      color: Color(0xFF244065),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Add Customer",
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF244065),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // ── "No result found" sentinel row ───────────────────────────────
          if (item == '__no_results__') {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Text(
                "No result found",
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            );
          }

          // ── Real customer row ────────────────────────────────────────────
          final customer = item as Customer;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Color(0xFFE5E7EB), width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    customer.name,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.nunito(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: Text(
                    customer.phone,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        onSelected: (item) {
          // Ignore sentinel rows
          if (item == null || item == '__no_results__') return;
          final customer = item as Customer;
          setState(() {
            nameControllers[index].text = customer.name;
            phoneControllers[index].text = customer.phone;
            editingState[index][0] = false;
            // Clear validation errors for this row on selection
            if (index < _nameErrors.length) _nameErrors[index] = false;
            if (index < _phoneErrors.length) _phoneErrors[index] = false;
          });
        },
        constraints: const BoxConstraints(
          minWidth: 260,
          maxWidth: 320,
          maxHeight: 220,
        ),
        builder: (context, textController, focusNode) {
          return ValueListenableBuilder<TextEditingValue>(
            valueListenable: textController,
            builder: (context, value, _) {
              return TextField(
                controller: textController,
                focusNode: focusNode,
                style: GoogleFonts.nunito(fontSize: 12),
                decoration: InputDecoration(
                  hintText: "Name",
                  hintStyle: GoogleFonts.nunito(
                    fontSize: 12,
                    color: const Color(0xFF9CA3AF),
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  suffixIcon: value.text.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              textController.clear();
                              phoneControllers[index].clear();
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(top: 6, bottom: 6),
                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: Color(0xFF9CA3AF),
                            ),
                          ),
                        )
                      : null,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildAddMore() {
    return GestureDetector(
      onTap: _addRow,
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
            const Icon(
              Icons.add_circle_outline,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
            const SizedBox(width: 6),
            Text(
              "Add More",
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          style: GoogleFonts.nunito(
            fontSize: 14,
            color: const Color(0xFF374151),
          ),
        ),
      ],
    );
  }

  Widget _buildNotesAndButtons() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Container(
            height: 84,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: notesController,
              maxLines: null,
              expands: true,
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: const Color(0xFF374151),
              ),
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
        SizedBox(
          width: 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Reserve button ───────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onReserve,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF244065),
                    disabledBackgroundColor: const Color(
                      0xFF244065,
                    ).withOpacity(0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Reserve",
                          style: GoogleFonts.nunito(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 8),
              // ── Reserve & Pay button ─────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _onReserveAndPay,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A623),
                    disabledBackgroundColor: const Color(
                      0xFFF5A623,
                    ).withOpacity(0.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Reserve & Pay",
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add Customer Dialog
// ─────────────────────────────────────────────────────────────────────────────

class _AddCustomerDialog extends StatefulWidget {
  const _AddCustomerDialog();

  @override
  State<_AddCustomerDialog> createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<_AddCustomerDialog> {
  String _activeTab = 'information';

  // ── Profile Info controllers ──────────────────────────────────────────────
  final TextEditingController _accountNumberController = TextEditingController(
    text: 'C20773687',
  );
  final TextEditingController _tempPasswordController = TextEditingController(
    text: 'pUDjm04t',
  );
  final TextEditingController _commentsController = TextEditingController();
  String _selectedStatus = 'Active';
  String _selectedHandicap = 'Not Handicapped';
  String _selectedTax = 'Yes';
  DateTime? _dateOfBirth;

  // ── Basic Info controllers ────────────────────────────────────────────────
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isGuestCustomer = false;
  bool _isCompany = false;
  bool _isCountryClub = false;

  // ── Membership Info ───────────────────────────────────────────────────────
  String _selectedMembership = 'Public Daily Fee';
  final TextEditingController _priceController = TextEditingController(
    text: '0',
  );

  final List<String> _tabs = [
    'Information',
    'Accounts',
    'History',
    'Invoice',
    'Saved Cards',
    'Miscellaneous',
    'Family Members',
    'Notification Settings',
  ];

  @override
  void dispose() {
    _accountNumberController.dispose();
    _tempPasswordController.dispose();
    _commentsController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogHeader(),
            _buildTabBar(),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.80,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileInfoSection(),
                    const SizedBox(height: 16),
                    _buildBasicAndMembershipRow(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dialog Header ─────────────────────────────────────────────────────────
  Widget _buildDialogHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "Add new customer",
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF244065),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9ECF9A),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            icon: const Icon(Icons.credit_card, size: 16, color: Colors.white),
            label: Text(
              "Scan Driving License",
              style: GoogleFonts.nunito(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.close, color: Color(0xFF6B7280), size: 20),
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _tabs.map((tab) {
            final id = tab.toLowerCase().replaceAll(' ', '_');
            final isActive = _activeTab == id;
            return GestureDetector(
              onTap: () => setState(() => _activeTab = id),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isActive
                          ? const Color(0xFF9ECF9A)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tab,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                    color: isActive
                        ? const Color(0xFF244065)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // ── Profile Info Section ──────────────────────────────────────────────────
  Widget _buildProfileInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              "Profile Information",
              style: GoogleFonts.nunito(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF374151),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhotoUpload(),
                const SizedBox(width: 24),
                Expanded(child: _buildProfileFields()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Photo Upload ──────────────────────────────────────────────────────────
  Widget _buildPhotoUpload() {
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFFE5E7EB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 12,
                left: 12,
                child: _cornerBracket(top: true, left: true),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: _cornerBracket(top: true, left: false),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: _cornerBracket(top: false, left: true),
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: _cornerBracket(top: false, left: false),
              ),
              Center(
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF374151)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
          child: Text(
            "Select File To Upload",
            style: GoogleFonts.nunito(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF374151),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "*We accept 1 file up to 5MB and 500x500 pixels",
          style: GoogleFonts.nunito(
            fontSize: 11,
            color: const Color(0xFF9ECF9A),
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          "File type *.PNG and *.JPG",
          style: GoogleFonts.nunito(
            fontSize: 11,
            color: const Color(0xFF9ECF9A),
          ),
        ),
      ],
    );
  }

  Widget _cornerBracket({required bool top, required bool left}) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _CornerBracketPainter(top: top, left: left),
      ),
    );
  }

  // ── Profile Fields ────────────────────────────────────────────────────────
  Widget _buildProfileFields() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildLabelField(
                label: "Account Number",
                child: _buildOutlineTextField(
                  _accountNumberController,
                  hint: "Account number",
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLabelField(
                label: "Temporary Password",
                child: _buildOutlineTextField(
                  _tempPasswordController,
                  hint: "Temporary password",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildLabelField(
                label: "Date of Birth",
                child: _buildDateField(),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLabelField(
                label: "Customer Status",
                child: _buildDropdown(
                  value: _selectedStatus,
                  items: ['Active', 'Inactive'],
                  onChanged: (v) =>
                      setState(() => _selectedStatus = v ?? 'Active'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildLabelField(
                label: "Handicap Status",
                child: _buildDropdown(
                  value: _selectedHandicap,
                  items: ['Not Handicapped', 'Handicapped'],
                  onChanged: (v) => setState(
                    () => _selectedHandicap = v ?? 'Not Handicapped',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildLabelField(
                label: "Tax",
                child: _buildDropdown(
                  value: _selectedTax,
                  items: ['Yes', 'No'],
                  onChanged: (v) => setState(() => _selectedTax = v ?? 'Yes'),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildLabelField(
          label: "Comments / Notes",
          child: SizedBox(
            height: 72,
            child: TextField(
              controller: _commentsController,
              maxLines: null,
              expands: true,
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: const Color(0xFF374151),
              ),
              decoration: InputDecoration(
                hintText: "Enter your comment Here",
                hintStyle: GoogleFonts.nunito(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                ),
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: const BorderSide(
                    color: Color(0xFF9ECF9A),
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildLabelField(
          label: "Group",
          child: _buildDropdown(
            value: null,
            hint: "Select multiple groups",
            items: ['Group A', 'Group B', 'Group C'],
            onChanged: (v) {},
          ),
        ),
      ],
    );
  }

  // ── Basic Info + Membership Row ───────────────────────────────────────────
  Widget _buildBasicAndMembershipRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Basic Information",
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF374151),
                        ),
                      ),
                      const Spacer(),
                      _buildToggleOption(
                        "Guest Customer ?",
                        _isGuestCustomer,
                        (v) => setState(() => _isGuestCustomer = v),
                      ),
                      const SizedBox(width: 8),
                      _buildToggleOption(
                        "Is This a Company ?",
                        _isCompany,
                        (v) => setState(() => _isCompany = v),
                      ),
                      const SizedBox(width: 8),
                      _buildToggleOption(
                        "Country Club Customer ?",
                        _isCountryClub,
                        (v) => setState(() => _isCountryClub = v),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildLabelField(
                              label: "First Name",
                              child: _buildOutlineTextField(
                                _firstNameController,
                                hint: "Enter your first name",
                                prefill: _firstNameController.text,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildLabelField(
                              label: "Last Name",
                              child: _buildOutlineTextField(
                                _lastNameController,
                                hint: "Enter your last name",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildLabelField(
                              label: "Phone No.",
                              child: _buildOutlineTextField(
                                _phoneController,
                                hint: "Enter phone number",
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildLabelField(
                              label: "Email",
                              child: _buildOutlineTextField(
                                _emailController,
                                hint: "Enter email address",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Membership Information",
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: _buildLabelField(
                          label: "Membership",
                          child: _buildDropdown(
                            value: _selectedMembership,
                            items: [
                              'Public Daily Fee',
                              'Member',
                              'VIP',
                              'Corporate',
                            ],
                            onChanged: (v) => setState(
                              () =>
                                  _selectedMembership = v ?? 'Public Daily Fee',
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _buildLabelField(
                          label: "Price",
                          child: TextField(
                            controller: _priceController,
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: const Color(0xFF374151),
                            ),
                            decoration: InputDecoration(
                              prefixText: "\$ ",
                              prefixStyle: GoogleFonts.nunito(
                                fontSize: 13,
                                color: const Color(0xFF374151),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  color: Color(0xFFD1D5DB),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  color: Color(0xFF9ECF9A),
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _buildLabelField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        child,
      ],
    );
  }

  Widget _buildOutlineTextField(
    TextEditingController controller, {
    required String hint,
    String? prefill,
  }) {
    if (prefill != null && controller.text.isEmpty) {
      controller.text = prefill;
    }
    return TextField(
      controller: controller,
      style: GoogleFonts.nunito(fontSize: 13, color: const Color(0xFF374151)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.nunito(
          fontSize: 13,
          color: const Color(0xFF9CA3AF),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF9ECF9A), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime(1990),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) setState(() => _dateOfBirth = picked);
      },
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD1D5DB)),
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _dateOfBirth == null
                    ? "Date of birth"
                    : DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  color: _dateOfBirth == null
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF374151),
                ),
              ),
            ),
            const Icon(
              Icons.calendar_today,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? hint,
  }) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD1D5DB)),
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: hint != null
              ? Text(
                  hint,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: const Color(0xFF9CA3AF),
                  ),
                )
              : null,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: Color(0xFF9CA3AF),
          ),
          style: GoogleFonts.nunito(
            fontSize: 13,
            color: const Color(0xFF374151),
          ),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildToggleOption(
    String label,
    bool value,
    void Function(bool) onChanged,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            color: const Color(0xFF374151),
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: value
                    ? const Color(0xFF9ECF9A)
                    : const Color(0xFFD1D5DB),
                width: 1.5,
              ),
              color: value ? const Color(0xFF9ECF9A) : Colors.white,
            ),
            child: value
                ? const Icon(Icons.check, size: 11, color: Colors.white)
                : null,
          ),
        ),
      ],
    );
  }
}

// ── Corner bracket painter for photo upload box ───────────────────────────

class _CornerBracketPainter extends CustomPainter {
  final bool top;
  final bool left;

  _CornerBracketPainter({required this.top, required this.left});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double len = size.width;
    final double x = left ? 0 : len;
    final double y = top ? 0 : len;
    final double dx = left ? len : -len;
    final double dy = top ? len : -len;

    canvas.drawLine(Offset(x, y), Offset(x + dx, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, y + dy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
