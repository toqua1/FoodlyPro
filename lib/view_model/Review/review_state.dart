import 'package:elmaleka_kitchen_project/data/models/review_model.dart';
import 'package:equatable/equatable.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final ReviewSummary? summary;
  final MeReviewModel? myReview;
  final ReviewResponse productReviews;

  const ReviewLoaded({
    this.summary,
    this.myReview,
    required this.productReviews,
  });

  @override
  List<Object?> get props => [summary, myReview, productReviews];
}

class ReviewError extends ReviewState {
  final String message;
  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}

class ReviewActionSuccess extends ReviewState {}
class ReviewActionError extends ReviewState {
  final String message;
  const ReviewActionError(this.message);

  @override
  List<Object?> get props => [message];
}