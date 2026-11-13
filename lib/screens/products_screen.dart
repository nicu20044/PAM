import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/favorites_cubit.dart';
import '../cubits/products_cubit.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/app_image.dart';
import '../widgets/product_tile.dart';
import '../widgets/status_views.dart';

class ProductsScreen extends StatelessWidget {
  final String title;
  final List<Product> products;
  const ProductsScreen({super.key, required this.title, required this.products});

  @override
  Widget build(BuildContext context) {
    // fiecare ecran are propriul ProductsCubit (cautare/filtre independente)
    return BlocProvider(
      create: (_) => ProductsCubit(products),
      child: _ProductsView(title: title),
    );
  }
}

class _ProductsView extends StatefulWidget {
  final String title;
  const _ProductsView({required this.title});

  @override
  State<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<_ProductsView> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) {
          final list = state.visible;
          final favs = context.watch<FavoritesCubit>().state;

          return Column(
            children: [
              // ---------- CAUTARE ----------
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                child: TextField(
                  controller: _controller,
                  onChanged: (v) {
                    setState(() {});
                    cubit.search(v);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _controller.text.isEmpty
                        ? null
                        : IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () {
                        _controller.clear();
                        setState(() {});
                        cubit.search('');
                      },
                    ),
                    filled: true,
                    fillColor: AppColors.light,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // ---------- FILTRARE + SORTARE ----------
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: PriceFilter.values.map((f) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(f.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: state.price == f
                                          ? Colors.white
                                          : AppColors.ink,
                                    )),
                                selected: state.price == f,
                                selectedColor: AppColors.dark,
                                backgroundColor: AppColors.light,
                                showCheckmark: false,
                                side: BorderSide.none,
                                onSelected: (_) => cubit.setPrice(f),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    PopupMenuButton<SortOption>(
                      icon: const Icon(Icons.sort),
                      tooltip: 'Sort',
                      initialValue: state.sort,
                      onSelected: cubit.setSort,
                      itemBuilder: (_) => SortOption.values
                          .map((s) =>
                          PopupMenuItem(value: s, child: Text(s.label)))
                          .toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // ---------- REZULTATE: Empty sau Success ----------
              Expanded(
                child: list.isEmpty
                    ? EmptyView(
                  icon: Icons.search_off,
                  title: 'No products found',
                  subtitle: 'Try a different search or filter',
                  actionLabel: state.hasFilters ? 'Clear filters' : null,
                  onAction: () {
                    _controller.clear();
                    setState(() {});
                    cubit.reset();
                  },
                )
                    : GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.66,
                  ),
                  itemCount: list.length,
                  itemBuilder: (_, i) {
                    final p = list[i];
                    final isFav = favs.contains(p.id);
                    return GestureDetector(
                      onTap: () => openProduct(context, p),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: AppImage(p.thumb),
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: GestureDetector(
                                    onTap: () => context
                                        .read<FavoritesCubit>()
                                        .toggle(p.id),
                                    child: CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        isFav
                                            ? Icons.favorite
                                            : Icons.favorite_border,
                                        size: 16,
                                        color: isFav
                                            ? const Color(0xFFE5484D)
                                            : AppColors.ink,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(p.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 3),
                          Text(money(p.price),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}