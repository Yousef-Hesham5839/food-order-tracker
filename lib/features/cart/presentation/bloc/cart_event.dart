import 'package:equatable/equatable.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class AddToCartEvent extends CartEvent {
  final MenuItemEntity item;
  const AddToCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveFromCartEvent extends CartEvent {
  final MenuItemEntity item;
  const RemoveFromCartEvent(this.item);

  @override
  List<Object?> get props => [item];
}

class ClearCartEvent extends CartEvent {}