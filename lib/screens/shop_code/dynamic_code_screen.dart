import 'dart:developer';

import 'package:coupons/screens/shop_code/code_screen.dart';
import 'package:coupons/theme/colors.dart';
import 'package:coupons/utility/database.dart';
import 'package:flutter/material.dart';

class DynamicCodeScreen extends StatefulWidget {
  final Color backgroundColor;
  final String configUrl;

  const DynamicCodeScreen({
    super.key,
    required this.backgroundColor,
    required this.configUrl,
  });

  @override
  State<DynamicCodeScreen> createState() => _DynamicCodeScreenState();
}

class _DynamicCodeScreenState extends State<DynamicCodeScreen> {
  late Future<Map<String, dynamic>> _config;
  late Color? _configBackgroundColor;

  @override
  void initState() {
    super.initState();
    _config = fetchLayoutConfig(widget.configUrl);
    _config.then((value) {
      if (value['code_page_bg_color'] == null) {
        log('Invalid or missing layout background color in config');
      } else {
        log('Background color from config: ${value['code_page_bg_color']}');
        _configBackgroundColor = Color(value['code_page_bg_color']);
      }
    }).catchError((error) {
      log('Error fetching config: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _config.then((value) {
        final rawLayout = value['code_page_layout'];
        if (rawLayout is List) {
          return rawLayout
              .whereType<Map>() // just in case, narrows down types
              .map((e) => Map<String, dynamic>.from(e))
              .toList();
        } else {
          throw Exception('Invalid or missing layout in config');
        }
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CodeScreen(
            backgroundColor: AppColors.background,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return CodeScreen(
            backgroundColor: AppColors.background,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final widgets = buildWidgetsFromConfig(snapshot.data!, context);
        return CodeScreen(
          backgroundColor: _configBackgroundColor ?? widget.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widgets,
          ),
        );
      },
    );
  }
}
