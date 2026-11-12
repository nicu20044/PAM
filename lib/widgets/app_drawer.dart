import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/catalog.dart';
import '../screens/cart_screen.dart';
import '../screens/product_list_screen.dart';
import '../state/cart_state.dart';
import '../state/favorites_state.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  void _go(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartState>();
    final favs = context.watch<FavoritesState>();
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
              leading: const Icon(Icons.grid_view_rounded),
              title: const Text('All products'),
              onTap: () => _go(
                  context,
                  const ProductListScreen(
                      title: 'All products', products: Catalog.all)),
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Favorites'),
              trailing: favs.ids.isEmpty
                  ? null
                  : Text('${favs.ids.length}',
                  style: const TextStyle(color: AppColors.grey)),
              onTap: () => _go(
                  context,
                  const ProductListScreen(
                      title: 'Favorites', products: [], favoritesOnly: true)),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Cart'),
              trailing: cart.count == 0
                  ? null
                  : CircleAvatar(
                radius: 11,
                backgroundColor: AppColors.dark,
                child: Text('${cart.count}',
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