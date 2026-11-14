import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/presentation/bloc/order_bloc.dart';
import '../../../orders/presentation/bloc/order_event.dart';
import '../../../orders/presentation/bloc/order_state.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderPlacedSuccess) {
          context.read<CartBloc>().add(ClearCartEvent());
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Order placed successfully! 🍕🎉'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          
          Navigator.pop(context);
        } else if (state is OrderError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.secondaryColor,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Cart 🛒'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppTheme.secondaryColor),
              onPressed: () {
                context.read<CartBloc>().add(ClearCartEvent());
              },
            ),
          ],
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return const Center(
                child: Text(
                  'Your cart is empty! 🍔',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 16),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final cartItem = state.items[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.menuItem.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${cartItem.menuItem.price.toStringAsFixed(2)} EGP',
                                    style: const TextStyle(color: AppTheme.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: AppTheme.textSecondary),
                                  onPressed: () {
                                    context.read<CartBloc>().add(RemoveFromCartEvent(cartItem.menuItem));
                                  },
                                ),
                                Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryColor),
                                  onPressed: () {
                                    context.read<CartBloc>().add(AddToCartEvent(cartItem.menuItem));
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Bottom Checkout Panel
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount:',
                              style: TextStyle(fontSize: 16, color: AppTheme.textSecondary),
                            ),
                            Text(
                              '${state.totalAmount.toStringAsFixed(2)} EGP',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        BlocBuilder<OrderBloc, OrderState>(
                          builder: (context, orderState) {
                            final isLoading = orderState is OrderLoading;

                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: isLoading
                                    ? null
                                    : () {
                                        final authState = context.read<AuthBloc>().state;
                                        if (authState is! Authenticated) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Please log in first!')),
                                          );
                                          return;
                                        }

                                        final order = OrderEntity(
                                          id: '',
                                          customerId: authState.user.id,
                                          customerName: authState.user.name,
                                          items: state.items
                                              .map((item) => OrderItemEntity(
                                                    id: item.menuItem.id,
                                                    name: item.menuItem.name,
                                                    price: item.menuItem.price,
                                                    quantity: item.quantity,
                                                  ))
                                              .toList(),
                                          totalPrice: state.totalAmount,
                                          status: 'pending',
                                          statusHistory: [
                                            OrderStatusHistory(
                                              status: 'pending',
                                              timestamp: DateTime.now(),
                                            ),
                                          ],
                                          estimatedTime: 30,
                                          createdAt: DateTime.now(),
                                        );

                                        context.read<OrderBloc>().add(PlaceOrderEvent(order));
                                      },
                                child: isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'Proceed to Checkout 🚀',
                                        style: TextStyle(fontSize: 16),
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}