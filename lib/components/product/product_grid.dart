import 'package:flutter/material.dart';
import 'package:market_app/components/product/product_grid_item.dart';
import 'package:market_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorite;
  const ProductGrid(
    this.showFavorite, {
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductProvider>(context);
    final List<Product> loadedProducts =
        showFavorite ? provider.favoritieItems : provider.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        key: ValueKey(loadedProducts[i].id),
        child: const ProductGridItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
