import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:elmaleka_kitchen_project/data/datasources/endpoints.dart';

import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';

class PaymentDataSource {
  final Dio dio;

  PaymentDataSource(this.dio);

  Future<String> generatePaymentLink(int orderId) async {
    try {
      final response = await dio.post(ApiEndpoints.payment(orderId));
      log(response.data.toString());
      return response.data['iframeUrl'];
    } catch (e) {
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
