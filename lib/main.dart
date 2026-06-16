import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/SignInScreen.dart';
import 'screens/TeaSheet.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final Future<Widget> _initialScreenFuture;

  @override
  void initState() {
    super.initState();
    _initialScreenFuture = _getInitialScreen();
  }

  Future<Widget> _getInitialScreen() async {
    const storage = FlutterSecureStorage();

    try {
      final String? isLoggedIn = await storage.read(key: 'isLoggedIn');
      final String? token = await storage.read(key: 'accessToken');

      debugPrint('isLoggedIn = $isLoggedIn');
      debugPrint('accessToken = $token');

      if (isLoggedIn == 'true' && token != null && token.isNotEmpty) {
        return TeaSheet(userId: '',);
      }

      return const SignInScreen();
    } catch (e) {
      debugPrint('Storage Error: $e');
      return const SignInScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorObservers: [routeObserver],
          theme: ThemeData(textTheme: GoogleFonts.nunitoTextTheme()),
          home: FutureBuilder<Widget>(
            future: _initialScreenFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasData) {
                return snapshot.data!;
              }

              return const SignInScreen();
            },
          ),
        );
      },
    );
  }
}
