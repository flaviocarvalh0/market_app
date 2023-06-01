import 'package:flutter/material.dart';

import '../../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Product product =
        ModalRoute.of(context)!.settings.arguments as Product;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.name,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(10),
              elevation: 7,
              child: Image.network(
                product.imageUrl,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'R\$ ${product.price}',
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 5,
              ),
              width: double.infinity,
              child: Text(
                product.description,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
