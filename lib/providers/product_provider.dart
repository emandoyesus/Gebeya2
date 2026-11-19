import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/category.dart';
import '../models/product.dart';

enum ProductSortOption {
  featured,
  priceLowToHigh,
  priceHighToLow,
  topRated,
  nameAsc,
}

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<ProductCategory> _categories = [];
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  ProductSortOption _sortOption = ProductSortOption.featured;
  bool _isLoading = false;

  List<Product> get products => _products;
  List<ProductCategory> get categories => _categories;
  String get selectedCategoryId => _selectedCategoryId;
  String get searchQuery => _searchQuery;
  ProductSortOption get sortOption => _sortOption;
  bool get isLoading => _isLoading;

  ProductProvider() {
    _initData();
  }

  void _initData() {
    _isLoading = true;
    _categories = MockData.categories;
    _products = MockData.products;
    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String categoryId) {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSortOption(ProductSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    List<Product> list = _products;

    if (_selectedCategoryId != 'all') {
      list = list.where((p) => p.category == _selectedCategoryId).toList();
    }

    if (_searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.toLowerCase().trim();
      list = list.where((p) {
        final matchesName = p.name.toLowerCase().contains(query);
        final matchesAmharic = p.nameAmharic.toLowerCase().contains(query);
        final matchesDesc = p.description.toLowerCase().contains(query);
        final matchesCategory = p.category.toLowerCase().contains(query);
        return matchesName || matchesAmharic || matchesDesc || matchesCategory;
      }).toList();
    }

    switch (_sortOption) {
      case ProductSortOption.featured:
        list.sort((a, b) => (b.isFeatured ? 1 : 0).compareTo(a.isFeatured ? 1 : 0));
        break;
      case ProductSortOption.priceLowToHigh:
        list.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceHighToLow:
        list.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.topRated:
        list.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSortOption.nameAsc:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return list;
  }

  List<Product> get featuredProducts =>
      _products.where((p) => p.isFeatured).toList();

  List<Product> get discountProducts =>
      _products.where((p) => p.hasDiscount).toList();

  List<Product> getRelatedProducts(Product product) {
    return _products
        .where((p) => p.id != product.id && p.category == product.category)
        .take(4)
        .toList();
  }

  Product? findById(String id) {
    try {
      return _products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
