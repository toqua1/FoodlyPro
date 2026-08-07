import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:elmaleka_kitchen_project/data/datasources/products_remote_datasource.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';
import '../../data/models/category_model.dart';
import '../../data/models/product_detail_model.dart';
//this file for getting products sections in home screen
part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final ProductsDataSource remote;
  ProductsCubit(this.remote) : super(ProductsInitial());

  // Future<void> getAllCategories() async {
  //   emit(CategoriesLoading());
  //   try {
  //     final res = await remote.getAllCategories(); /*List<CatModel>*/
  //     emit(CategoriesLoaded(res));
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  Future<void> getProductsForAllCategories() async {
    // if (state is ProductsLoaded) {
    //   return; // Data is already loaded, do nothing.
    // }

    emit(ProductsLoading());
    try {
      final futures = await Future.wait([
        remote.getProducts(categoryId: 1),
        remote.getProducts(categoryId: 2),
        remote.getProducts(categoryId: 3),
      ]);

      emit(ProductsLoaded(
        productsSection1: futures[0],
        productsSection2: futures[1],
        productsSection3: futures[2],
      ));
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(ProductsError(appErr.message));
    }
  }

}
