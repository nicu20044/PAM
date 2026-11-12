import 'package:flutter/material.dart';

class Review {
  final String name;
  final String avatar;
  final String time;
  final String text;
  final int stars;
  const Review({
    required this.name,
    this.avatar = '',
    required this.time,
    required this.text,
    this.stars = 5,
  });
}

class Product {
  final String id;
  final String name;
  final String category;
  final String description;
  final double price;
  final double rating;
  final int ratingCount;
  final int reviewCount;
  final List<String> images;
  final List<Color> colors;
  final List<String> sizes;
  final List<Review> reviews;
  final List<int> ratingDistribution;
  final bool featured;
  final bool recommended;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.images,
    this.description = '',
    this.rating = 4.5,
    this.ratingCount = 40,
    this.reviewCount = 12,
    this.colors = const [Color(0xFF1A1A1C), Color(0xFF9B9BA3), Color(0xFFE2C3A8)],
    this.sizes = const ['S', 'M', 'L'],
    this.reviews = const [],
    this.ratingDistribution = const [60, 25, 10, 3, 2],
    this.featured = false,
    this.recommended = false,
  });

  String get thumb => images.first;
}

class CartItem {
  final Product product;
  final int colorIndex;
  final String size;
  int qty;
  CartItem({
    required this.product,
    required this.colorIndex,
    required this.size,
    this.qty = 1,
  });
  double get total => product.price * qty;
}