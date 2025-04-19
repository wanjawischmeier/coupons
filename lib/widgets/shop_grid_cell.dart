import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShopGridCell extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback? onTap;

  const ShopGridCell({super.key, this.imageUrl, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: imageUrl == null ? Colors.grey[300] : null,
          child:
              imageUrl != null
                  ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.contain,
                  )
                  : null,
        ),
      ),
    );
  }
}
