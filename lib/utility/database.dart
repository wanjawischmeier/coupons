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


Future<List<Map<String, dynamic>>> fetchLayoutConfig(String url) async {
  final rawLayout = await fetchTextFile(url);
  if (rawLayout == '') {
    throw Exception('Failed to load layout');
  }

  final yamlData = loadYaml(rawLayout) as YamlMap;
  final layoutList = yamlData['layout'] as YamlList;

  // Convert YamlMap/YamlList into plain Dart Map/List
  return layoutList.map((item) => Map<String, dynamic>.from(item)).toList();
}

List<Widget> buildWidgetsFromConfig(List<Map<String, dynamic>> config, BuildContext context) {
  return config.map<Widget>((item) {
    switch (item['type']) {
      case 'image':
        final image = CachedNetworkImage(
          imageUrl: item['url'],
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
          width: double.infinity,
        );

        final imageWidget = item['expanded'] == true
            ? Expanded(child: image)
            : image;

        return item['goBack'] == true
            ? GestureDetector(
                onTap: () => Navigator.pop(context),
                child: imageWidget,
              )
            : imageWidget;

      case 'spacer':
        return SizedBox(height: (item['height'] ?? 16).toDouble());

      default:
        return SizedBox.shrink();
    }
  }).toList();
}
