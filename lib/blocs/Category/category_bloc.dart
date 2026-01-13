import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:presupresto/models/category.dart';

import 'category_event.dart';
import 'category_state.dart';
import 'package:presupresto/repositories/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoad);
    on<AddCategory>(_onAdd);
    on<UpdateCategory>(_onUpdate);
    on<DeleteCategory>(_onDelete);
  }

  Future<void> _onLoad(
      LoadCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final items = await repository.fetchAllByFilter(
        filter: {
          'userId': event.userId,
        },
      );
      emit(CategoryLoaded(items));
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }

  Future<void> _onAdd(AddCategory event, Emitter<CategoryState> emit) async {
    final current = state is CategoryLoaded
        ? (state as CategoryLoaded).items
        : <Category>[];
    emit(CategoryLoading());
    try {
      final created = await repository.create(event.category);
      emit(CategoryLoaded([created, ...current]));
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }

  Future<void> _onUpdate(
      UpdateCategory event, Emitter<CategoryState> emit) async {
    final current = state is CategoryLoaded
        ? (state as CategoryLoaded).items
        : <Category>[];
    emit(CategoryLoading());
    try {
      final updated = await repository.update(event.category);
      final updatedList = current.map((category) {
        return category.id == updated.id ? updated : category;
      }).toList();
      emit(CategoryLoaded(updatedList));
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }

  Future<void> _onDelete(
      DeleteCategory event, Emitter<CategoryState> emit) async {
    final current = state is CategoryLoaded
        ? (state as CategoryLoaded).items
        : <Category>[];
    emit(CategoryLoading());
    try {
      // Assuming deleteCategory is a method in repository
      await repository.delete(event.id);
      final updatedList =
          current.where((category) => category.id != event.id).toList();
      emit(CategoryLoaded(updatedList));
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }
}
