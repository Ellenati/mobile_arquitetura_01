import '../models/product_model.dart';

class ProductCacheService {
  List<ProductModel>? _cache;

  void save(List<ProductModel> products) {
    _cache = products;
  }

  List<ProductModel>? get() {
    return _cache;
  }
}
