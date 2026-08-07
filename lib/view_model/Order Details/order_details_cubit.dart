import 'package:bloc/bloc.dart';
import 'package:elmaleka_kitchen_project/core/errors/error_handler.dart';
import 'package:elmaleka_kitchen_project/data/datasources/order_remote_datasource.dart';
import 'package:elmaleka_kitchen_project/data/models/order_model.dart';
import 'package:equatable/equatable.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
  final OrderRemoteDataSource orderRemoteDataSource;

  OrderDetailsCubit(this.orderRemoteDataSource) : super(OrderDetailsInitial());

  Future<void> fetchOrderById(int orderId) async {
    emit(OrderDetailsLoading());
    try {
      // 1. Fetch the list of all orders
      final List<OrderModel> orders = await orderRemoteDataSource.getMyOrders();

      // 2. Search for the specific order by ID
      final OrderModel order = orders.firstWhere(
            (o) => o.id == orderId,
        orElse: () => throw Exception('Order not found.'),
      );

      // 3. Emit the found order
      emit(OrderDetailsLoaded(order: order));
    } catch (e) {
      // Handle all errors, including "order not found"
      emit(OrderDetailsError(message: e.toString()));
    }
  }
}