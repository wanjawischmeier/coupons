import 'dart:developer';
import 'package:coupons/utility/settings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;

class CodeScreen extends StatefulWidget {
  final Color backgroundColor;
  final Widget child;

  const CodeScreen({
    super.key,
    required this.backgroundColor,
    required this.child,
  });

  @override
  State<CodeScreen> createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      getSetting('enter_fullscreen').then((value) {
        if (value == true) {
          _enterFullscreen();
        }
      });
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
      log('Fullscreen request failed: $e');
    }
  }

  void _exitFullscreen() {
    try {
      html.document.exitFullscreen();
    } catch (e) {
      log('Exiting fullscreen failed: $e');
    }
  }

  Future<void> _showNotInteractableDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nicht interagierbar'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Du kannst mit den Elementen auf diesem Bildschirm nicht interagieren.',
                ),
                Text(
                  'Drücke "Zurück" oder auf die obere Leiste, um zum Hauptbildschirm zurückzukehren.',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: GestureDetector(
        onTap: _showNotInteractableDialog,
        child: Center(child: SizedBox(width: 500, child: widget.child)),
      ),
    );
  }
}
