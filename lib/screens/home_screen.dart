import 'dart:async';

import 'package:flutter/material.dart';

import '../data/catalog.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_image.dart';
import '../widgets/collection_cards.dart';
import '../widgets/product_tile.dart';
import '../widgets/section_header.dart';
import 'product_list_screen.dart';

const _categories = [
  ('women', 'Women', Icons.female),
  ('men', 'Men', Icons.male),
  ('accessories', 'Accessories', Icons.visibility_outlined),
  ('beauty', 'Beauty', Icons.spa_outlined),
];

const _banners = [
  ('Autumn\nCollection\n2021', 'banner_1.png', Color(0xFFC98B7B)),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _category = 'women';
  bool _unread = true;
  int _bannerIndex = 0;
  final _bannerController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (_banners.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!_bannerController.hasClients) return;
        final next = (_bannerIndex + 1) % _banners.length;
        _bannerController.animateToPage(next,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut);
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  void _openList(String title, List<Product> products) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductListScreen(
          title: title,
          products: products,
        ),
      ),
    );
  }

  void _showNotifications() {
    setState(() => _unread = false);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => const Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.local_offer_outlined),
              title: Text('Sale up to 40% on selected items'),
              subtitle: Text('Just now'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.new_releases_outlined),
              title: Text('New collection is live'),
              subtitle: Text('2h ago'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final featured = Catalog.featured(_category);

    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            _topBar(),
            const SizedBox(height: 22),
            _categoryRow(),
            const SizedBox(height: 22),
            _bannerCarousel(),
            const SizedBox(height: 26),
            SectionHeader(
              title: 'Feature Products',
              onShowAll: () => _openList('Feature Products', featured),
            ),
            const SizedBox(height: 14),
            SizedBox(
              height: 205,
              child: featured.isEmpty
                  ? const Center(child: Text('No products yet'))
                  : ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: featured.length,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (_, i) => ProductTile(product: featured[i]),
              ),
            ),
            const SizedBox(height: 24),
            // Bannerul "Hang out & Party" - imaginea contine deja tot designul
            GestureDetector(
              onTap: () =>
                  _openList('New Collection', Catalog.byCategory('women')),
              child: AspectRatio(
                aspectRatio: 375 / 158,
                child: AppImage('promo_hangout.png'),
              ),
            ),
            const SizedBox(height: 28),
            SectionHeader(
              title: 'Recommended',
              onShowAll: () => _openList('Recommended', Catalog.recommended()),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 78,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
                itemCount: Catalog.recommended().length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) =>
                    RecommendedCard(product: Catalog.recommended()[i]),
              ),
            ),
            const SizedBox(height: 22),
            SectionHeader(
              title: 'Top Collection',
              onShowAll: () => _openList('Top Collection', Catalog.all),
            ),
            const SizedBox(height: 14),
            CollectionCard(
              height: 118,
              tag: 'Sale up to 40%',
              title: 'FOR SLIM\n& BEAUTY',
              image: 'promo_slim.png',
              circleColor: const Color(0xFFEDEBE3),
              onTap: () =>
                  _openList('Sale up to 40%', Catalog.byCategory('women')),
            ),
            const SizedBox(height: 14),
            CollectionCard(
              height: 175,
              boldTitle: true,
              tag: 'Summer Collection 2021',
              title: 'Most sexy\n& fabulous\ndesign',
              image: 'promo_summer.png',
              circleColor: const Color(0xFFEDEBE3),
              onTap: () =>
                  _openList('Summer Collection', Catalog.byCategory('women')),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CollectionTile(
                    label: 'T-Shirts',
                    title: 'The Office\nLife',
                    image: 'tile_tshirts.png',
                    imageLeft: true,
                    onTap: () =>
                        _openList('T-Shirts', Catalog.byCategory('women')),
                  ),
                  const SizedBox(width: 10),
                  CollectionTile(
                    label: 'Dresses',
                    title: 'Elegant\nDesign',
                    image: 'tile_dresses.png',
                    imageLeft: false,
                    onTap: () =>
                        _openList('Dresses', Catalog.byCategory('women')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 20, height: 2, color: AppColors.ink),
                    const SizedBox(height: 5),
                    Container(width: 13, height: 2, color: AppColors.ink),
                  ],
                ),
              ),
            ),
          ),
          const Text('GemStore',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
          GestureDetector(
            onTap: _showNotifications,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none_rounded, size: 24),
                  if (_unread)
                    Positioned(
                      right: 2,
                      top: 1,
                      child: Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                            color: Color(0xFFE5484D), shape: BoxShape.circle),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _categories.map((c) {
          final selected = c.$1 == _category;
          return GestureDetector(
            onTap: () => setState(() => _category = c.$1),
            behavior: HitTestBehavior.opaque,
            child: SizedBox(
              width: 70,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? Colors.white : AppColors.light,
                      border: Border.all(
                        color: selected ? AppColors.dark : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Icon(c.$3,
                        size: 22,
                        color: selected ? AppColors.dark : AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    c.$2,
                    style: TextStyle(
                      fontSize: 10,
                      color: selected ? AppColors.ink : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _bannerCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 168,
          child: Stack(
            children: [
              PageView.builder(
                controller: _bannerController,
                itemCount: _banners.length,
                onPageChanged: (i) => setState(() => _bannerIndex = i),
                itemBuilder: (_, i) {
                  final b = _banners[i];
                  return GestureDetector(
                    onTap: () =>
                        _openList('Collection', Catalog.byCategory('women')),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ColoredBox(color: b.$3),
                        AppImage(b.$2, alignment: Alignment.topCenter),
                        Positioned(
                          right: 20,
                          top: 0,
                          bottom: 0,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              b.$1,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                height: 1.3,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              if (_banners.length > 1)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_banners.length, (i) {
                      final active = i == _bannerIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: active ? 8 : 5,
                        height: active ? 8 : 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: active ? Colors.white : Colors.white70,
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}