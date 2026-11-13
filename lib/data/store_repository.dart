
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

Color _hex(String hex) =>
    Color(int.parse(hex.replaceFirst('#', ''), radix: 16) |
    0xFF000000);

class StoreRepository {
  static const _path = 'assets/data/lab_v1.json';

  Future<StoreData> load() async {
    await Future.delayed(const Duration(milliseconds: 900));

    final raw = await rootBundle.loadString(_path);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    return _parse(json);
  }

  StoreData _parse(Map<String, dynamic> json) {
    final home = json['homePage'] as Map<String, dynamic>;
    final page =
    json['productPage']['product'] as Map<String, dynamic>;

    final detail = _parseDetail(page);
    final details = {detail.id: detail};

    Product resolve(Map<String, dynamic> j) {
      final basic = _parseBasic(j);
      return details[basic.id] ?? basic;
    }

    List<Product> list(dynamic raw) => (raw as List)
        .map((e) => resolve(e as Map<String, dynamic>))
        .toList();

    final featured = list(home['featureProducts']);
    final recommended = list(home['recommended']);
    final similar = list(page['similarProducts']);

    final all = <String, Product>{};

    for (final p in [...featured, ...recommended, detail, ...similar]) {
      all.putIfAbsent(p.id, () => p);
    }

    final hero = home['heroBanner'] as Map<String, dynamic>;
    final nc = home['newCollection'] as Map<String, dynamic>;

    return StoreData(
      storeName: home['storeName'] as String,

      categories: (home['categories'] as List)
          .map((c) => CategoryItem(
        id: c['id'],
        name: c['name'],
        selected: c['selected'] ?? false,
      ))
          .toList(),

      hero: HeroBanner(
        id: hero['id'],
        title: hero['title'],
        image: hero['imageUrl'],
        slides: (hero['slides'] as num?)?.toInt() ?? 1,
      ),

      featured: featured,

      newCollection: PromoCard(
        id: 'newCollection',
        label: nc['label'],
        title: nc['title'],
        image: nc['imageUrl'],
      ),

      recommended: recommended,

      topCollections: (home['topCollections'] as List)
          .map((c) => PromoCard(
        id: c['id'],
        label: c['label'],
        title: c['title'],
        image: c['imageUrl'],
      ))
          .toList(),

      categoryPromos: (home['categoryPromos'] as List)
          .map((c) => PromoCard(
        id: c['id'],
        label: c['category'],
        title: c['title'],
        image: c['imageUrl'],
      ))
          .toList(),

      allProducts: all.values.toList(),
    );
  }

  Product _parseBasic(Map<String, dynamic> j) {
    return Product(
      id: j['id'] as String,
      name: j['name'],
      price: (j['price'] as num).toDouble(),
      currency: j['currency'] ?? 'USD',
      image: j['imageUrl'],
    );
  }

  Product _parseDetail(Map<String, dynamic> j) {
    final id = j['id'] as String;

    final colors = (j['availableColors'] as List)
        .map((c) => ColorOption(
      id: c['id'],
      name: c['name'],
      color: _hex(c['value']),
    ))
        .toList();

    final selectedColorIndex =
    colors.indexWhere((c) => c.id == j['selectedColor']);

    return Product(
      id: id,
      name: j['name'],
      price: (j['price'] as num).toDouble(),
      currency: j['currency'] ?? 'USD',

      // Imaginea principală vine direct din JSON.
      image: j['mainImageUrl'],

      // Galeria conține exclusiv URL-urile din JSON.
      gallery: List<String>.from(j['galleryImageUrls'] ?? []),

      rating: (j['rating'] as num).toDouble(),
      ratingCount: (j['ratingCount'] as num).toInt(),
      reviewCount: (j['reviewCount'] as num).toInt(),

      description: j['description'] ?? kDefaultDescription,

      colors: colors,
      selectedColor: selectedColorIndex < 0 ? 0 : selectedColorIndex,

      sizes: List<String>.from(j['availableSizes']),
      selectedSize: j['selectedSize'] ?? 'L',

      sizeAvailability: (j['sizeAvailability'] as Map)
          .map((k, v) => MapEntry(k as String, v as bool)),

      ratingBreakdown: (j['ratingBreakdown'] as List)
          .map((e) => (e['percentage'] as num).toInt())
          .toList(),

      reviews: (j['reviews'] as List)
          .map((r) => Review(
        id: r['id'],
        author: r['author'],
        avatar: r['avatarUrl'] ?? '',
        rating: (r['rating'] as num).toDouble(),
        time: r['createdAtLabel'],
        text: r['text'],
      ))
          .toList(),

      similarIds: (j['similarProducts'] as List)
          .map((e) => e['id'] as String)
          .toList(),

      initiallyFavorite:
      (j['actions']?['isFavorite'] ?? false) as bool,
    );
  }
}
