import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<String> placeOrder(OrderEntity order);
  Stream<OrderEntity> watchOrder(String orderId);
  Future<List<OrderEntity>> getMyOrders(String customerId);
  Future<void> updateOrderStatus(String orderId, String newStatus);
}