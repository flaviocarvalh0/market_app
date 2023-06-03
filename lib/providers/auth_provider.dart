import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:market_app/excepctions/auth_exception.dart';

class AuthProvider with ChangeNotifier {
  // ignore: constant_identifier_names
  static const AUTH_BASE_URL =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyBdYQWKE65AtV-uRwrXRyqGfLq7yNAACq4';

  Future<void> _authenticate(
      String email, String password, String urlInOrUp) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlInOrUp?key=AIzaSyBdYQWKE65AtV-uRwrXRyqGfLq7yNAACq4';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );

    final body = jsonDecode(response.body);

    if (body['error'] != null) {
      throw AuthException(key: body['error']['message']);
    }

    print(body);
  }

  Future<void> singUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> singIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
