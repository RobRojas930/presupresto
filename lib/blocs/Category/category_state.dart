import 'package:equatable/equatable.dart';
import 'package:presupresto/models/category.dart';

abstract class CategoryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> items;
  CategoryLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class CategoryFailure extends CategoryState {
  final String message;
  CategoryFailure(this.message);
  @override
  List<Object?> get props => [message];
}
