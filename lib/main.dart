import 'package:coupons/screens/shop_code/dm_code_screen.dart';
import 'package:coupons/screens/shop_code/rewe_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'theme/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(CouponApp());
}

class CouponApp extends StatelessWidget {
  const CouponApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coupons',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.accent,
          surface: AppColors.background,
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      home: HomeScreen(),
      routes: {
        '/code_screen/dm': (context) => DmCodeScreen(),
        '/code_screen/rewe': (context) => ReweCodeScreen(),
      },
    );
  }
}
