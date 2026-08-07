part of 'cart_cubit.dart';
/*using equatable with your sealed class states is a good idea so that Bloc knows when the state has really changed (and avoids unnecessary rebuilds)*/
@immutable
sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {
  //there is not props here we need to combare with
}

class CartLoading extends CartState {}

class CartLoaded extends CartState{
  final CartResponse cart ;
  const CartLoaded(this.cart);
// mention it as we need to compare by cart
  @override
  List<Object?> get props => [cart];
}

class CartError extends CartState{
  final String message;
  const  CartError(this.message);

  @override
  List<Object?> get props => [message];
}
