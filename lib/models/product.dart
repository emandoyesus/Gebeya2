class Product {
  final String id;
  final String name;
  final String nameAmharic;
  final String description;
  final double price; // In ETB (Ethiopian Birr) or USD
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;
  final String category;
  final bool inStock;
  final bool isFeatured;
  final List<String> availableColors;
  final List<String> availableSizes;
  final Map<String, String> specifications;

  const Product({
    required this.id,
    required this.name,
    this.nameAmharic = '',
    required this.description,
    required this.price,
    this.originalPrice,
    this.rating = 4.8,
    this.reviewCount = 0,
    required this.imageUrls,
    required this.category,
    this.inStock = true,
    this.isFeatured = false,
    this.availableColors = const [],
    this.availableSizes = const [],
    this.specifications = const {},
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAmharic': nameAmharic,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrls': imageUrls,
      'category': category,
      'inStock': inStock,
      'isFeatured': isFeatured,
      'availableColors': availableColors,
      'availableSizes': availableSizes,
      'specifications': specifications,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAmharic: json['nameAmharic'] as String? ?? '',
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] != null
          ? (json['originalPrice'] as num).toDouble()
          : null,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      category: json['category'] as String,
      inStock: json['inStock'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      availableColors: List<String>.from(json['availableColors'] ?? []),
      availableSizes: List<String>.from(json['availableSizes'] ?? []),
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
    );
  }
}
