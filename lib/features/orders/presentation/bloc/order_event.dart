import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class PlaceOrderEvent extends OrderEvent {
  final OrderEntity order;
  const PlaceOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}

class WatchOrderEvent extends OrderEvent {
  final String orderId;
  const WatchOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatusEvent extends OrderEvent {
  final String orderId;
  final String newStatus;
  const UpdateOrderStatusEvent(this.orderId, this.newStatus);

  @override
  List<Object?> get props => [orderId, newStatus];
}

class WatchAllOrdersEvent extends OrderEvent {}