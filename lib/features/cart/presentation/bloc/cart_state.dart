import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';

class CartState extends Equatable {
  final List<CartItemEntity> items;

  const CartState({this.items = const []});

  double get totalAmount =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  int get totalItemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [items];
}