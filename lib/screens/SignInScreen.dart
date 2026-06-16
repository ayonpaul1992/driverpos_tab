import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'TeaSheet.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TeaSheet(userId: '',)),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset('assets/images/drv_lgintab_bck.png', fit: BoxFit.cover),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/drvrio.png',
                      width: isTablet ? 65.w : 45.w,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Text(
                        'driver.io',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF24497A),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    _buildCard(isTablet),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(bool isTablet) => Container(
    width: isTablet ? 200.w : 260.w,
    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(.92),
      borderRadius: BorderRadius.circular(25.r),
      border: Border.all(color: const Color(0xFFF4F8F3), width: 15),
    ),
    child: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Login into your account",
            style: GoogleFonts.nunito(
              fontSize: isTablet ? 9.sp : 8.sp,
              color: Colors.black54,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            "Welcome to driver.io",
            style: GoogleFonts.nunito(
              fontSize: isTablet ? 11.sp : 6.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF244065),
            ),
          ),
          SizedBox(height: 30.h),
          _buildField(
            label: "User Name / Email",
            controller: _emailController,
            hint: "Enter your user name or email id",
            keyboardType: TextInputType.emailAddress,
            action: TextInputAction.next,
            isTablet: isTablet,
            validator: (v) {
              if (v!.trim().isEmpty) return "Email is required";
              final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w{2,}$');
              if (!emailRegex.hasMatch(v.trim()))
                return "Enter a valid email address";
              return null;
            },
            onChanged: (_) => _formKey.currentState?.validate(),
          ),
          SizedBox(height: 18.h),
          _buildField(
            label: "Password",
            controller: _passwordController,
            hint: "Enter Password",
            obscure: _obscurePassword,
            action: TextInputAction.done,
            isTablet: isTablet,
            suffix: IconButton(
              iconSize: isTablet ? 10.sp : 12.sp,
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey.shade400,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (v) {
              if (v!.isEmpty) return "Password is required";
              if (v.length < 6) return "Password must be at least 6 characters";
              return null;
            },
            onChanged: (_) => _formKey.currentState?.validate(),
          ),
          SizedBox(height: 24.h),
          _buildLoginButton(isTablet),
        ],
      ),
    ),
  );

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required bool isTablet,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction action = TextInputAction.next,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: isTablet ? 7.sp : 6.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF244065),
        ),
      ),
      SizedBox(height: 6.h),
      TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: action,
        obscureText: obscure,
        obscuringCharacter: '•',
        validator: validator,
        onChanged: onChanged,
        style: GoogleFonts.nunito(
          fontSize: isTablet ? 7.sp : 6.sp,
          color: const Color(0xFF244065),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.nunito(
            fontSize: isTablet ? 7.sp : 6.sp,
            color: Colors.grey.shade400,
          ),
          errorStyle: GoogleFonts.nunito(
            fontSize: isTablet
                ? 6.sp
                : 5.sp, // 👈 adjust these values to your need
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: suffix,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: _border(),
          enabledBorder: _border(),
          focusedBorder: _border(color: const Color(0xFF244065), width: 1.5),
          errorBorder: _border(color: Colors.red),
          focusedErrorBorder: _border(color: Colors.red, width: 1.5),
        ),
      ),
    ],
  );

  Widget _buildLoginButton(bool isTablet) => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _onLogin,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFA8C59E),
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      ),
      child: _isLoading
          ? SizedBox(
              height: 18.h,
              width: 18.h,
              child: const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Text(
              "Login",
              style: GoogleFonts.nunito(
                fontSize: isTablet ? 7.sp : 6.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
    ),
  );

  OutlineInputBorder _border({
    Color color = const Color(0xFFE0E5E9),
    double width = 1.0,
  }) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(6.r),
    borderSide: BorderSide(color: color, width: width),
  );
}
