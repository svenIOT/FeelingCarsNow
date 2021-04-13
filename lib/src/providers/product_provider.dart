import 'dart:convert';
import 'dart:io';

import 'package:form_validation/src/user_preferences/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:form_validation/src/models/product_model.dart';
import 'package:mime_type/mime_type.dart';

class ProductProvider {
  final _url =
      'https://flutter-varios-db270-default-rtdb.europe-west1.firebasedatabase.app';
  final _prefs = new UserPreferences();

  Future<bool> createProduct(ProductModel product) async {
    final url = '$_url/products.json?auth=${_prefs.token}';

    final response = await http.post(url, body: productModelToJson(product));

    final decodeData = json.decode(response.body);

    return true;
  }

  Future<bool> editProduct(ProductModel product) async {
    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';

    final response = await http.put(url, body: productModelToJson(product));

    final decodeData = json.decode(response.body);

    return true;
  }

  Future<List<ProductModel>> loadProducts() async {
    final url = '$_url/products.json?auth=${_prefs.token}';

    final response = await http.get(url);

    final List<ProductModel> products = new List();
    final Map<String, dynamic> decodedData = json.decode(response.body);

    if (decodedData == null || decodedData['error'] != null) return [];

    decodedData.forEach((key, product) {
      final tempProduct = ProductModel.fromJson(product);
      tempProduct.id = key;

      products.add(tempProduct);
    });

    return products;
  }

  Future<bool> deleteProduct(String id) async {
    final url = '$_url/products/$id.json?auth=${_prefs.token}';
    final response = await http.delete(url);

    return true;
  }

  Future<String> uploadImage(File image) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dy9jm2gzn/image/upload?upload_preset=jximwwvv');
    final mimeType = mime(image.path).split('/');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', image.path,
        contentType: MediaType(mimeType[0], mimeType[1]));

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Hubo un error ${resp.body}');
      return null;
    }

    final respData = json.decode(resp.body);
    return respData['secure_url'];
  }
}
