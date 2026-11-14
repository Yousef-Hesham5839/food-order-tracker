import 'package:equatable/equatable.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';

class CartItemEntity extends Equatable {
  final MenuItemEntity menuItem;
  final int quantity;

  const CartItemEntity({
    required this.menuItem,
    this.quantity = 1,
  });

  double get totalPrice => menuItem.price * quantity;

  CartItemEntity copyWith({
    MenuItemEntity? menuItem,
    int? quantity,
  }) {
    return CartItemEntity(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [menuItem, quantity];
}