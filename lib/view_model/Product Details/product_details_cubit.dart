import 'package:bloc/bloc.dart';
import 'package:elmaleka_kitchen_project/data/datasources/products_remote_datasource.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';
import '../../data/models/product_detail_model.dart';
//this file is for the product details screen
part 'product_details_state.dart';
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductsDataSource remote ;

  ProductDetailsCubit(this.remote) : super(ProductDetailsInitial());
  Future<void> fetchProduct(int productId) async {
    emit(ProductDetailsLoading());
    try {
      final model = await remote.getSpecificProduct(productId);
      emit(ProductDetailsLoaded(model));
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(ProductDetailsError(appErr.message));
    }
  }
}
