import 'package:flutter/material.dart';

const kDefaultDescription =
    'Sportswear is no longer under culture, it is no longer indie or cobbled '
    'together as it once was. Sport is fashion today. The top is oversized in '
    'fit and style, may need to size down.';

class ColorOption {
  final String id;
  final String name;
  final Color color;
  const ColorOption({required this.id, required this.name, required this.color});
}

class Review {
  final String id;
  final String author;
  final String avatar;
  final String time;
  final String text;
  final double rating;
  const Review({
    required this.id,
    required this.author,
    this.avatar = '',
    required this.time,
    required this.text,
    this.rating = 5,
  });
}

class Product {
  final String id;
  final String name;
  final String category;
  final String currency;
  final String image;
  final String description;
  final double price;
  final double rating;
  final int ratingCount;
  final int reviewCount;
  final List<String> gallery;
  final List<ColorOption> colors;
  final List<String> sizes;
  final Map<String, bool> sizeAvailability;
  final String selectedSize;
  final int selectedColor;
  final List<int> ratingBreakdown; // procente pentru 5,4,3,2,1 stele
  final List<Review> reviews;
  final List<String> similarIds;
  final bool initiallyFavorite;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.category = 'women',
    this.currency = 'USD',
    this.description = kDefaultDescription,
    this.rating = 4.5,
    this.ratingCount = 40,
    this.reviewCount = 12,
    this.gallery = const [],
    this.colors = const [
      ColorOption(id: 'black', name: 'Black', color: Color(0xFF1A1A1C)),
      ColorOption(id: 'grey', name: 'Grey', color: Color(0xFF9B9BA3)),
      ColorOption(id: 'beige', name: 'Beige', color: Color(0xFFE2C3A8)),
    ],
    this.sizes = const ['S', 'M', 'L'],
    this.sizeAvailability = const {},
    this.selectedSize = 'L',
    this.selectedColor = 0,
    this.ratingBreakdown = const [60, 25, 10, 3, 2],
    this.reviews = const [],
    this.similarIds = const [],
    this.initiallyFavorite = false,
  });

  String get thumb => image;
  List<String> get images => gallery.isEmpty ? [image] : gallery;
  bool isSizeAvailable(String s) => sizeAvailability[s] ?? true;
}

class CategoryItem {
  final String id;
  final String name;
  final bool selected;
  const CategoryItem(
      {required this.id, required this.name, required this.selected});
}

class HeroBanner {
  final String id;
  final String title;
  final String image;
  final int slides;
  const HeroBanner(
      {required this.id,
        required this.title,
        required this.image,
        required this.slides});
}

class PromoCard {
  final String id;
  final String label;
  final String title;
  final String image;
  const PromoCard(
      {required this.id,
        required this.label,
        required this.title,
        required this.image});
}

/// Tot ce vine din JSON, deja transformat in obiecte.
class StoreData {
  final String storeName;
  final List<CategoryItem> categories;
  final HeroBanner hero;
  final List<Product> featured;
  final PromoCard newCollection;
  final List<Product> recommended;
  final List<PromoCard> topCollections;
  final List<PromoCard> categoryPromos;
  final List<Product> allProducts;

  const StoreData({
    required this.storeName,
    required this.categories,
    required this.hero,
    required this.featured,
    required this.newCollection,
    required this.recommended,
    required this.topCollections,
    required this.categoryPromos,
    required this.allProducts,
  });

  Product? byId(String id) {
    for (final p in allProducts) {
      if (p.id == id) return p;
    }
    return null;
  }

  List<Product> similarFor(Product p) {
    final fromJson = p.similarIds.map(byId).whereType<Product>().toList();
    if (fromJson.isNotEmpty) return fromJson;
    return allProducts.where((x) => x.id != p.id).take(4).toList();
  }
}

class CartItem {
  final Product product;
  final int colorIndex;
  final String size;
  final int qty;

  const CartItem({
    required this.product,
    required this.colorIndex,
    required this.size,
    this.qty = 1,
  });

  String get key => '${product.id}|$colorIndex|$size';
  double get total => product.price * qty;

  CartItem copyWith({int? qty}) => CartItem(
    product: product,
    colorIndex: colorIndex,
    size: size,
    qty: qty ?? this.qty,
  );
}