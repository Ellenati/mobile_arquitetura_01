class ProductModel {
  final int id;
  final String title;
  final double price;
  final String thumbnail;
  final String description;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.thumbnail,
    required this.description,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"],
      title: json["title"],
      price: json["price"].toDouble(),
      thumbnail: json["thumbnail"] ?? (json["images"] != null && json["images"].isNotEmpty ? json["images"][0] : ''),
      description: json["description"] ?? '',
    );
  }
}
