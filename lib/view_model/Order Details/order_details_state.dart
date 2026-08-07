part of 'order_details_cubit.dart';

sealed class OrderDetailsState extends Equatable {
  const OrderDetailsState();

  @override
  List<Object> get props => [];
}

final class OrderDetailsInitial extends OrderDetailsState {}

final class OrderDetailsLoading extends OrderDetailsState {}

final class OrderDetailsLoaded extends OrderDetailsState {
  final OrderModel order;
  const OrderDetailsLoaded({required this.order});

  @override
  List<Object> get props => [order];
}

final class OrderDetailsError extends OrderDetailsState {
  final String message;
  const OrderDetailsError({required this.message});

  @override
  List<Object> get props => [message];
}