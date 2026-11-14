import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';

class StatusHelper {
  static String getLabel(String status) {
    switch (status) {
      case AppConstants.statusPending:        return 'Order Placed';
      case AppConstants.statusConfirmed:      return 'Confirmed';
      case AppConstants.statusPreparing:      return 'Preparing';
      case AppConstants.statusOutForDelivery: return 'Out for Delivery';
      case AppConstants.statusDelivered:      return 'Delivered';
      case AppConstants.statusCancelled:      return 'Cancelled';
      default: return 'Unknown';
    }
  }

  static IconData getIcon(String status) {
    switch (status) {
      case AppConstants.statusPending:        return Icons.receipt_long;
      case AppConstants.statusConfirmed:      return Icons.check_circle;
      case AppConstants.statusPreparing:      return Icons.local_fire_department;
      case AppConstants.statusOutForDelivery: return Icons.delivery_dining;
      case AppConstants.statusDelivered:      return Icons.home;
      case AppConstants.statusCancelled:      return Icons.cancel;
      default: return Icons.help;
    }
  }

  static Color getColor(String status) {
    switch (status) {
      case AppConstants.statusPending:        return Colors.orange;
      case AppConstants.statusConfirmed:      return Colors.blue;
      case AppConstants.statusPreparing:      return Colors.deepOrange;
      case AppConstants.statusOutForDelivery: return AppTheme.primaryColor;
      case AppConstants.statusDelivered:      return AppTheme.successColor;
      case AppConstants.statusCancelled:      return AppTheme.secondaryColor;
      default: return Colors.grey;
    }
  }

  static List<String> get orderedStatuses => [
    AppConstants.statusPending,
    AppConstants.statusConfirmed,
    AppConstants.statusPreparing,
    AppConstants.statusOutForDelivery,
    AppConstants.statusDelivered,
  ];
}