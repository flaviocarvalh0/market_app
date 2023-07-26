import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:market_app/data/store.dart';
import 'package:market_app/excepctions/auth_exception.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _email;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _logoutTimer;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;

    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }

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
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            body['expiresIn'],
          ),
        ),
      );

      Store.saveMap('userData', {
        'token': _token,
        'email': _email,
        'userId': _userId,
        'expiryDate': _expiryDate!.toIso8601String(),
      });
      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> singUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> singIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');

    if (userData.isEmpty) return;

    final expireDate = DateTime.parse(userData['expiryDate']);

    if (expireDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expireDate;

    _autoLogout();
    notifyListeners();
  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;

    _clearLogoutTimer();
    Store.remove('userData').then((_) => notifyListeners());
  }

  void _clearLogoutTimer() {
    _logoutTimer?.cancel();
    _logoutTimer = null;
  }

  void _autoLogout() {
    _clearLogoutTimer();
    final timeToLogOut = _expiryDate?.difference(DateTime.now()).inSeconds;
    _logoutTimer = Timer(
      Duration(seconds: timeToLogOut ?? 0),
      logout,
    );
  }
}
