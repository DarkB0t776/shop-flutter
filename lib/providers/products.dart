import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

import 'package:shop/providers/product.dart';
import 'package:shop/api/products_api.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<http.Response> fetchAndSetProducts() async {
    try {
      final res = await ProductsApi.fetchProducts();
      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((key, value) {
        loadedProducts.add(Product(
          id: key,
          title: value['title'],
          description: value['description'],
          price: value['price'],
          imageUrl: value['imageUrl'],
          isFavorite: value['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
      return res;
    } catch (e) {
      print('error $e');
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      final res = await ProductsApi.addProduct(product);
      final newProduct = Product(
        id: json.decode(res.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
      return Future.value(res);
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIdx = _items.indexWhere((prod) => prod.id == id);

    if (prodIdx >= 0) {
      try {
        await ProductsApi.updateProduct(newProduct);
        _items[prodIdx] = newProduct;
        notifyListeners();
      } catch (e) {
        print('error: $e');
        throw e;
      }
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final existingProdIdx = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProdIdx];

    _items.removeAt(existingProdIdx);
    notifyListeners();

    final res = await ProductsApi.deleteProduct(id);
    if (res.statusCode >= 400) {
      _items.insert(existingProdIdx, existingProduct);
      notifyListeners();
      throw HttpException('Something went wrong!');
    }
    existingProduct = null;
  }
}
