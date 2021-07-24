import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  static const BASE_URL =
      'flutter-shop-53e34-default-rtdb.europe-west1.firebasedatabase.app';

  static Future<http.StreamedResponse> sendRequest(
    String method,
    String endpoint, {
    String body: '',
  }) async {
    final url = Uri.https(BASE_URL, endpoint);
    final provider = http.Request(method, url);
    if (method == 'post') {
      provider.body = body;
    }

    var res = await provider.send();
    return res;
  }
}
