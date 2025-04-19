import 'dart:developer';

import 'package:coupons/utility/settings.dart';
import 'package:coupons/widgets/shop_grid_cell.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const List<Map<String, dynamic>> items = [
    {
      'image': 'assets/rewe/logo.png',
      'route': '/code_screen/rewe',
      'enabled': true,
    },
    {
      'image': 'assets/dm/logo.png',
      'route': '/code_screen/dm',
      'enabled': true,
    },
    {'enabled': false},
    {'enabled': false},
    {'enabled': false},
    {'enabled': false},
  ];

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> showComingSoonDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Coming soon'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text('Mehr Shops kommen bald!')],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Nice'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<void> showSettingDialog() {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Einstellungen'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    children: [
                      Text('Vollbildmodus aktivieren', style: TextStyle(fontSize: 18)),
                      Spacer(),
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return FutureBuilder<bool>(
                            future: getSetting('enter_fullscreen'),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<bool> snapshot,
                            ) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                log('Error: ${snapshot.error}');
                                return Text('Error');
                              } else {
                                return Switch(
                                  value: snapshot.data ?? false,
                                  onChanged: (bool value) async {
                                    await setSetting('enter_fullscreen', value);
                                    setState(() {});
                                  },
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Wechseln Sie auf Couponcode-Seiten in den Vollbildmodus (um die Navigationsleiste des Browsers zu verstecken).',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Coupons', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: showSettingDialog,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: SizedBox(
                width: 400, // Set a fixed width for the grid
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children:
                        items.map((item) {
                          final enabled = item['enabled'] == true;
                          return ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 100,
                              maxHeight: 100,
                            ),
                            child: ShopGridCell(
                              imagePath: enabled ? item['image'] : null,
                              onTap:
                                  enabled
                                      ? () => Navigator.pushNamed(
                                        context,
                                        item['route'],
                                      )
                                      : showComingSoonDialog,
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'Die Coupons sind nur in Deutschland gültig.',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
