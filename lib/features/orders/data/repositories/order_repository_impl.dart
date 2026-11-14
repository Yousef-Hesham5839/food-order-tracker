import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> placeOrder(OrderEntity order) {
    final model = OrderModel(
      id: order.id,
      customerId: order.customerId,
      customerName: order.customerName,
      items: order.items,
      totalPrice: order.totalPrice,
      status: order.status,
      statusHistory: order.statusHistory,
      estimatedTime: order.estimatedTime,
      createdAt: order.createdAt,
    );
    return remoteDataSource.placeOrder(model);
  }

  @override
  Stream<OrderEntity> watchOrder(String orderId) {
    return remoteDataSource.watchOrder(orderId);
  }

  @override
  Future<List<OrderEntity>> getMyOrders(String customerId) {
    return remoteDataSource.getMyOrders(customerId);
  }

  @override
  Future<void> updateOrderStatus(String orderId, String newStatus) {
    return remoteDataSource.updateOrderStatus(orderId, newStatus);
  }

  @override
  Stream<List<OrderEntity>> watchAllOrders() {
    return remoteDataSource.watchAllOrders();
  }
}