import 'package:flutter/material.dart';
import 'package:market_app/excepctions/http_exception.dart';
import 'package:market_app/models/product.dart';
import 'package:market_app/providers/product_provider.dart';
import 'package:market_app/utils/app_routes.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(
        product.name,
        style: const TextStyle(color: Colors.black),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(AppRoutes.productForm, arguments: product);
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.amber,
              ),
            ),
            IconButton(
              onPressed: () {
                showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text(
                      'Excluir produto',
                      style: TextStyle(color: Colors.black),
                    ),
                    content: Text(
                      'Você está excluíndo ${product.name}, deseja prosseguir?',
                      style: const TextStyle(color: Colors.black),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text(
                              'Não',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text(
                              'Sim',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ).then((value) async {
                  if (value ?? false) {
                    try {
                      await Provider.of<ProductProvider>(
                        context,
                        listen: false,
                      ).removeProduct(product);
                    } on HttpException catch (error) {
                      msg.showSnackBar(
                        SnackBar(
                          content: Text(
                            error.toString(),
                          ),
                        ),
                      );
                    }
                  }
                });
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
