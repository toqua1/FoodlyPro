part of 'products_cubit.dart';

@immutable
sealed class ProductsState extends Equatable {
  List<Object?> get props => [];
}

final class ProductsInitial extends ProductsState {}
final class ProductsLoading extends ProductsState {}
final class ProductsLoaded extends ProductsState {
  // final List<ProductModel> items;
  // ProductsLoaded(this.items);
  final List<ProductModel> productsSection1;
  final List<ProductModel> productsSection2;
  final List<ProductModel> productsSection3;

  ProductsLoaded({
    required this.productsSection1,
    required this.productsSection2,
    required this.productsSection3,
  });
  List<Object?> get props => [productsSection1,productsSection2,productsSection3];

}

final class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
  List<Object?> get props => [message];
}
// final class CategoriesLoading extends ProductsState {}

// final class CategoriesLoaded extends ProductsState {
//   final List<CategoryModel> items;
//   CategoriesLoaded(this.items);
//   List<Object?> get props => [items];
// }
// final class CategoriesError extends ProductsState {}/*i do not need message
// as i will do them static and i need call only to get the images and if error
// make ! instead of image */
//
