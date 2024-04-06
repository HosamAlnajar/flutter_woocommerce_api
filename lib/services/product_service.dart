import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String apiUrl = "{your-domain}/wp-json/wc/v3/products";
  static const String key = "{Consumer_key}";
  static const String secret = "{Consumer_secret}";

  static Map<String, String> getHeader() {
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$key:$secret'))}';
    return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
  }

  static Future<List> getAllProducts() async {
    List products = [];

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: getHeader(),
      );

      if (response.statusCode == 200) {
        products = jsonDecode(response.body);
      } else {
        print('Failed to get products. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return products;
  }

  static Future<bool> createProduct(data) async {
    bool success = false;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: getHeader(),
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        success = true;
      } else {
        print('Failed to create product. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return success;
  }

  static Future<bool> updateProduct(productId, data) async {
    String url = '$apiUrl/$productId';
    bool success = false;
    try {
      // Send request to the server (API request)
      final response = await http.put(
        Uri.parse(url),
        headers: getHeader(),
        body: jsonEncode(data),
      );

      // Handle the response (success or error)
      if (response.statusCode == 200) {
        success = true;
      } else {
        print('Failed to update product. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return success;
  }

  static Future<bool> deleteProduct(int productId) async {
    String url = '$apiUrl/$productId';

    bool success = false;
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: getHeader(),
      );

      if (response.statusCode == 200) {
        success = true;
      } else {
        print('Failed to delete product. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return success;
  }
}
