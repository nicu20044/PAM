import 'package:flutter/material.dart';
import '../models/product.dart';

const _desc =
    'Sportswear is no longer under culture, it is no longer indie or cobbled '
    'together as it once was. Sport is fashion today. The top is oversized in '
    'fit and style, may need to size down.';

const _reviews = [
  Review(
    name: 'Jennifer Rose',
    avatar: 'avatar_jennifer.png',
    time: '5m ago',
    text:
    'I love it. Awesome customer service!! Helped me out with adding an additional item to my order. Thanks again!',
  ),
  Review(
    name: 'Kelly Rihana',
    avatar: 'avatar_kelly.png',
    time: '9m ago',
    text:
    "I'm very happy with order. It was delivered on and good quality. Recommended!",
  ),
];

class Catalog {
  static const all = <Product>[
    // ---------------- WOMEN ----------------
    Product(
      id: 'turtleneck',
      name: 'Turtleneck Sweater',
      category: 'women',
      price: 39.99,
      images: ['turtleneck.png'],
      description: _desc,
      featured: true,
      reviews: _reviews,
    ),
    Product(
      id: 'long_dress',
      name: 'Long Sleeve Dress',
      category: 'women',
      price: 45.00,
      images: ['long_dress.png'],
      description: _desc,
      featured: true,
      reviews: _reviews,
    ),
    Product(
      id: 'sportswear',
      name: 'Sportswear Set',
      category: 'women',
      price: 80.00,
      images: ['sportswear_1.png', 'sportswear_2.png'],
      description: _desc,
      rating: 4.9,
      ratingCount: 83,
      reviewCount: 47,
      ratingDistribution: [80, 12, 5, 3, 0],
      colors: [Color(0xFFE2C3A8), Color(0xFF000000), Color(0xFFDD6B6B)],
      featured: true,
      reviews: _reviews,
    ),
    Product(
      id: 'hoodie',
      name: 'White fashion hoodie',
      category: 'women',
      price: 29.00,
      images: ['hoodie.png'],
      description: _desc,
      recommended: true,
      reviews: _reviews,
    ),
    Product(
      id: 'cotton_tshirt',
      name: 'Cotton T-shirt',
      category: 'women',
      price: 30.00,
      images: ['tshirt_black.png'],
      description: _desc,
      recommended: true,
      reviews: _reviews,
    ),
    Product(
      id: 'rise_crop_hoodie',
      name: 'Rise Crop Hoodie',
      category: 'women',
      price: 43.00,
      images: ['rise_crop_hoodie.png'],
      description: _desc,
      reviews: _reviews,
    ),
    Product(
      id: 'gym_crop_top',
      name: 'Gym Crop Top',
      category: 'women',
      price: 39.99,
      images: ['gym_crop_top.png'],
      description: _desc,
      reviews: _reviews,
    ),
    Product(
      id: 'sport_sweatshirt',
      name: 'Sport Sweatshirt',
      category: 'women',
      price: 47.99,
      images: ['sport_sweatshirt.png'],
      description: _desc,
      reviews: _reviews,
    ),
    // ---------------- MEN ----------------
    Product(
      id: 'men_jacket',
      name: 'Denim Jacket',
      category: 'men',
      price: 59.00,
      images: ['men_jacket.png'],
      description: _desc,
      featured: true,
      reviews: _reviews,
    ),
    Product(
      id: 'men_shirt',
      name: 'Oxford Shirt',
      category: 'men',
      price: 35.50,
      images: ['men_shirt.png'],
      description: _desc,
      featured: true,
      recommended: true,
      reviews: _reviews,
    ),
    // ---------------- ACCESSORIES ----------------
    Product(
      id: 'sunglasses',
      name: 'Classic Sunglasses',
      category: 'accessories',
      price: 25.00,
      images: ['sunglasses.png'],
      description: _desc,
      sizes: ['One size'],
      featured: true,
      reviews: _reviews,
    ),
    Product(
      id: 'handbag',
      name: 'Leather Handbag',
      category: 'accessories',
      price: 79.00,
      images: ['handbag.png'],
      description: _desc,
      sizes: ['One size'],
      featured: true,
      reviews: _reviews,
    ),
    // ---------------- BEAUTY ----------------
    Product(
      id: 'lipstick',
      name: 'Matte Lipstick',
      category: 'beauty',
      price: 18.00,
      images: ['lipstick.png'],
      description: _desc,
      sizes: ['3.5g'],
      colors: [Color(0xFFB3202E), Color(0xFFD9798C), Color(0xFF7A2E3A)],
      featured: true,
      reviews: _reviews,
    ),
    Product(
      id: 'perfume',
      name: 'Eau de Parfum',
      category: 'beauty',
      price: 55.00,
      images: ['perfume.png'],
      description: _desc,
      sizes: ['30ml', '50ml', '100ml'],
      featured: true,
      reviews: _reviews,
    ),
  ];

  static List<Product> byCategory(String c) =>
      all.where((p) => p.category == c).toList();

  static List<Product> featured(String c) =>
      all.where((p) => p.category == c && p.featured).toList();

  static List<Product> recommended() =>
      all.where((p) => p.recommended).toList();

  static List<Product> similar(Product p) =>
      all.where((x) => x.category == p.category && x.id != p.id).take(5).toList();
}