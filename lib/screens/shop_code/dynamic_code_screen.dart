import 'package:coupons/screens/shop_code/code_screen.dart';
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
  late Future<List<Map<String, dynamic>>> _config;

  @override
  void initState() {
    super.initState();
    _config = fetchLayoutConfig(widget.configUrl);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _config,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CodeScreen(
            backgroundColor: widget.backgroundColor,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return CodeScreen(
            backgroundColor: widget.backgroundColor,
            child: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final widgets = buildWidgetsFromConfig(snapshot.data!, context);
        return CodeScreen(
          backgroundColor: widget.backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: widgets,
          ),
        );
      },
    );
  }
}
