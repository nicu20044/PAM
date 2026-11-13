import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/catalog_cubit.dart';
import '../cubits/favorites_cubit.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/product_tile.dart';
import '../widgets/status_views.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ids = context.watch<FavoritesCubit>().state;
    final data = context.watch<CatalogCubit>().state.data;
    final List<Product> products = data == null
        ? []
        : data.allProducts.where((p) => ids.contains(p.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      ),
      body: products.isEmpty
          ? const EmptyView(
        icon: Icons.favorite_border,
        title: 'No favorites yet',
        subtitle: 'Tap the heart on a product to save it here',
      )
          : ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (_, i) {
          final p = products[i];
          return GestureDetector(
            onTap: () => openProduct(context, p),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.light,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                        width: 64, height: 78, child: AppImage(p.thumb)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.name,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 4),
                        Text(money(p.price),
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite,
                        color: Color(0xFFE5484D)),
                    onPressed: () =>
                        context.read<FavoritesCubit>().toggle(p.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}