import 'package:flutter/material.dart';
import 'package:market_app/pages/cart_page.dart';
import 'package:market_app/pages/product_detail_page.dart';
import 'package:market_app/providers/cart_provider.dart';
import 'package:market_app/providers/product_list_provider.dart';
import '../pages/products_overview_page.dart';
import '../utils/app_routes.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductListProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          fontFamily: 'Lato',
          textTheme: const TextTheme(
            titleMedium: TextStyle(fontFamily: 'Lato', color: Colors.white),
          ),
        ),
        home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.productDetail: (context) => const ProductDetailPage(),
          AppRoutes.cartPage: (context) => const CartPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
