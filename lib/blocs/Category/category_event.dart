import 'package:equatable/equatable.dart';
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
  final String name;
  final String description;
  final String color;
  final String icon;
  AddCategory(this.name, this.description, this.color, this.icon);
  @override
  List<Object?> get props => [name];
}

class UpdateCategory extends CategoryEvent {
  final String id;
  final String name;
  final String description;
  final String color;
  final String icon;
  UpdateCategory(this.id, this.name, this.description, this.color, this.icon);
  @override
  List<Object?> get props => [id];
}

class DeleteCategory extends CategoryEvent {
  final String id;
  DeleteCategory(this.id);
  @override
  List<Object?> get props => [id];
}
