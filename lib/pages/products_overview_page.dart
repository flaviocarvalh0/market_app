import 'package:flutter/material.dart';
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
        title: const Center(
          child: Text('Minha Loja'),
        ),
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
        ],
      ),
      body: ProductGrid(_showFavorities),
    );
  }
}
