import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
import '../../data/datasources/favourite_datasource.dart';
part 'favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> {
  final FavouriteDataSource favouriteDataSource;
  FavouriteCubit({required this.favouriteDataSource}) : super(FavouriteInitial());

  /// Fetch all favourites from API
  Future<void> fetchFavourites() async {
    emit(FavouriteLoading());
    try {
      final list = await favouriteDataSource.getAllFavourites();
      emit(FavouriteLoaded(items: list));
    } catch (e, st) {
      log('fetchFavourites error: $e\n$st');
      emit(FavouriteError(message: e.toString()));
    }
  }
  /// Generic toggle function used by both the favourites list and product details.
  /// Calls the single toggle endpoint once.
  Future<void> toggleFavourite(int productId) async {
    final cur = state;
    // keep a copy of items (may be empty)
    List<ProductModel> items = [];
    Set<int> togglingIds = {};
    if (cur is FavouriteLoaded) {
      items = List<ProductModel>.from(cur.items);
      togglingIds = Set<int>.from(cur.togglingIds);
    }

    // Optimistic UI: add toggling flag
    togglingIds.add(productId);
    emit(FavouriteLoaded(items: items, togglingIds: togglingIds));

    try {
      final resp = await favouriteDataSource.toggleFavourite(productId.toString());
      final favored = resp['favored'] == true;

      // Update items list if this product is present, else optionally add/remove
      final idx = items.indexWhere((p) => p.id == productId);
      if (idx >= 0) {
        // update existing item
        final updated = items[idx].copyWith(isFavorite: favored);
        items[idx] = updated;
      } else {
        // If product isn't in list and favored==true, we could insert a placeholder or refetch.
        // Here we'll simply refetch the list to keep consistency (safer).
        if (favored) {
          final fresh = await favouriteDataSource.getAllFavourites();
          items = fresh;
        }
      }

      togglingIds.remove(productId);
      emit(FavouriteLoaded(items: items, togglingIds: togglingIds));
    } catch (e, st) {
      log('toggleFavourite error: $e\n$st');
      // revert toggling flag
      final restored = Set<int>.from((state is FavouriteLoaded) ? (state as FavouriteLoaded).togglingIds : {})..remove(productId);
      emit(FavouriteLoaded(items: items, togglingIds: restored));
      // bubble up or handle as needed
    }
  }

  /// Convenience wrapper when toggling from product details.
  /// It calls the same single toggle endpoint, and ensures favourites list is in sync.
  Future<void> toggleFromDetails(ProductModel product) async {
    await toggleFavourite(product.id);
    // After toggling, ensure list is in sync: fetch favourites once
    try {
      await fetchFavourites();
    } catch (_) {}
  }
}

// import 'dart:async';
// import 'dart:developer';
//
// import 'package:bloc/bloc.dart';
// import 'package:meta/meta.dart';
// import 'package:elmaleka_kitchen_project/data/models/product_model.dart';
// import '../../data/datasources/favourite_datasource.dart';
// part 'favourite_state.dart';
//
// class FavouriteCubit extends Cubit<FavouriteState> {
//   final FavouriteDataSource favouriteDataSource;
//   FavouriteCubit({required this.favouriteDataSource}) : super(FavouriteInitial());
//
//   /// Fetch all favourites from API
//   Future<void> fetchFavourites() async {
//     emit(FavouriteLoading());
//     try {
//       final list = await favouriteDataSource.getAllFavourites();
//       emit(FavouriteLoaded(items: list));
//     } catch (e, st) {
//       log('fetchFavourites error: $e\n$st');
//       emit(FavouriteError(message: e.toString()));
//     }
//   }
//
//   /// Toggle favourite when called from favourites list (item exists in list)
//   Future<void> toggleFavouriteFromList(int productId) async {
//     final cur = state;
//     if (cur is! FavouriteLoaded) return;
//     final items = List<ProductModel>.from(cur.items);
//     final idx = items.indexWhere((p) => p.id == productId);
//     if (idx == -1) return;
//
//     final product = items[idx];
//     final currentlyFav = product.isFavorite ?? false;
//
//     // optimistic UI: set toggling flag
//     final toggling = Set<int>.from(cur.togglingIds)..add(productId);
//     emit(FavouriteLoaded(items: items, togglingIds: toggling));
//
//     try {
//       Map<String, dynamic> resp;
//       if (currentlyFav) {
//         resp = await favouriteDataSource.removeFavourite(productId.toString());
//       } else {
//         resp = await favouriteDataSource.addToFav(productId.toString());
//       }
//
//       final favored = resp['favored'] == true;
//       // update product
//       final updated = product.copyWith(isFavorite: favored, favoritesCount: resp['favoritesCount'] ?? product.favoritesCount);
//       items[idx] = updated;
//
//       toggling.remove(productId);
//       emit(FavouriteLoaded(items: items, togglingIds: toggling));
//     } catch (e, st) {
//       log('toggleFavouriteFromList error: $e\n$st');
//       // revert toggling
//       final restoredToggling = Set<int>.from((state is FavouriteLoaded) ? (state as FavouriteLoaded).togglingIds : {})..remove(productId);
//       emit(FavouriteLoaded(items: items, togglingIds: restoredToggling));
//     }
//   }
//
//   /// Toggle favourite when called from product details screen
//   /// If the item not present in current list, it will be added/removed depending on 'favored'.
//   Future<void> toggleFromDetails(ProductModel product) async {
//     final cur = state;
//     List<ProductModel> items = [];
//     if (cur is FavouriteLoaded) items = List<ProductModel>.from(cur.items);
//
//     // optimistic local flip (UI feedback)
//     final optimistic = product.copyWith(isFavorite: !(product.isFavorite ?? false));
//     // add temporary toggling state
//     emit(FavouriteLoaded(items: items, togglingIds: {product.id}));
//
//     try {
//       Map<String, dynamic> resp;
//       final currentlyFav = product.isFavorite ?? false;
//       if (currentlyFav) {
//         resp = await favouriteDataSource.removeFavourite(product.id.toString());
//       } else {
//         resp = await favouriteDataSource.addToFav(product.id.toString());
//       }
//
//       final favored = resp['favored'] == true;
//
//       if (favored) {
//         // add or update
//         final idx = items.indexWhere((p) => p.id == product.id);
//         final updated = product.copyWith(isFavorite: true, favoritesCount: resp['favoritesCount'] ?? product.favoritesCount);
//         if (idx >= 0) items[idx] = updated;
//         else items.insert(0, updated);
//       } else {
//         items.removeWhere((p) => p.id == product.id);
//       }
//
//       emit(FavouriteLoaded(items: items));
//     } catch (e, st) {
//       log('toggleFromDetails error: $e\n$st');
//       // restore previous state if any
//       if (cur is FavouriteLoaded) emit(cur);
//       else emit(FavouriteInitial());
//       rethrow;
//     }
//   }
// }
