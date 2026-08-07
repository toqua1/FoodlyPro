import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:elmaleka_kitchen_project/core/errors/app_error.dart';
import 'package:elmaleka_kitchen_project/core/errors/error_handler.dart';
import 'package:elmaleka_kitchen_project/data/datasources/endpoints.dart';
import 'package:elmaleka_kitchen_project/data/models/review_model.dart';

class ReviewDataSource {
  final Dio dio;

  ReviewDataSource(this.dio);

  Future<void> addReview(AddReviewBody body) async {
    try {
      await dio.post(ApiEndpoints.review, data: body.toJson());
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> updateReview(int reviewId, UpdateReviewBody body) async {
    try {
      await dio.put('${ApiEndpoints.review}/$reviewId', data: body.toJson());
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteReview(int reviewId) async {
    try {
      await dio.delete('${ApiEndpoints.review}/$reviewId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ReviewResponse> getProductReviews(int productId,
      {int page = 1, int limit = 10}
      ) async {
    try {
      final url = '${ApiEndpoints.reviewOfProduct}/$productId';
      final response = await dio.get(url,
          queryParameters: {'page': page, 'limit': limit}
      );
      log('reviews json: ${response.data}');
      return ReviewResponse.fromJson(response.data);
    } catch (e) {
      log(e.toString());
      throw _handleError(e);
    }
  }

  Future<MeReviewModel?> getMyReview(int productId) async {
    try {
      final url = ApiEndpoints.getReviewDetailed(productId, true);
      final response = await dio.get(url);
      final data = response.data;
      if (data == null || (data is List && data.isEmpty)) {
        return null;
      }
      log('my reviews json: ${data}');

      // If backend returns a JSON string, decode it => this in case no reviews found
      if (data is String) {
        log('body response string: true');
        final trimmed = data.trim();
        if (trimmed.isEmpty || trimmed == 'null') return null;
        try {
          final decoded = jsonDecode(trimmed);
          if (decoded is Map<String, dynamic>) {
            return MeReviewModel.fromJson(decoded);
          } else {
            // If it's List or other -> treat as no review
            return null;
          }
        } catch (e, st) {
          log('Failed to jsonDecode getMyReview string: $e\n$st');
          return null;
        }
      }

      if (data is Map<String, dynamic>) {
        final payload = data.containsKey('data') && data['data'] is Map
            ? data['data'] as Map<String, dynamic>
            : data;
        return MeReviewModel.fromJson(payload);
      }

      // If API returns an empty list (or other) -> treat as no review
      if (data is List && data.isEmpty) return null;

      // Unknown shape -> return null rather than throwing
      return null;
      // return MeReviewModel.fromJson(response.data);
    } catch (e) {
      log(e.toString());
      if (e is DioError && e.response?.statusCode == 404) {
        return null; // Return null if review not found (404 error)
      }
      throw _handleError(e);
    }
  }

  Future<ReviewSummary> getReviewSummary(int productId) async {
    try {
      final url = ApiEndpoints.getReviewDetailed(productId, false);
      final response = await dio.get(url);
      log('reviews summary json: ${response.data}');

      return ReviewSummary.fromJson(response.data);
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