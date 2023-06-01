import 'package:flutter/material.dart';
import 'package:market_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

enum AuthMode { singUp, login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  AuthMode _authMode = AuthMode.login;
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = true;
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.login;
  bool _isSingUp() => _authMode == AuthMode.singUp;
  void _onPressed() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.singUp;
      } else {
        _authMode = AuthMode.login;
      }
    });
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = false);
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();
    AuthProvider auth = Provider.of(context, listen: false);

    if (_isLogin()) {
      await auth.singIn(
        _authData['email']!,
        _authData['password']!,
      );
    } else {
      await auth.singUp(
        _authData['email']!,
        _authData['password']!,
      );
    }

    setState(() => _isLoading = true);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 310 : 360,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.black),
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um email válido';
                  }

                  return null;
                },
                decoration: const InputDecoration(
                    labelText: 'E-mail',
                    labelStyle: TextStyle(color: Colors.black)),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                onSaved: (password) => _authData['password'] = password ?? '',
                controller: _passwordController,
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma válida';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Senha'),
                obscureText: true,
              ),
              if (_isSingUp())
                TextFormField(
                  style: const TextStyle(color: Colors.black),
                  validator: _isLogin()
                      ? null
                      : (_password) {
                          final password = _password ?? '';
                          if (password != _passwordController.text) {
                            return 'As senhas não conincidem.';
                          }
                          return null;
                        },
                  decoration:
                      const InputDecoration(labelText: 'Confirmar senha'),
                  obscureText: true,
                ),
              const SizedBox(
                height: 20,
              ),
              if (_isLoading = false)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 8,
                      )),
                  onPressed: _submitForm,
                  child: Text(_isLogin() ? 'ENTRAR' : 'REGISTRAR'),
                ),
              const Spacer(),
              TextButton(
                onPressed: _onPressed,
                child:
                    Text(_isLogin() ? 'CADASTRAR-SE' : 'JÁ POSSUI UM CONTA?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
