import 'package:presupresto/models/category.dart';

import '../services/category_service.dart';

class CategoryRepository {
  final CategoryService _service;

  CategoryRepository({required CategoryService service}) : _service = service;

  Future<List<Category>> fetchAll({String? tokenOverride}) async {
    return _service.getCategories(tokenOverride ?? '');
  }
}
