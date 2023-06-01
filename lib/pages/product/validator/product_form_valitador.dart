class ProductFormValitador {
  static String? validateName(String name) {
    if (name.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    if (name.trim().length < 3) {
      return 'Nome precisa ter pelo menos 3 caracteres';
    }
    return null;
  }

  static String? validateDescription(String description) {
    if (description.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    if (description.trim().length < 3) {
      return 'Nome precisa ter pelo menos 3 caracteres';
    }
    return null;
  }

  static String? validateUrlImage(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithFile = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    bool isValid = isValidUrl && endsWithFile;

    if (!isValid && url.isNotEmpty) {
      return 'Informe uma url válida';
    }
    if (url.isEmpty) {
      return 'Informe uma url';
    }
    return null;
  }
}
