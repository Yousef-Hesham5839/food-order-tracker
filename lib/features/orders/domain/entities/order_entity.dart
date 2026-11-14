import 'package:equatable/equatable.dart';

class OrderStatusHistory extends Equatable {
  final String status;
  final DateTime timestamp;

  const OrderStatusHistory({
    required this.status,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [status, timestamp];
}

class OrderItemEntity extends Equatable {
  final String id;
  final String name;
  final double price;
  final int quantity;

  const OrderItemEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  @override
  List<Object?> get props => [id, name, price, quantity];
}

class OrderEntity extends Equatable {
  final String id;
  final String customerId;
  final String customerName;
  final List<OrderItemEntity> items;
  final double totalPrice;
  final String status;
  final List<OrderStatusHistory> statusHistory;
  final int estimatedTime;
  final DateTime createdAt;

  const OrderEntity({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.statusHistory,
    required this.estimatedTime,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        customerId,
        customerName,
        items,
        totalPrice,
        status,
        statusHistory,
        estimatedTime,
        createdAt,
      ];
}