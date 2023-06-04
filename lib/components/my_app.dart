import 'package:flutter/material.dart';
import 'package:market_app/pages/auth/auth_home_or_login_page.dart';
import 'package:market_app/pages/auth/auth_page.dart';
import 'package:market_app/pages/cart/cart_page.dart';
import 'package:market_app/pages/order/orders_page.dart';
import 'package:market_app/pages/product/product_form_page.dart';
import 'package:market_app/providers/auth_provider.dart';
import 'package:market_app/providers/cart_provider.dart';
import 'package:market_app/providers/order_provider.dart';
import 'package:market_app/providers/product_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../pages/product/product_detail_page.dart';
import '../pages/product/products_overview_page.dart';
import '../pages/product/products_page.dart';
import '../utils/app_routes.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProductProvider>(
          create: (_) => ProductProvider('', [], ''),
          update: (context, auth, previous) {
            return ProductProvider(
              auth.token ?? '',
              previous?.items ?? [],
              auth.userId ?? '',
            );
          },
        ),
        ChangeNotifierProxyProvider<AuthProvider, OrderProvider>(
          create: (_) => OrderProvider('', []),
          update: (context, auth, previous) {
            return OrderProvider(auth.token ?? '', previous?.items ?? []);
          },
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('pt', 'BR')],
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
        //home: const ProductsOverviewPage(),
        routes: {
          AppRoutes.authHomeOrLogin: (context) => const AuthHomeOrLoginPage(),
          AppRoutes.productDetail: (context) => const ProductDetailPage(),
          AppRoutes.cartPage: (context) => const CartPage(),
          AppRoutes.orders: (context) => const OrdersPage(),
          AppRoutes.products: (context) => const ProductsPage(),
          AppRoutes.productForm: (context) => const ProductFormPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
