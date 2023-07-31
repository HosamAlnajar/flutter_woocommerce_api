import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String apiUrl = "https://demotest.se/wp-json/wc/v3/products";
  static const String key = "ck_96fea009b8a5b130aa55b527df76748bf3e3dca8";
  static const String secret = "cs_d77ff405912a3977b3121f26f8486a460cab2bcc";

  static Map<String, String> getHeader() {
    final basicAuth = 'Basic ${base64Encode(utf8.encode('$key:$secret'))}';
    return {'Authorization': basicAuth, 'Content-Type': 'application/json'};
  }

  static Future<bool> createProduct(data) async {
    String url = 'https://demotest.se/wp-json/wc/v3/products';
    bool success = false;
    try {
      // Send request to the server (API request)
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: getHeader(),
        body: jsonEncode(data),
      );

      // Handle the response (success or error)
      if (response.statusCode == 201) {
        success = true;
      } else {
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
        print('Response: ${response.body}');
      }
    } catch (e) {
      print(e);
    }
    return success;
  }

  static Future<List?> getAllProducts() async {
    List products = [];

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: getHeader(),
      );

      if (response.statusCode == 200) {
        products = jsonDecode(response.body);
      } else {
        print('Failed to get product. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error getting product: $e');
    }
    return products;
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
        print('Failed to get product. Status code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error getting product: $e');
    }
    return success;
  }
}
