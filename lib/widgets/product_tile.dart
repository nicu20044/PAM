import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_screen.dart';
import '../theme/app_theme.dart';
import 'app_image.dart';

void openProduct(BuildContext context, Product p) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (_) => ProductScreen(product: p)));
}

/// Card vertical (imagine + nume + pret) - Feature Products / Similar Product.
class ProductTile extends StatelessWidget {
  final Product product;
  final double width;
  final double imageHeight;
  const ProductTile({
    super.key,
    required this.product,
    this.width = 110,
    this.imageHeight = 150,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openProduct(context, product),
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                  width: width,
                  height: imageHeight,
                  child: AppImage(product.thumb)),
            ),
            const SizedBox(height: 10),
            Text(product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(money(product.price),
                style:
                const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

/// Card orizontal mic - Recommended.
class RecommendedCard extends StatelessWidget {
  final Product product;
  const RecommendedCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openProduct(context, product),
      child: Container(
        width: 215,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                  width: 56, height: 56, child: AppImage(product.thumb)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 11.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  Text(money(product.price),
                      style: const TextStyle(
                          fontSize: 13.5, fontWeight: FontWeight.w800)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}