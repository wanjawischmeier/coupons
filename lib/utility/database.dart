import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart';

Future<String> fetchTextFile(String url) async {
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      log('Failed to load file: ${response.statusCode}');
      return '';
    }
  } catch (e) {
    log('Error fetching file: $e');
    return '';
  }
}

Future<Map<String, dynamic>> fetchLayoutConfig(String url) async {
  final rawLayout = await fetchTextFile(url);
  if (rawLayout.trim().isEmpty) {
    throw Exception('Failed to load layout from URL: $url');
  }

  log('Raw layout: $rawLayout');

  final yamlData = loadYaml(rawLayout) as YamlMap;

  // Convert YamlMap recursively into a regular Map
  dynamic convertYaml(dynamic node) {
    if (node is YamlMap) {
      return Map<String, dynamic>.fromEntries(
        node.entries.map(
          (e) => MapEntry(e.key.toString(), convertYaml(e.value)),
        ),
      );
    } else if (node is YamlList) {
      return node.map((e) => convertYaml(e)).toList();
    } else {
      return node;
    }
  }

  return convertYaml(yamlData);
}

List<Widget> buildWidgetsFromConfig(
  List<Map<String, dynamic>> config,
  BuildContext context,
) {
  return config.map<Widget>((item) {
    switch (item['type']) {
      case 'image':
        final image = CachedNetworkImage(
          imageUrl: item['url'],
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.contain,
        );

        final imageWidget =
            item['expanded'] == true ? Expanded(child: image) : image;

        return item['goBack'] == true
            ? GestureDetector(
              onTap: () => Navigator.pop(context),
              child: imageWidget,
            )
            : imageWidget;

      case 'spacer':
        return item['height'] == null
            ? Spacer()
            : SizedBox(height: (item['height']).toDouble());

      default:
        return SizedBox.shrink();
    }
  }).toList();
}

Future<List<Map<String, dynamic>>> fetchShopListConfig(String url) async {
  final raw = await fetchTextFile(url);
  if (raw.trim().isEmpty)
    throw Exception('Shop list config is empty or missing. Raw: $raw');

  final yamlData = loadYaml(raw);
  final rawList = yamlData['shop_list'];

  if (rawList is YamlList) {
    return rawList.map((e) => Map<String, dynamic>.from(e)).toList();
  } else {
    throw Exception('Invalid format for shop_list');
  }
}
