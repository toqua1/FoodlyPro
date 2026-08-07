part of 'food_menu_list_cubit.dart';

@immutable
sealed class FoodMenuState {}
final class FoodMenuInitial extends FoodMenuState {}
final class FoodMenuLoading extends FoodMenuState {}
final class FoodMenuLoaded extends FoodMenuState {
  final List<ProductModel> products;
  FoodMenuLoaded({required this.products});
}
final class FoodMenuError extends FoodMenuState {
  final String message;
  FoodMenuError(this.message);
}