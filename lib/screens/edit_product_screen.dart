import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const ROUTE_NAME = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: '', title: '', price: 0, description: '', imageUrl: '');

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState?.validate();
    if (isValid == null || !isValid) {
      return;
    }
    _form.currentState?.save();
    Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  if (value != null && !value.isEmpty) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: value,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                    );
                  }
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.numberWithOptions(
                  signed: true,
                  decimal: true,
                ),
                focusNode: _priceFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please provide a value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid value';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero';
                  }
                  return null;
                },
                onSaved: (value) {
                  if (value != null && !value.isEmpty) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      price: double.parse(value),
                      imageUrl: _editedProduct.imageUrl,
                      description: _editedProduct.description,
                    );
                  }
                },
                onFieldSubmitted: (_) {
                  _descFocusNode.requestFocus();
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: _descFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  } else {
                    return null;
                  }
                },
                onSaved: (value) {
                  if (value != null && !value.isEmpty) {
                    _editedProduct = Product(
                      id: _editedProduct.id,
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      imageUrl: _editedProduct.imageUrl,
                      description: value,
                    );
                  }
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        if (value != null && !value.isEmpty) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            price: _editedProduct.price,
                            imageUrl: value,
                            description: _editedProduct.description,
                          );
                        }
                      },
                      onFieldSubmitted: (_) {
                        setState(() {});
                        _saveForm();
                      },
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
