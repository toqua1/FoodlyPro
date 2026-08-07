import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:elmaleka_kitchen_project/Services/api_services.dart';
import 'package:elmaleka_kitchen_project/core/errors/error_handler.dart';
import 'package:elmaleka_kitchen_project/data/datasources/auth_remote_datasource.dart';
import 'package:elmaleka_kitchen_project/data/datasources/endpoints.dart';
import 'package:elmaleka_kitchen_project/data/models/category_model.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';

import '../../core/errors/app_error.dart';
import '../models/product_detail_model.dart';

class ProductsDataSource {
  final Dio dio;
  ProductsDataSource(this.dio);
  final AuthRemoteDatasource authRemoteDatasource = AuthRemoteDatasource(ApiServices().dio);

  Future<List<CategoryModel>> getAllCategories() async{
    try{
      final res = await dio.get(ApiEndpoints.getAllCategories);
      return res.data.map((e)=>CategoryModel.fromJson(e)).toList ;
    }catch(e){
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
}

Future<List<ProductModel>> getProducts({String? foodType, int? categoryId}) async{
  try{
    final url = ApiEndpoints.getProducts(foodType: foodType, categoryId: categoryId);
    final res = await dio.get(url);

    final List<dynamic> data = res.data;
    return data.map((e) => ProductModel.fromJson(e)).toList();
    }catch(e){
    if (e is DioError) {
      if (e.error is AppError) throw e.error as AppError;
      throw ErrorHandler.handle(e);
    }
    throw ErrorHandler.handle(e);
    }
}

  Future<ProductDetailModel> getSpecificProduct(int productId) async {
    try {
      final url = '${ApiEndpoints.baseProducts}/$productId';
      final res = await dio.get(url);
      return ProductDetailModel.fromJson(res.data);
    } catch (e) {
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }

}
