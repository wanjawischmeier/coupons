import 'package:flutter/material.dart';
import 'package:coupons/theme/colors.dart';
import 'code_screen.dart';

class ReweCodeScreen extends StatelessWidget {
  const ReweCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CodeScreen(
      backgroundColor: AppColors.codeScreenBackgroundRewe,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/rewe/top_area.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Center(child: Image.asset('assets/rewe/center_area.png')),
          ),
          Image.asset(
            'assets/rewe/bottom_area.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
