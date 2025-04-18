import 'package:coupons/widgets/shop_grid_cell.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static const List<Map<String, dynamic>> items = [
    {'image': 'assets/rewe/logo.png', 'route': '/code_screen/rewe', 'enabled': true},
    {'image': 'assets/dm/logo.png', 'route': '/code_screen/dm', 'enabled': true},
    {'enabled': false},
    {'enabled': false},
    {'enabled': false},
    {'enabled': false},
  ];

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Coupons')),
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
                    children: items.map((item) {
                      final enabled = item['enabled'] == true;
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 100,
                          maxHeight: 100,
                        ),
                        child: ShopGridCell(
                          imagePath: enabled ? item['image'] : null,
                          onTap: enabled
                              ? () => Navigator.pushNamed(context, item['route'])
                              : () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Mehr Läden kommen bald!'),
                                    ),
                                  );
                                },
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
