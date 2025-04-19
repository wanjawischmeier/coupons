import 'package:flutter/material.dart';
import 'package:coupons/theme/colors.dart';
import 'code_screen.dart';

class DmCodeScreen extends StatelessWidget {
  const DmCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CodeScreen(
      backgroundColor: AppColors.codeScreenBackgroundDm,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/dm/top_area.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Image.asset(
            'assets/dm/center_area.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Spacer(),
          Image.asset(
            'assets/dm/bottom_area.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
