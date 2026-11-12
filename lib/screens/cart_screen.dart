import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/cart_state.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      ),
      body: cart.items.isEmpty
          ? const Center(
          child: Text('Your cart is empty',
              style: TextStyle(color: AppColors.grey)))
          : Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: cart.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (_, i) {
                final item = cart.items[i];
                final p = item.product;
                return Dismissible(
                  key: ObjectKey(item),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => cart.remove(item),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5484D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.delete_outline,
                        color: Colors.white),
                  ),
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
                              width: 72,
                              height: 88,
                              child: AppImage(p.thumb)),
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
                              Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: p.colors[item.colorIndex],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text('Size ${item.size}',
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.grey)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(money(item.total),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800)),
                                  Row(
                                    children: [
                                      _qtyBtn(Icons.remove,
                                              () => cart.decrement(item)),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text('${item.qty}',
                                            style: const TextStyle(
                                                fontWeight:
                                                FontWeight.w700)),
                                      ),
                                      _qtyBtn(Icons.add,
                                              () => cart.increment(item)),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(
                20, 18, 20, 18 + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.line)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.grey)),
                    Text(money(cart.total),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.dark,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => _checkout(context, cart),
                    child: const Text('Checkout',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.line),
      ),
      child: Icon(icon, size: 15),
    ),
  );

  void _checkout(BuildContext context, CartState cart) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Order placed'),
        content: Text('Thank you! Total paid: ${money(cart.total)}'),
        actions: [
          TextButton(
            onPressed: () {
              cart.clear();
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}