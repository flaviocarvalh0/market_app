import 'package:flutter/material.dart';
import 'package:market_app/components/sticker_cart.dart';
import 'package:market_app/providers/cart_provider.dart';
import 'package:market_app/utils/app_routes.dart';
import 'package:provider/provider.dart';
import '../components/product_grid.dart';

enum FavoritOptions { favorite, all }

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavorities = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha Loja'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FavoritOptions.favorite,
                child: Text('Somente Favoritos'),
              ),
              const PopupMenuItem(
                value: FavoritOptions.all,
                child: Text('Todos'),
              ),
            ],
            onSelected: (FavoritOptions selectedValue) {
              setState(() {
                if (selectedValue == FavoritOptions.favorite) {
                  _showFavorities = true;
                } else {
                  _showFavorities = false;
                }
              });
            },
          ),
          Consumer<CartProvider>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cartPage);
              },
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
            builder: (context, cart, child) => StickerCart(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          )
        ],
      ),
      body: ProductGrid(_showFavorities),
    );
  }
}
