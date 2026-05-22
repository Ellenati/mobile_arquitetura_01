import '../models/product_model.dart';
import '../services/product_cache_service.dart';
import '../services/product_service.dart';

class ProductRepository {
  final ProductService remoteService;
  final ProductCacheService cacheService;

  ProductRepository(this.remoteService, this.cacheService);

  Future<List<ProductModel>> getProducts() async {
    try {
      final models = await remoteService.getProducts();
      cacheService.save(models);
      return models;
    } catch (e) {
      final cachedModels = cacheService.get();
      if (cachedModels != null && cachedModels.isNotEmpty) {
        return cachedModels;
      }
      throw Exception("Erro ao buscar produtos. O cache está vazio ou API offline.");
    }
  }

  Future<ProductModel> getProductDetails(int id) async {
    return await remoteService.getProductDetails(id);
  }
}
