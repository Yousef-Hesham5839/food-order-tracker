import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_item_entity.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<ClearCartEvent>(_onClearCart);
  }

  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere((i) => i.menuItem.id == event.item.id);

    if (index >= 0) {
      final existingItem = currentItems[index];
      currentItems[index] = existingItem.copyWith(quantity: existingItem.quantity + 1);
    } else {
      currentItems.add(CartItemEntity(menuItem: event.item, quantity: 1));
    }

    emit(CartState(items: currentItems));
  }

  void _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) {
    final currentItems = List<CartItemEntity>.from(state.items);
    final index = currentItems.indexWhere((i) => i.menuItem.id == event.item.id);

    if (index >= 0) {
      final existingItem = currentItems[index];
      if (existingItem.quantity > 1) {
        currentItems[index] = existingItem.copyWith(quantity: existingItem.quantity - 1);
      } else {
        currentItems.removeAt(index);
      }
      emit(CartState(items: currentItems));
    }
  }

  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    emit(const CartState(items: []));
  }
}