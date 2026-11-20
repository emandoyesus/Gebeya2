import 'package:flutter/material.dart';

class ProductCategory {
  final String id;
  final String name;
  final String nameAmharic;
  final IconData icon;
  final String imageUrl;
  final int itemCount;

  const ProductCategory({
    required this.id,
    required this.name,
    this.nameAmharic = '',
    required this.icon,
    required this.imageUrl,
    this.itemCount = 0,
  });

  ProductCategory copyWith({
    String? id,
    String? name,
    String? nameAmharic,
    IconData? icon,
    String? imageUrl,
    int? itemCount,
  }) {
    return ProductCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAmharic: nameAmharic ?? this.nameAmharic,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      itemCount: itemCount ?? this.itemCount,
    );
  }
}
