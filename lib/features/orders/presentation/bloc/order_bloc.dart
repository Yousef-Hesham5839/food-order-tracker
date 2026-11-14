import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository orderRepository;
  StreamSubscription? _orderSubscription;

  OrderBloc(this.orderRepository) : super(OrderInitial()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<WatchOrderEvent>(_onWatchOrder);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
  }

  Future<void> _onPlaceOrder(PlaceOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orderId = await orderRepository.placeOrder(event.order);
      emit(OrderPlacedSuccess(orderId));
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  Future<void> _onWatchOrder(WatchOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    await _orderSubscription?.cancel();
    await emit.forEach(
      orderRepository.watchOrder(event.orderId),
      onData: (order) => OrderTrackingUpdated(order),
      onError: (error, stackTrace) => OrderError(error.toString()),
    );
  }

  Future<void> _onUpdateOrderStatus(
      UpdateOrderStatusEvent event, Emitter<OrderState> emit) async {
    try {
      await orderRepository.updateOrderStatus(event.orderId, event.newStatus);
    } catch (e) {
      emit(OrderError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    return super.close();
  }
}