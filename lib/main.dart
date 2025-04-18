import 'package:coupons/screens/shop_code/dm_code_screen.dart';
import 'package:coupons/screens/shop_code/rewe_code_screen.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'theme/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
