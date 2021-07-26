import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  static const BASE_URL =
      'flutter-shop-53e34-default-rtdb.europe-west1.firebasedatabase.app';

  static Future<http.Response> sendRequest(
    String method, {
    String endpoint: '',
    String body: '',
  }) async {
    try {
      final url = Uri.https(BASE_URL, endpoint);
      final provider = http.Request(method, url);

      provider.body = body;

      var streamedResponse = await provider.send();
      var res = http.Response.fromStream(streamedResponse);
      return res;
    } catch (e) {
      throw (e);
    }
  }
}
