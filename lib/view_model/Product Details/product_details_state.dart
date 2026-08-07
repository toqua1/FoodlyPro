part of 'product_details_cubit.dart';

sealed class ProductDetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}
class ProductDetailsInitial extends ProductDetailsState {}
class ProductDetailsLoading extends ProductDetailsState {}
class ProductDetailsLoaded extends ProductDetailsState {
  final ProductDetailModel product;
  ProductDetailsLoaded(this.product);
  @override List<Object?> get props => [product];
}
class ProductDetailsError extends ProductDetailsState {
  final String msg;
  ProductDetailsError(this.msg);
  @override List<Object?> get props => [msg];
}
