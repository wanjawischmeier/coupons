import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:coupons/theme/colors.dart';

class DmCodeScreen extends StatefulWidget {
  const DmCodeScreen({super.key});

  @override
  State<DmCodeScreen> createState() => _DmCodeScreenState();
}

class _DmCodeScreenState extends State<DmCodeScreen> {
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
        ),
      ),
    );
  }
}
