import 'package:dio/dio.dart';
import 'package:elmaleka_kitchen_project/data/datasources/endpoints.dart';

import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource {
  final Dio dio;

  const OrderRemoteDataSource(this.dio);

  Future<int> createOrder(int addressId, String paymentMethod) async {
    try {
      final res = await dio.post(ApiEndpoints.createOrdersEndpoint,
          data: {
            "addressId": addressId,
            "paymentMethod": paymentMethod
          }
      );
      return res.data['id'];
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await dio.get('ApiEndpoints.myOrders'); // Replace with your actual endpoint
      final List<dynamic> ordersJson = response.data as List<dynamic>;
      return ordersJson.map((json) => OrderModel.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      // Handle Dio errors
      throw Exception('Failed to fetch orders: ${e.message}');
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