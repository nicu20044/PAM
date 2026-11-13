import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/catalog_cubit.dart';
import '../cubits/favorites_cubit.dart';
import '../screens/cart_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/products_screen.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _go(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartCubit>().count;
    final favCount = context.watch<FavoritesCubit>().state.length;
    final all = context.read<CatalogCubit>().state.data?.allProducts ?? [];

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Text('GemStore',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Search products'),
              onTap: () => _go(
                  context, ProductsScreen(title: 'All products', products: all)),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Favorites'),
              trailing: favCount == 0
                  ? null
                  : Text('$favCount',
                  style: const TextStyle(color: AppColors.grey)),
              onTap: () => _go(context, const FavoritesScreen()),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Cart'),
              trailing: cartCount == 0
                  ? null
                  : CircleAvatar(
                radius: 11,
                backgroundColor: AppColors.dark,
                child: Text('$cartCount',
                    style: const TextStyle(
                        fontSize: 11, color: Colors.white)),
              ),
              onTap: () => _go(context, const CartScreen()),
            ),
          ],
        ),
      ),
    );
  }
}