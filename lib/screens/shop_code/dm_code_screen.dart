import 'package:coupons/theme/colors.dart';
import 'package:flutter/material.dart';

class DmCodeScreen extends StatelessWidget {
  const DmCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.codeScreenBackgroundDm,
      body: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Image.asset(
              'assets/dm/top_area.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
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
