import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  Future<List<ProductModel>> getProducts() async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/products"),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List productsJson = data["products"];
      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception("Falha ao buscar produtos na API");
    }
  }

  Future<ProductModel> getProductDetails(int id) async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/products/$id"),
    );

    if (response.statusCode == 200) {
      return ProductModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Falha ao buscar detalhes do produto");
    }
  }
}
