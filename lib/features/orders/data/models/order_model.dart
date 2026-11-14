import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.customerId,
    required super.customerName,
    required super.items,
    required super.totalPrice,
    required super.status,
    required super.statusHistory,
    required super.estimatedTime,
    required super.createdAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json, String docId) {
    return OrderModel(
      id: docId,
      customerId: json['customerId'] ?? '',
      customerName: json['customerName'] ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'pending',
      estimatedTime: json['estimatedTime'] ?? 30,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      items: (json['items'] as List<dynamic>? ?? []).map((i) {
        return OrderItemEntity(
          id: i['id'] ?? '',
          name: i['name'] ?? '',
          price: (i['price'] as num?)?.toDouble() ?? 0.0,
          quantity: i['quantity'] ?? 1,
        );
      }).toList(),
      statusHistory: (json['statusHistory'] as List<dynamic>? ?? []).map((h) {
        return OrderStatusHistory(
          status: h['status'] ?? '',
          timestamp: (h['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'totalPrice': totalPrice,
      'status': status,
      'estimatedTime': estimatedTime,
      'createdAt': Timestamp.fromDate(createdAt),
      'items': items
          .map((i) => {
                'id': i.id,
                'name': i.name,
                'price': i.price,
                'quantity': i.quantity,
              })
          .toList(),
      'statusHistory': statusHistory
          .map((h) => {
                'status': h.status,
                'timestamp': Timestamp.fromDate(h.timestamp),
              })
          .toList(),
    };
  }
}