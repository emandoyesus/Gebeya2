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
}
