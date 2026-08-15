import 'package:flutter/material.dart';
import 'package:lifeos/database/app_database.dart';
import 'package:lifeos/services/category_service.dart';

class CategoryProvider with ChangeNotifier {
  final CategoryService _categoryService;
  final int userId;

  CategoryProvider({
    required CategoryService categoryService,
    required this.userId,
  }) : _categoryService = categoryService;

  Stream<List<Category>> categoriesStream(String type) {
    return _categoryService.watchCategoriesByType(
      userId: userId,
      type: type,
    );
  }

  Future<int> getOrCreateCategory({
    required String type,
    required String name,
  }) {
    return _categoryService.getOrCreateCategory(
      userId: userId,
      type: type,
      name: name,
    );
  }
}
