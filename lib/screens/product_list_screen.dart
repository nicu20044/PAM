import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog.dart';
import '../models/product.dart';
import '../state/favorites_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/product_tile.dart';

class ProductListScreen extends StatelessWidget {
  final String title;
  final List<Product> products;
  final bool favoritesOnly;

  const ProductListScreen({
    super.key,
    required this.title,
    required this.products,
    this.favoritesOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final favs = context.watch<FavoritesState>();
    final list = favoritesOnly
        ? Catalog.all.where((p) => favs.isFavorite(p.id)).toList()
        : products;

    return Scaffold(
      appBar: AppBar(
        title: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      ),
      body: list.isEmpty
          ? Center(
        child: Text(
          favoritesOnly ? 'No favorites yet' : 'No products found',
          style: const TextStyle(color: AppColors.grey),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 20,
          childAspectRatio: 0.66,
        ),
        itemCount: list.length,
        itemBuilder: (_, i) {
          final p = list[i];
          return GestureDetector(
            onTap: () => openProduct(context, p),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AppImage(p.thumb),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: GestureDetector(
                          onTap: () => favs.toggle(p.id),
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.white,
                            child: Icon(
                              favs.isFavorite(p.id)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 16,
                              color: favs.isFavorite(p.id)
                                  ? const Color(0xFFE5484D)
                                  : AppColors.ink,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(p.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w500)),
                const SizedBox(height: 3),
                Text(money(p.price),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w800)),
              ],
            ),
          );
        },
      ),
    );
  }
}