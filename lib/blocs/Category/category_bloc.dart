import 'dart:async';
import 'package:bloc/bloc.dart';

import 'category_event.dart';
import 'category_state.dart';
import 'package:presupresto/repositories/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoad);
  }

  Future<void> _onLoad(LoadCategories _, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final items = await repository.fetchAll();
      emit(CategoryLoaded(items));
    } catch (e) {
      emit(CategoryFailure(e.toString()));
    }
  }
}
