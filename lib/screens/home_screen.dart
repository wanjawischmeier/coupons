import 'package:coupons/utility/database.dart';
import 'package:coupons/widgets/shop_grid_cell.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final String configUrl; // e.g. 'https://example.com/shop_list.yaml'
  const HomeScreen({super.key, required this.configUrl});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _shopListFuture;

  @override
  void initState() {
    super.initState();
    _shopListFuture = fetchShopListConfig(widget.configUrl);
  }

  void showComingSoonDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("Bald verfügbar"),
        content: Text("Dieser Shop ist bald verfügbar."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coupons', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black),
            onPressed: () {}, // Replace with your handler
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
                        children: items.map((item) {
                          final route = '/code_screen/${item['name']?.toLowerCase()}';
                          final enabled = item['enabled'] != false;

                          return ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxWidth: 100,
                              maxHeight: 100,
                            ),
                            child: ShopGridCell(
                              imageUrl: item['logo_url'],
                              onTap: enabled
                                  ? () => Navigator.pushNamed(context, route)
                                  : showComingSoonDialog,
                            ),
                          );
                        }).toList(),
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
