import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:coupons/theme/colors.dart';

class ReweCodeScreen extends StatefulWidget {
  const ReweCodeScreen({super.key});

  @override
  State<ReweCodeScreen> createState() => _ReweCodeScreenState();
}

class _ReweCodeScreenState extends State<ReweCodeScreen> {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _enterFullscreen();
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      _exitFullscreen();
    }
    super.dispose();
  }

  void _enterFullscreen() {
    try {
      html.document.documentElement?.requestFullscreen();
    } catch (e) {
      print('Fullscreen request failed: $e');
    }
  }

  void _exitFullscreen() {
    try {
      html.document.exitFullscreen();
    } catch (e) {
      print('Exiting fullscreen failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.codeScreenBackgroundRewe,
      body: Center(
        child: SizedBox(
          width: 500,
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
        ),
      ),
    );
  }
}
