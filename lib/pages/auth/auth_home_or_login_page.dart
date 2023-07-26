import 'package:flutter/material.dart';
import 'package:market_app/pages/auth/auth_page.dart';
import 'package:market_app/pages/product/products_overview_page.dart';
import 'package:market_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthHomeOrLoginPage extends StatelessWidget {
  const AuthHomeOrLoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of(context);

    return FutureBuilder(
      future: auth.tryAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.error != null) {
          return const Center(
            child: Text('Ocorreu um erro!'),
          );
        } else {
          return auth.isAuth ? const ProductsOverviewPage() : const AuthPage();
        }
      },
    );
  }
}
