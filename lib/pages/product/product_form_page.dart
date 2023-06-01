import 'package:flutter/material.dart';
import 'package:market_app/models/product.dart';
import 'package:market_app/pages/product/validator/product_form_valitador.dart';
import 'package:market_app/providers/product_provider.dart';
import 'package:provider/provider.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  final _urlImageFocus = FocusNode();
  final _urlImageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formData = <String, dynamic>{};

  bool isFuture = false;

  @override
  void initState() {
    super.initState();
    _urlImageFocus.addListener(updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _urlImageFocus.removeListener(updateImage);
    _urlImageFocus.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_formData.isEmpty) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg != null) {
        final product = arg as Product;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['description'] = product.description;
        _formData['price'] = product.price;
        _formData['imageUrl'] = product.imageUrl;

        _urlImageController.text = product.imageUrl;
      }
    }
  }

  void updateImage() {
    setState(() {});
  }

  void _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => isFuture = true);

    try {
      await Provider.of<ProductProvider>(context, listen: false)
          .saveProduct(_formData);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Ocorreu um erro'),
          content: const Text(
            'Ocorreu um erro ao tentar salvar o produto.',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ok'),
            ),
          ],
        ),
      );
    } finally {
      setState(() => isFuture = false);
    }
  }

  bool isImageValid(String uri) {
    bool isValid = false;
    if (ProductFormValitador.validateUrlImage(uri) != null) {
      isValid = true;
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário Produto'),
        actions: [
          IconButton(
            onPressed: () => _submitForm(),
            icon: const Icon(Icons.save_alt),
          ),
        ],
      ),
      body: isFuture
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                          label: Text('Nome'),
                          counterStyle: TextStyle(color: Colors.black)),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      onSaved: (name) => _formData['name'] = name ?? '',
                      validator: (_name) =>
                          ProductFormValitador.validateName(_name ?? ''),
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        label: Text('Preço'),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      focusNode: _priceFocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      onSaved: (_price) {
                        final stringPrice = _price ?? '';
                        final price = double.tryParse(stringPrice) ?? -1;

                        _formData['price'] = price;
                      },
                      validator: (_price) {
                        final stringPrice = _price ?? '';
                        final price = double.tryParse(stringPrice) ?? -1;
                        if (price <= 0) {
                          return 'Informe um preço válido';
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        label: Text('Descrição'),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocus,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_urlImageFocus);
                      },
                      onSaved: (description) =>
                          _formData['description'] = description ?? '',
                      validator: (_description) =>
                          ProductFormValitador.validateDescription(
                              _description ?? ''),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              label: Text('Url da imagem'),
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            focusNode: _urlImageFocus,
                            controller: _urlImageController,
                            onSaved: (imageUrl) =>
                                _formData['imageUrl'] = imageUrl ?? '',
                            onFieldSubmitted: (_) => _submitForm,
                            validator: (_imageUrl) =>
                                ProductFormValitador.validateUrlImage(
                                    _imageUrl ?? ''),
                          ),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(
                            top: 10,
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: isImageValid(_urlImageController.text)
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      _urlImageController.text.isEmpty
                                          ? 'Informe a url'
                                          : 'Informe uma url Válida',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : SizedBox(
                                    child: isImageValid(
                                            _urlImageController.text)
                                        ? const Text('Informe uma url válida.')
                                        : Image.network(
                                            _urlImageController.text,
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
