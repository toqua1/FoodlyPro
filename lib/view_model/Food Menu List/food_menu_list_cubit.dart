import 'package:elmaleka_kitchen_project/data/datasources/products_remote_datasource.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';

part 'food_menu_list_state.dart';
//this file is for the food menu list of products screen
class FoodMenuCubit extends Cubit<FoodMenuState> {
  final ProductsDataSource remote;
  FoodMenuCubit(this.remote) : super(FoodMenuInitial());

  Future<void> getProducts({String? foodType, int? categoryId}) async {
    // if (state is FoodMenuLoaded && (state as FoodMenuLoaded).products.isNotEmpty) {
    //   return; // Already loaded, do not re-fetch
    // }
    emit(FoodMenuLoading());
    try {
      final res = await remote.getProducts(foodType: foodType, categoryId: categoryId);
      emit(FoodMenuLoaded(products: res));
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(FoodMenuError(appErr.message));
    }
  }
}