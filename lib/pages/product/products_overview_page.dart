import 'package:flutter/material.dart';
import 'package:market_app/components/widgets/drawer_widget.dart';
import 'package:market_app/components/widgets/sticker_cart.dart';
import 'package:market_app/providers/cart_provider.dart';
import 'package:market_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

import '../../components/product/product_grid.dart';
import '../../utils/app_routes.dart';

enum FilterOptions {
  favorite,
  all,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(
      context,
      listen: false,
    ).loadProducts().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text(
                  'Somente Favoritos',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text(
                  'Todos',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorite) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<CartProvider>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cartPage);
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            builder: (ctx, cart, child) => StickerCart(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductGrid(_showFavoriteOnly),
      drawer: const DrawerWidget(),
    );
  }
}
