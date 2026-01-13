import 'package:equatable/equatable.dart';
import 'package:presupresto/models/category.dart';
import 'package:presupresto/models/transaction.dart';

abstract class CategoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {
  final String userId;

  LoadCategories({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class AddCategory extends CategoryEvent {
  final Category category;
  AddCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class Cateogry {}

class UpdateCategory extends CategoryEvent {
  final Category category;

   UpdateCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class DeleteCategory extends CategoryEvent {
  final String id;
  DeleteCategory(this.id);
  @override
  List<Object?> get props => [id];
}
