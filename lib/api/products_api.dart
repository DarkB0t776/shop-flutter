import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:shop/api/api.dart';
import 'package:shop/providers/product.dart';

class ProductsApi extends Api {
  final apiInstance = new Api();
  static Future<http.Response> addProduct(Product product) async {
    try {
      final body = json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isFavorite': product.isFavorite,
      });
      var res =
          await Api.sendRequest('post', endpoint: '/products.json', body: body);
      return res;
    } catch (e) {
      throw e;
    }
  }

  static Future<http.Response> fetchProducts() async {
    try {
      var res = await Api.sendRequest('get', endpoint: '/products.json');
      return res;
    } catch (e) {
      throw e;
    }
  }
}
