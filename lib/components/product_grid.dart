import 'package:flutter/material.dart';
import 'package:market_app/components/product_item.dart';
import 'package:market_app/providers/product_list_provider.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    super.key,
    
  });
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductListProvider>(context);
    final List<Product> loadedProducts = provider.item;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      itemBuilder: (ctx, i) => ProductItem(product: loadedProducts[i]),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
