import 'package:coupons/screens/shop_code/dynamic_code_screen.dart';
import 'package:coupons/theme/colors.dart';
import 'package:coupons/utility/database.dart';
import 'package:coupons/utility/settings.dart';
import 'package:coupons/widgets/shop_grid_cell.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String defaultConfigUrl; // e.g. 'https://example.com/shop_list.yaml'
  const HomeScreen({super.key, required this.defaultConfigUrl});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _shopListFuture;

  @override
  void initState() {
    super.initState();
    _shopListFuture = fetchShopListConfig(widget.defaultConfigUrl);
  }

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

  void openShopScreen(BuildContext context, Map<String, dynamic> shop) {
    final configUrl = shop['config_url'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => DynamicCodeScreen(
              configUrl: configUrl,
              backgroundColor: AppColors.background, // Or get from config
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Coupons',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed:
                () => showSettingDialog(context, widget.defaultConfigUrl),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _shopListFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Fehler: ${snapshot.error}'));
                }

                final items = snapshot.data!;
                final List<Widget> gridCells =
                    items
                        .map(
                          (item) => ShopGridCell(
                            imageUrl: item['logo_url'],
                            onTap: () => openShopScreen(context, item),
                          ),
                        )
                        .toList();

                // Pad with empty cells if less than 6
                while (gridCells.length < 6) {
                  gridCells.add(ShopGridCell(onTap: showComingSoonDialog));
                }

                return Center(
                  child: SizedBox(
                    width: 400,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        children: gridCells,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(20.0),
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
