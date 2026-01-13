import 'package:presupresto/models/category.dart';

import '../services/category_service.dart';

class CategoryRepository {
  final CategoryService _service;

  CategoryRepository({required CategoryService service}) : _service = service;

  Future<List<Category>> fetchAll({String? tokenOverride}) async {
    return _service.getCategories(tokenOverride ?? '');
  }

  Future<List<Category>> fetchAllByFilter(
      {String? tokenOverride, Map<String, dynamic>? filter}) async {
    return _service.getCategoriesByFilter(tokenOverride ?? '', filter ?? {});
  }

  Future<Category> fetchById(String? tokenOverride, String id) async {
    return _service.getCategoryById(tokenOverride ?? '', id);
  }

  Future<Category> create(Category category, {String? tokenOverride}) async {
    return _service.createCategory(tokenOverride ?? '', category);
  }

  Future<Category> update(Category category, {String? tokenOverride}) async {
    return _service.updateCategory(tokenOverride ?? '', category);
  }

  Future<void> delete(String id, {String? tokenOverride}) async {
    return _service.deleteCategory(id);
  }
}
