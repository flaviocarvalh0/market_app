import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

    print(jsonDecode(response.body));
  }

  Future<void> singUp(String email, String password) async {
    _authenticate(email, password, 'signUp');
  }

  Future<void> singIn(String email, String password) async {
    _authenticate(email, password, 'signInWithPassword');
  }
}
