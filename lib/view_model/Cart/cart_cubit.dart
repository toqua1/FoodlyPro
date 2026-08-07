// cart_cubit.dart
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:elmaleka_kitchen_project/core/errors/error_handler.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import '../../core/errors/app_error.dart';
import '../../data/datasources/cart_remote_data_source.dart';
import '../../data/models/cart_model.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRemoteDataSource remoteDataSource;

  CartCubit(this.remoteDataSource) : super(CartInitial());

  Future<void> fetchCart() async {
    // if (state is CartLoaded) {
    //   final loadedState = state as CartLoaded;
    //   // You can add a check for empty lists here if needed, but this is a good start.
    //   if (loadedState.cart.items.isNotEmpty) {
    //     return;
    //   }
    // }
    emit(CartLoading());
    try {
      final cartData = await remoteDataSource.getCart();
      emit(CartLoaded(cartData));
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(CartError(appErr.message));
    }
  }

  // Method to add a product to the cart
  Future<void> addToCart(int productId, int sizeId, int quantity, List<int> addonIds) async {
    emit(CartLoading());
    try {
      await remoteDataSource.addToCart(productId, sizeId, quantity, addonIds);
      // After adding, fetch the updated cart to reflect the changes
      await fetchCart();
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(CartError(appErr.message));
    }
  }

  // Method to clear all items from the cart
  Future<void> clearCart() async {
    emit(CartLoading());
    try {
      await remoteDataSource.clearCart();
      await fetchCart();
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(CartError(appErr.message));
    }
  }

  Future<void> removeItem(int itemId) async {
    emit(CartLoading());
    try {
      await remoteDataSource.removeItem(itemId);
      await fetchCart();
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(CartError(appErr.message));
    }
  }

  Future<void> updateItem(int itemId, int quantity) async {
    emit(CartLoading());
    try {
      await remoteDataSource.updateItem(itemId, quantity);
      await fetchCart();
    } catch (e) {
      final appErr = e is AppError ? e : ErrorHandler.handle(e);
      emit(CartError(appErr.message));
    }
  }
}
