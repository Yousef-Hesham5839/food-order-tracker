import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/status_helper.dart';
import '../../domain/entities/order_entity.dart';
import '../bloc/order_bloc.dart';
import '../bloc/order_event.dart';
import '../bloc/order_state.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderBloc>().add(WatchAllOrdersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Orders Dashboard 🍳'),
        centerTitle: true,
      ),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
          } else if (state is OrderError) {
            return Center(child: Text(state.message, style: const TextStyle(color: AppTheme.secondaryColor)));
          } else if (state is AllOrdersLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('No orders yet! 🍕', style: TextStyle(color: AppTheme.textSecondary)));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              itemBuilder: (context, index) {
                final order = state.orders[index];
                return _buildOrderCard(context, order);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderEntity order) {
    final statusColor = StatusHelper.getColor(order.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.substring(0, 6).toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  StatusHelper.getLabel(order.status),
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Customer: ${order.customerName}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
          const SizedBox(height: 4),
          Text('Items: ${order.items.map((i) => "${i.quantity}x ${i.name}").join(", ")}',
              style: const TextStyle(fontSize: 13)),
          const SizedBox(height: 8),
          Text('Total: ${order.totalPrice.toStringAsFixed(2)} EGP',
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
          const Divider(height: 20, color: AppTheme.cardColor),
          // Actions to update status
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _statusButton(context, order, 'confirmed', 'Accept'),
              _statusButton(context, order, 'preparing', 'Prepare'),
              _statusButton(context, order, 'out_for_delivery', 'Delivery'),
              _statusButton(context, order, 'delivered', 'Delivered'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusButton(BuildContext context, OrderEntity order, String targetStatus, String label) {
    final isSelected = order.status == targetStatus;

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? Colors.white : AppTheme.textSecondary,
        backgroundColor: isSelected ? StatusHelper.getColor(targetStatus) : Colors.transparent,
        side: BorderSide(
          color: isSelected ? Colors.transparent : AppTheme.cardColor,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      onPressed: () {
        context.read<OrderBloc>().add(UpdateOrderStatusEvent(order.id, targetStatus));
      },
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}