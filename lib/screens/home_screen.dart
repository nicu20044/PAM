import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/catalog_cubit.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_drawer.dart';
import '../widgets/app_image.dart';
import '../widgets/collection_cards.dart';
import '../widgets/product_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/status_views.dart';
import 'products_screen.dart';

IconData _iconFor(String id) => switch (id) {
  'women' => Icons.female,
  'men' => Icons.male,
  'accessories' => Icons.visibility_outlined,
  'beauty' => Icons.spa_outlined,
  _ => Icons.category_outlined,
};

/// "The Office Life" -> "The Office\nLife"
String _breakLast(String t) {
  final i = t.lastIndexOf(' ');
  return i < 0 ? t : '${t.substring(0, i)}\n${t.substring(i + 1)}';
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _unread = true;
  int _bannerIndex = 0;
  final _bannerController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      final slides =
          context.read<CatalogCubit>().state.data?.hero.slides ?? 1;
      if (slides < 2 || !_bannerController.hasClients) return;
      final next = (_bannerIndex + 1) % slides;
      _bannerController.animateToPage(next,
          duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
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
        builder: (_) => ProductsScreen(title: title, products: products),
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
    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: BlocBuilder<CatalogCubit, CatalogState>(
                builder: (context, state) => switch (state.status) {
                  CatalogStatus.loading => const LoadingView(),
                  CatalogStatus.error => ErrorView(
                    message: state.error ?? 'Unknown error',
                    onRetry: () => context.read<CatalogCubit>().load(),
                  ),
                  CatalogStatus.success => _content(context, state),
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context, CatalogState state) {
    final data = state.data!;
    final featured = state.featuredForCategory;

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const SizedBox(height: 8),
        _categoryRow(context, data.categories, state.category),
        const SizedBox(height: 22),
        _bannerCarousel(data.hero),
        const SizedBox(height: 26),
        SectionHeader(
          title: 'Feature Products',
          onShowAll: () => _openList('Feature Products', featured),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 205,
          child: featured.isEmpty
              ? const EmptyView(
            icon: Icons.checkroom_outlined,
            title: 'No products in this category yet',
          )
              : ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: featured.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (_, i) => ProductTile(product: featured[i]),
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () => _openList('New Collection', data.allProducts),
          child: AspectRatio(
            aspectRatio: 375 / 158,
            child: AppImage(data.newCollection.image),
          ),
        ),
        const SizedBox(height: 28),
        SectionHeader(
          title: 'Recommended',
          onShowAll: () => _openList('Recommended', data.recommended),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 10),
            itemCount: data.recommended.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (_, i) =>
                RecommendedCard(product: data.recommended[i]),
          ),
        ),
        const SizedBox(height: 22),
        SectionHeader(
          title: 'Top Collection',
          onShowAll: () => _openList('Top Collection', data.allProducts),
        ),
        const SizedBox(height: 14),
        for (final (i, c) in data.topCollections.indexed) ...[
          CollectionCard(
            height: i == 0 ? 118 : 175,
            boldTitle: i != 0,
            tag: c.label,
            title: c.title.replaceAll(' & ', '\n& '),
            image: c.image,
            circleColor: const Color(0xFFEDEBE3),
            onTap: () => _openList(c.label, data.allProducts),
          ),
          const SizedBox(height: 14),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              for (final (i, c) in data.categoryPromos.indexed) ...[
                if (i > 0) const SizedBox(width: 10),
                CollectionTile(
                  label: c.label,
                  title: _breakLast(c.title),
                  image: c.image,
                  imageLeft: i.isEven,
                  onTap: () => _openList(c.label, data.allProducts),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _topBar() {
    final name =
        context.watch<CatalogCubit>().state.data?.storeName ?? 'GemStore';
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
          Text(name,
              style:
              const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
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

  Widget _categoryRow(
      BuildContext context, List<CategoryItem> cats, String selectedId) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: cats.map((c) {
          final selected = c.id == selectedId;
          return GestureDetector(
            onTap: () => context.read<CatalogCubit>().selectCategory(c.id),
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
                    child: Icon(_iconFor(c.id),
                        size: 22,
                        color: selected ? AppColors.dark : AppColors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    c.name,
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

  Widget _bannerCarousel(HeroBanner hero) {
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
                itemCount: hero.slides,
                onPageChanged: (i) => setState(() => _bannerIndex = i),
                itemBuilder: (_, i) => Stack(
                  fit: StackFit.expand,
                  children: [
                    const ColoredBox(color: Color(0xFFC98B7B)),
                    AppImage(hero.image, alignment: Alignment.topCenter),
                    Positioned(
                      right: 20,
                      top: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          hero.title.replaceAll(' ', '\n'),
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
              ),
              if (hero.slides > 1)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(hero.slides, (i) {
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