import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:elmaleka_kitchen_project/data/datasources/endpoints.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';
import '../models/cart_model.dart';

class CartRemoteDataSource {
  final Dio dio;
  CartRemoteDataSource(this.dio);

  Future<CartResponse> getCart() async{
   try{
     final response = await dio.get(ApiEndpoints.handleCartEndpoint);
     log('GET cart: status=${response.statusCode}, data=${response.data}');
     return CartResponse.fromJson(response.data);
   }catch(e,st){
     log('Cart parsing failed: $e\n$st');
     if (e is DioError) {
       if (e.error is AppError) throw e.error as AppError;
       throw ErrorHandler.handle(e);
     }
     throw ErrorHandler.handle(e);
   }
  }

  Future<void> clearCart() async{
    try{
      await dio.delete(ApiEndpoints.handleCartEndpoint);
    }catch(e){
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> addToCart(int productId,int sizeId, int quantity, List<int>
  addonIds)async{
    try{
      await dio.post(ApiEndpoints.handleCartEndpoint,
          data: {
            "productId" : productId,
            "sizeId" : sizeId,
            "addonIds" :addonIds,
            "quantity": quantity
          });
    }catch(e){
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }
  Future<void> removeItem(int itemId) async{
    try{
      await dio.delete('${ApiEndpoints.handleCartEndpoint}/$itemId');
    }catch(e){
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> updateItem(int itemId, int quantity) async{
    try{
      await dio.patch(
        '${ApiEndpoints.handleCartEndpoint}/$itemId',
        data: {
          "quantity": quantity
        },
      );
    }catch(e){
      if (e is DioError) {
        if (e.error is AppError) throw e.error as AppError;
        throw ErrorHandler.handle(e);
      }
      throw ErrorHandler.handle(e);
    }
  }
}