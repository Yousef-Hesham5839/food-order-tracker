import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderPlacedSuccess extends OrderState {
  final String orderId;
  const OrderPlacedSuccess(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class OrderTrackingUpdated extends OrderState {
  final OrderEntity order;
  const OrderTrackingUpdated(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderError extends OrderState {
  final String message;
  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

class AllOrdersLoaded extends OrderState {
  final List<OrderEntity> orders;
  const AllOrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}