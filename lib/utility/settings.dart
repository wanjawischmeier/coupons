import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Null> setBoolSetting(String setting, bool value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool(setting, value);
}

Future<bool> getBoolSetting(String setting, {bool defaultValue = false}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(setting) ?? defaultValue;
}

Future<Null> setStringSetting(String setting, String value) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(setting, value);
}

Future<String> getStringSetting(String setting, String defaultValue) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(setting) ?? defaultValue;
}

Future<void> showSettingDialog(BuildContext context, String defaultConfigUrl) {
  return showModalBottomSheet<void>(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Einstellungen'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              // Full screen mode
              Row(
                children: [
                  Text(
                    'Vollbildmodus aktivieren',
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return FutureBuilder<bool>(
                        future: getBoolSetting('enter_fullscreen'),
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
                                await setBoolSetting('enter_fullscreen', value);
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

              SizedBox(height: 60),

              // Shop List URL
              Text('URL der Shop-Liste', style: TextStyle(fontSize: 18)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return FutureBuilder<String>(
                      future: getStringSetting('shop_list_url', defaultConfigUrl),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<String> snapshot,
                      ) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          log('Error: ${snapshot.error}');
                          return Text('Error');
                        } else {
                          return TextField(
                            controller: TextEditingController(
                              text: snapshot.data,
                            ),
                            onChanged: (String value) async {
                              await setStringSetting('shop_list_url', value);
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: 'https://example.com/shop_list.yaml',
                              border: OutlineInputBorder(),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              Text(
                'Geben Sie die URL der Konfigurationsdatei ein, die die Liste der Shops enthält.',
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
