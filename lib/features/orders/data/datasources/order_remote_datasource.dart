import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> placeOrder(OrderModel order) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.ordersCollection)
          .add(order.toJson());
      return docRef.id;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // Real-time Stream for tracking
  Stream<OrderModel> watchOrder(String orderId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists || snapshot.data() == null) {
        throw const ServerException('Order not found');
      }
      return OrderModel.fromJson(snapshot.data()!, snapshot.id);
    });
  }

  Stream<List<OrderModel>> watchAllOrders() {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
          .toList();
    });
  }

  Future<List<OrderModel>> getMyOrders(String customerId) async {
    try {
      final query = await _firestore
          .collection(AppConstants.ordersCollection)
          .where('customerId', isEqualTo: customerId)
          .get();

      final orders = query.docs
          .map((doc) => OrderModel.fromJson(doc.data(), doc.id))
          .toList();

      orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return orders;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      final orderRef = _firestore.collection(AppConstants.ordersCollection).doc(orderId);
      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(orderRef);
        if (!snapshot.exists) throw const ServerException('Order not found');

        final history = List<Map<String, dynamic>>.from(snapshot.get('statusHistory') ?? []);
        history.add({
          'status': newStatus,
          'timestamp': Timestamp.fromDate(DateTime.now()),
        });

        transaction.update(orderRef, {
          'status': newStatus,
          'statusHistory': history,
        });
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}