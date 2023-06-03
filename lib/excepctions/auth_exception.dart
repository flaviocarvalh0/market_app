// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthException implements Exception {
  Map<String, String> erros = {
    'EMAIL_EXISTS':
        'Este e-mail já esta associado a uma conta, informe outro e-mail e tente novamente.',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida.',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente, tente novamente mais tarde.',
    'EMAIL_NOT_FOUND':
        'Não existe conta cadastrada para este e-mail, insira um e-mail válido e tente novamente.',
    'INVALID_PASSWORD': 'A senha informada está inválida.',
    'USER_DISABLED':
        'Esta conta econtra-se desabilitada, favor contatar um administrador.'
  };

  final String key;
  AuthException({
    required this.key,
  });

  @override
  String toString() {
    return erros[key] ??
        'Ocorreu um erro no processo de autenticação, favor contatar o suporte.';
  }
}
