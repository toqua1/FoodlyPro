part of 'favourite_cubit.dart';

@immutable
sealed class FavouriteState {}

final class FavouriteInitial extends FavouriteState {}

final class FavouriteLoading extends FavouriteState {}

final class FavouriteLoaded extends FavouriteState {
  final List<ProductModel> items;
  final Set<int> togglingIds;
  FavouriteLoaded({required this.items, Set<int>? togglingIds})
      : togglingIds = togglingIds ?? {};
}

final class FavouriteError extends FavouriteState {
  final String message;
  FavouriteError({required this.message});
}
