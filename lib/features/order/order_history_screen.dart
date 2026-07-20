import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import 'presentation/controllers/order_controller.dart';
import 'data/models/order_model.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final ordersAsync = ref.watch(orderControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/profile');
            }
          },
        ),
        title: Text('Order History', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
        centerTitle: false,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: ordersAsync.when(
        data: (pageResponse) {
          final orders = pageResponse.content;
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No orders yet', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Place your first order now!', style: theme.textTheme.bodyMedium),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final order = orders[index];
              return _OrderHistoryCard(
                order: order,
                onTap: () {
                  // Direct to tracking page for this specific order
                  context.push('/track-order/${order.id}');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Failed to load order history: $err',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const _OrderHistoryCard({required this.order, required this.onTap});

  Color _statusColor(ThemeData theme) {
    switch (order.status.name.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
      case 'accepted':
      case 'preparing':
      case 'ready':
      case 'readyforpickup':
        return theme.colorScheme.primary;
      case 'outfordelivery':
      case 'delivering':
      case 'delivered':
        return theme.colorScheme.secondary;
      case 'cancelled':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _statusLabel() {
    final statusStr = order.status.name.toUpperCase();
    switch (statusStr) {
      case 'PENDING':
        return 'Pending';
      case 'CONFIRMED':
      case 'ACCEPTED':
        return 'Confirmed';
      case 'PREPARING':
        return 'Preparing';
      case 'READY':
      case 'READY_FOR_PICKUP':
        return 'Ready';
      case 'OUT_FOR_DELIVERY':
      case 'DELIVERING':
        return 'Delivering';
      case 'DELIVERED':
        return 'Delivered';
      case 'CANCELLED':
        return 'Cancelled';
      default:
        return statusStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(theme);
    final statusText = _statusLabel();
    
    final itemCount = order.items.fold(0, (sum, item) => sum + item.quantity);
    final restaurantName = order.items.isNotEmpty 
        ? order.items.first.name 
        : 'Order from Restaurant';
    
    // Choose cover mockup based on restaurantId or first item name
    final imageUrl = order.items.isNotEmpty
        ? AppConstants.mockFood1
        : AppConstants.mockPizza;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 64,
                  height: 64,
                  color: theme.colorScheme.surfaceVariant,
                  child: const Icon(Icons.restaurant),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          restaurantName,
                          style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          statusText,
                          style: theme.textTheme.bodySmall?.copyWith(color: statusColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Order #${order.id.substring(0, 5)} • $itemCount item(s)',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  if (order.createdAt != null && order.createdAt!.isNotEmpty)
                    Text(
                      order.createdAt!.split('T').first,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    '${order.totalAmount.toStringAsFixed(0)}đ',
                    style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
