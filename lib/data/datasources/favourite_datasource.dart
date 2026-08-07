import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:elmaleka_kitchen_project/core/errors/app_error.dart';
import 'package:elmaleka_kitchen_project/core/errors/error_handler.dart';
import 'package:elmaleka_kitchen_project/data/datasources/endpoints.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';

class FavouriteDataSource {
  final Dio dio;
  FavouriteDataSource(this.dio);

  Future<Map<String, dynamic>> addToFav(String prodId) async {
    try {
      final resp = await dio.post(ApiEndpoints.favourites, data: {'productId': prodId});
      return Map<String, dynamic>.from(resp.data ?? {});
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> removeFavourite(String prodId) async {
    try {
      final resp = await dio.delete('${ApiEndpoints.favourites}/$prodId', data: {'productId': prodId});
      return Map<String, dynamic>.from(resp.data ?? {});
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Toggle favourite :
  Future<Map<String, dynamic>> toggleFavourite(String prodId) async {
    try {
      final url = '${ApiEndpoints.favourites}/toggle';
      final resp = await dio.post(url, data: {'productId': prodId});
      log('toggleFavourite resp: ${resp.data}');
      return Map<String, dynamic>.from(resp.data ?? {});
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<ProductModel>> getAllFavourites() async {
    try {
      final url = ApiEndpoints.favourites;
      final response = await dio.get(url);
      log('fav json: ${response.data}');
      final list = List<Map<String, dynamic>>.from(response.data as List);
      return list.map((e) => ProductModel.fromJson(e)).toList();
    } catch (e) {
      log(e.toString());
      throw _handleError(e);
    }
  }

  AppError _handleError(dynamic e) {
    if (e is DioError) {
      if (e.error is AppError) return e.error as AppError;
      return ErrorHandler.handle(e);
    }
    return ErrorHandler.handle(e);
  }
}

// import 'dart:developer';
// import 'package:dio/dio.dart';
// import 'package:elmaleka_kitchen_project/core/errors/app_error.dart';
// import 'package:elmaleka_kitchen_project/core/errors/error_handler.dart';
// import 'package:elmaleka_kitchen_project/data/datasources/endpoints.dart';
// import 'package:elmaleka_kitchen_project/data/models/review_model.dart';
//
// class FavouriteDataSource {
//   final Dio dio;
//
//   FavouriteDataSource(this.dio);
//
//   Future<void> addToFav(String prodId) async {
//     try {
//       await dio.post(ApiEndpoints.favourites, data: {'productId': prodId});
//     } catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<void> removeFavourite(String prodId) async {
//     try {
//       await dio.delete('${ApiEndpoints.favourites}/$prodId',data:{'productId': prodId});
//     } catch (e) {
//       throw _handleError(e);
//     }
//   }
//
//   Future<FavResponse> getAllFavourites() async {
//     try {
//       final url = '${ApiEndpoints.favourites}';
//       final response = await dio.get(url);
//       log('fav json: ${response.data}');
//       return FavResponse.fromJson(response.data);
//     } catch (e) {
//       log(e.toString());
//       throw _handleError(e);
//     }
//   }
//
//   AppError _handleError(dynamic e) {
//     if (e is DioError) {
//       if (e.error is AppError) return e.error as AppError;
//       return ErrorHandler.handle(e);
//     }
//     return ErrorHandler.handle(e);
//   }
// }