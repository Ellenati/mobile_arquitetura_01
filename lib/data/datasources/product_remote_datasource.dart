import 'dart:convert';
import 'dart:io';
import 'package:product_app/data/models/product_model.dart';
import 'package:http/http.dart' as http;

class ProductRemoteDatasource {
  final HttpClient client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(
      Uri.parse("https://fakestoreapi.com/products"),
    );
    final List data = jsonDecode(response.body);
    return data.map((json) => ProductModel.fromJson(json)).toList();
  }
}
