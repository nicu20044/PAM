import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/cart_cubit.dart';
import '../cubits/catalog_cubit.dart';
import '../cubits/favorites_cubit.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/product_tile.dart';
import '../widgets/stars.dart';
import 'cart_screen.dart';

class ProductScreen extends StatefulWidget {
  final Product product;
  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  static const _heroHeight = 330.0;

  int _image = 0;
  late int _color;
  late String _size;
  late List<Review> _reviews;

  Product get p => widget.product;

  @override
  void initState() {
    super.initState();
    _color = p.selectedColor.clamp(0, p.colors.length - 1);
    _size = (p.sizes.contains(p.selectedSize) && p.isSizeAvailable(p.selectedSize))
        ? p.selectedSize
        : p.sizes.firstWhere(p.isSizeAvailable, orElse: () => p.sizes.first);
    _reviews = [...p.reviews];
  }

  void _addToCart() {
    context.read<CartCubit>().add(p, _color, _size);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${p.name} added to cart'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          action: SnackBarAction(
            label: 'View cart',
            textColor: Colors.white,
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CartScreen())),
          ),
        ),
      );
  }

  Future<void> _writeReview() async {
    int stars = 5;
    final controller = TextEditingController();
    final result = await showDialog<Review>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: const Text('Write a review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                      (i) => GestureDetector(
                    onTap: () => setLocal(() => stars = i + 1),
                    child: Icon(
                      i < stars
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: AppColors.green,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Share your experience',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel')),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.dark),
              onPressed: () {
                if (controller.text.trim().isEmpty) return;
                Navigator.pop(
                  ctx,
                  Review(
                    id: 'local-${DateTime.now().millisecondsSinceEpoch}',
                    author: 'You',
                    time: 'now',
                    text: controller.text.trim(),
                    rating: stars.toDouble(),
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    if (result != null) setState(() => _reviews.insert(0, result));
  }

  @override
  Widget build(BuildContext context) {
    final isFav = context.watch<FavoritesCubit>().state.contains(p.id);
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: _heroHeight,
                  child: _hero(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: _heroHeight - 26),
                  child: _sheet(bottomPad),
                ),
              ],
            ),
          ),
          Positioned(
            top: topPad + 10,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _roundButton(Icons.chevron_left, () => Navigator.pop(context)),
                _roundButton(
                  isFav ? Icons.favorite : Icons.favorite_border,
                      () => context.read<FavoritesCubit>().toggle(p.id),
                  color: isFav ? const Color(0xFFE5484D) : AppColors.ink,
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: _addToCart,
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 18, 0, 8 + bottomPad),
                decoration: const BoxDecoration(
                  color: AppColors.dark,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_bag, color: Colors.white, size: 20),
                        SizedBox(width: 10),
                        Text('Add To Cart',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      width: 110,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _roundButton(IconData icon, VoidCallback onTap,
      {Color color = AppColors.ink}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Color(0x14000000), blurRadius: 8, offset: Offset(0, 2))
          ],
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Widget _hero() {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.cream),
        Align(
          alignment: const Alignment(0, 0.15),
          child: Container(
            width: 215,
            height: 215,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFFF5E6DB)),
          ),
        ),
        PageView.builder(
          itemCount: p.images.length,
          onPageChanged: (i) => setState(() => _image = i),
          itemBuilder: (_, i) =>
              AppImage(p.images[i], alignment: Alignment.topCenter),
        ),
        if (p.images.length > 1)
          Positioned(
            left: 0,
            right: 0,
            bottom: 36,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(p.images.length, (i) {
                final active = i == _image;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 8 : 5,
                  height: active ? 8 : 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? AppColors.dark : AppColors.grey,
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _sheet(double bottomPad) {
    final similar = context.read<CatalogCubit>().state.data?.similarFor(p) ??
        const <Product>[];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(22, 24, 22, 110 + bottomPad),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Color(0x14000000), blurRadius: 20, offset: Offset(0, -4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(p.name,
                    style: const TextStyle(
                        fontSize: 17, fontWeight: FontWeight.w800)),
              ),
              Text(money(p.price),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Stars(rating: p.rating, size: 19),
              const SizedBox(width: 6),
              Text('(${p.ratingCount})',
                  style: const TextStyle(fontSize: 10, color: AppColors.grey)),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(height: 1, color: AppColors.line),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Color',
                        style: TextStyle(fontSize: 12, color: AppColors.body)),
                    const SizedBox(height: 12),
                    Row(children: List.generate(p.colors.length, _colorDot)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Size',
                      style: TextStyle(fontSize: 12, color: AppColors.body)),
                  const SizedBox(height: 12),
                  Row(children: p.sizes.map(_sizeDot).toList()),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          ExpandableSection(
            title: 'Description',
            initiallyExpanded: true,
            child: _Description(text: p.description),
          ),
          ExpandableSection(
            title: 'Reviews',
            initiallyExpanded: true,
            child: _reviewsBlock(),
          ),
          if (similar.isNotEmpty)
            ExpandableSection(
              title: 'Similar Product',
              initiallyExpanded: true,
              child: SizedBox(
                height: 210,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  itemCount: similar.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (_, i) => ProductTile(product: similar[i]),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _colorDot(int i) {
    final sel = i == _color;
    return GestureDetector(
      onTap: () => setState(() => _color = i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 14),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: p.colors[i].color,
          border: sel ? Border.all(color: Colors.white, width: 3) : null,
          boxShadow: sel
              ? const [
            BoxShadow(
                color: Color(0x40000000),
                blurRadius: 8,
                offset: Offset(0, 3))
          ]
              : null,
        ),
      ),
    );
  }

  Widget _sizeDot(String s) {
    final sel = s == _size;
    final available = p.isSizeAvailable(s);
    final long = s.length > 2;
    return GestureDetector(
      onTap: available ? () => setState(() => _size = s) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(left: 10),
        height: 32,
        constraints: const BoxConstraints(minWidth: 32),
        padding: EdgeInsets.symmetric(horizontal: long ? 12 : 0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: sel ? AppColors.dark : AppColors.light,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          s,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: sel
                ? Colors.white
                : (available ? AppColors.grey : const Color(0xFFD5D5DA)),
            decoration: available ? null : TextDecoration.lineThrough,
          ),
        ),
      ),
    );
  }

  Widget _reviewsBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(p.rating.toStringAsFixed(1),
                style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 26),
              child: Text('OUT OF 5',
                  style: TextStyle(fontSize: 10, color: AppColors.grey)),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Stars(rating: p.rating, size: 17),
                  const SizedBox(height: 4),
                  Text('${p.ratingCount} ratings',
                      style:
                      const TextStyle(fontSize: 10, color: AppColors.grey)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (int i = 0; i < p.ratingBreakdown.length && i < 5; i++)
          _ratingBar(5 - i, p.ratingBreakdown[i]),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('${p.reviewCount} Reviews',
                style: const TextStyle(fontSize: 10, color: AppColors.grey)),
            GestureDetector(
              onTap: _writeReview,
              child: const Row(
                children: [
                  Text('WRITE A REVIEW',
                      style: TextStyle(fontSize: 10, color: AppColors.grey)),
                  SizedBox(width: 4),
                  Icon(Icons.edit_outlined, size: 14, color: AppColors.grey),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (_reviews.isEmpty)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text('No reviews yet. Be the first to write one!',
                style: TextStyle(fontSize: 12, color: AppColors.grey)),
          ),
        for (final r in _reviews) _reviewTile(r),
      ],
    );
  }

  Widget _ratingBar(int star, int percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(
            width: 10,
            child: Text('$star',
                style: const TextStyle(fontSize: 10, color: AppColors.grey)),
          ),
          const Icon(Icons.star_rounded, size: 14, color: AppColors.green),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: percent / 100,
                minHeight: 5,
                backgroundColor: AppColors.line,
                valueColor: const AlwaysStoppedAnimation(AppColors.green),
              ),
            ),
          ),
          SizedBox(
            width: 38,
            child: Text('$percent%',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 10, color: AppColors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _reviewTile(Review r) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 34,
                  height: 34,
                  child: r.avatar.isEmpty
                      ? const ColoredBox(
                      color: AppColors.light,
                      child: Icon(Icons.person,
                          size: 20, color: AppColors.grey))
                      : AppImage(r.avatar),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.author,
                        style: const TextStyle(
                            fontSize: 12.5, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Stars(rating: r.rating, size: 11),
                  ],
                ),
              ),
              Text(r.time,
                  style: const TextStyle(fontSize: 10, color: AppColors.grey)),
            ],
          ),
          const SizedBox(height: 10),
          Text(r.text,
              style: const TextStyle(
                  fontSize: 11.5, height: 1.5, color: AppColors.body)),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------ helpers

class ExpandableSection extends StatefulWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;
  const ExpandableSection({
    super.key,
    required this.title,
    required this.child,
    this.initiallyExpanded = false,
  });

  @override
  State<ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<ExpandableSection> {
  late bool _open = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 1, color: AppColors.line),
        InkWell(
          onTap: () => setState(() => _open = !_open),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Text(widget.title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700)),
                const Spacer(),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(Icons.keyboard_arrow_down_rounded),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 220),
          alignment: Alignment.topCenter,
          child: _open
              ? Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: widget.child,
          )
              : const SizedBox(width: double.infinity, height: 0),
        ),
      ],
    );
  }
}

class _Description extends StatefulWidget {
  final String text;
  const _Description({required this.text});

  @override
  State<_Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<_Description> {
  bool _expanded = false;
  late final TapGestureRecognizer _tap = TapGestureRecognizer()
    ..onTap = () => setState(() => _expanded = !_expanded);

  @override
  void dispose() {
    _tap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 12, height: 1.6, color: AppColors.body);
    final long = widget.text.length > 150;
    final shown = (!long || _expanded)
        ? widget.text
        : '${widget.text.substring(0, 150).trimRight()}... ';

    return Text.rich(
      TextSpan(
        style: style,
        children: [
          TextSpan(text: shown),
          if (long)
            TextSpan(
              text: _expanded ? ' Show less' : 'Read more',
              recognizer: _tap,
              style: const TextStyle(
                color: AppColors.green,
                decoration: TextDecoration.underline,
              ),
            ),
        ],
      ),
    );
  }
}