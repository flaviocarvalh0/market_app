import 'package:flutter/material.dart';
import 'package:market_app/providers/product_provider.dart';
import 'package:market_app/utils/app_routes.dart';
import 'package:provider/provider.dart';

import '../../components/product/product_item.dart';
import '../../components/widgets/drawer_widget.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<ProductProvider>(context, listen: false).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.productForm);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: product.productCount,
            itemBuilder: (countext, index) => Column(
              children: [
                ProductItem(
                  product: product.items[index],
                ),
                const Divider()
              ],
            ),
          ),
        ),
      ),
      drawer: const DrawerWidget(),
    );
  }
}
