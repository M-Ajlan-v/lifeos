import 'package:drift/drift.dart';
import 'package:lifeos/database/app_database.dart';

class CategoryService {
  final AppDatabase db;

  CategoryService(this.db);

  // -------------------------------------------------------
  // Watch active categories of a specific type (INCOME or EXPENSE)
  // -------------------------------------------------------
  Stream<List<Category>> watchCategoriesByType({
    required int userId,
    required String type, // 'INCOME' or 'EXPENSE'
  }) {
    return (db.select(db.categories)
          ..where((c) =>
              c.userId.equals(userId) &
              c.type.equals(type) &
              c.isActive.equals(1))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  // -------------------------------------------------------
  // Find category by name + type (case-insensitive)
  // -------------------------------------------------------
  Future<Category?> findCategoryByName({
    required int userId,
    required String type,
    required String name,
  }) {
    return (db.select(db.categories)
          ..where((c) =>
              c.userId.equals(userId) &
              c.type.equals(type) &
              c.name.lower().equals(name.trim().toLowerCase()) &
              c.isActive.equals(1)))
        .getSingleOrNull();
  }

  Future<Category?> getCategoryById({
    required int userId,
    required int categoryId,
  }) {
    return (db.select(db.categories)
          ..where((c) =>
              c.id.equals(categoryId) & c.userId.equals(userId)))
        .getSingleOrNull();
  }

  // -------------------------------------------------------
  // Create category if it does not exist, otherwise return existing
  // -------------------------------------------------------
  Future<int> getOrCreateCategory({
    required int userId,
    required String type,
    required String name,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw Exception('Category name cannot be empty');
    }

    final existing = await findCategoryByName(
      userId: userId,
      type: type,
      name: trimmed,
    );

    if (existing != null) {
      return existing.id;
    }

    // Create new
    final now = DateTime.now().toUtc();
    return db.into(db.categories).insert(
          CategoriesCompanion.insert(
            userId: userId,
            name: trimmed,
            type: type,
            isActive: const Value(1),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }
}