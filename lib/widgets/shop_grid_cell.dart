import 'package:flutter/material.dart';

class ShopGridCell extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onTap;

  const ShopGridCell({super.key, 
    this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: imagePath == null ? Colors.grey[300] : null,
          child: imagePath != null
              ? Image.asset(
                  imagePath!,
                  fit: BoxFit.cover,
                )
              : null,
        ),
      ),
    );
  }
}
