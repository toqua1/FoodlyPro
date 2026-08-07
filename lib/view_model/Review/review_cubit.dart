import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:elmaleka_kitchen_project/data/models/review_model.dart';
import 'package:elmaleka_kitchen_project/view_model/Review/review_state.dart';
import '../../core/errors/app_error.dart';
import '../../core/errors/error_handler.dart';
import '../../data/datasources/review_data_source.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewDataSource dataSource;
  ReviewCubit(this.dataSource) : super(ReviewInitial());

  int _currentPage = 1;
  int _productId = -1;

  Future<void> fetchReviews(int productId) async {
    _productId = productId;
    emit(ReviewLoading());
    try {
      final myReview = await dataSource.getMyReview(productId);
      final summary = await dataSource.getReviewSummary(productId);
      final reviews = await dataSource.getProductReviews(productId, page: 1);
      _currentPage = 1;
      emit(ReviewLoaded(summary: summary, myReview: myReview, productReviews: reviews));
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(ReviewError(appErr.message));
    }
  }

  Future<void> addReview(AddReviewBody body) async {
    try {
      await dataSource.addReview(body);
      // emit(ReviewActionSuccess());
      // refresh -> this emits ReviewLoaded which the UI listens to
      await fetchReviews(body.productId);
      // don't emit ReviewActionSuccess here — it would replace ReviewLoaded.
      // If you need a "flash" success, emit it then re-emit the loaded state,
      // or better: let the caller show a SnackBar after this Future completes.
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(ReviewActionError(appErr.message));
    }
  }

  Future<void> updateReview(int reviewId, UpdateReviewBody body) async {
    try {
      await dataSource.updateReview(reviewId, body);
      await fetchReviews(_productId); // Refresh
      // emit(ReviewActionSuccess());
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(ReviewActionError(appErr.message));
    }
  }

  Future<void> deleteReview(int reviewId) async {
    try {
      await dataSource.deleteReview(reviewId);
      await fetchReviews(_productId); // Refresh
      // emit(ReviewActionSuccess());
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(ReviewActionError(appErr.message));
    }
  }

  // To handle pagination and "Load More" button
  Future<void> loadMoreReviews() async {
    if (state is ReviewLoaded) {
      final currentState = state as ReviewLoaded;
      if (currentState.productReviews.page >= (currentState.productReviews.total / currentState.productReviews.limit).ceil()) {
        return; // No more pages to load
      }
      try {
        final newReviews = await dataSource.getProductReviews(_productId, page: _currentPage + 1);
        _currentPage++;
        final updatedItems = [...currentState.productReviews.items, ...newReviews.items];
        emit(ReviewLoaded(
          summary: currentState.summary,
          myReview: currentState.myReview,
          productReviews: ReviewResponse(
            page: newReviews.page,
            limit: newReviews.limit,
            total: newReviews.total,
            items: updatedItems,
          ),
        ));
      } catch (e) {
        final appErr = e is AppError ? e : ErrorHandler.handle(e);
        emit(ReviewError(appErr.message));
      }
    }
  }
}