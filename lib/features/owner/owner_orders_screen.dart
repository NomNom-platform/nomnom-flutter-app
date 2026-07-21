import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../order/data/models/order_model.dart';
import '../order/domain/entities/order_status.dart';
import '../order/presentation/controllers/owner_orders_controller.dart';

const _statusFlow = ['PENDING', 'CONFIRMED', 'READY', 'DELIVERED'];

class OwnerOrdersScreen extends ConsumerStatefulWidget {
  const OwnerOrdersScreen({super.key});

  @override
  ConsumerState<OwnerOrdersScreen> createState() => _OwnerOrdersScreenState();
}

class _OwnerOrdersScreenState extends ConsumerState<OwnerOrdersScreen> {
  bool _updatingId = false;
  String _updatingOrderId = '';

  Future<void> _advanceStatus(OrderModel order) async {
    final statusStr = order.status.name.toUpperCase();
    final currentIndex = _statusFlow.indexOf(statusStr);
    if (currentIndex == -1 || currentIndex >= _statusFlow.length - 1) return;

    final nextStatus = _statusFlow[currentIndex + 1];
    
    setState(() {
      _updatingId = true;
      _updatingOrderId = order.id;
    });

    final success = await ref
        .read(ownerOrdersControllerProvider.notifier)
        .updateStatus(order.id, nextStatus);

    if (mounted) {
      setState(() {
        _updatingId = false;
        _updatingOrderId = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Status updated to $nextStatus' : 'Failed to update status'),
        ),
      );
    }
  }

  Future<void> _rejectOrder(OrderModel order) async {
    setState(() {
      _updatingId = true;
      _updatingOrderId = order.id;
    });

    final success = await ref
        .read(ownerOrdersControllerProvider.notifier)
        .updateStatus(order.id, 'CANCELLED');

    if (mounted) {
      setState(() {
        _updatingId = false;
        _updatingOrderId = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Order rejected (Cancelled)' : 'Failed to reject order'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ordersAsync = ref.watch(ownerOrdersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/owner/dashboard');
            }
          },
        ),
        title: Text('Incoming Orders', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
        backgroundColor: theme.colorScheme.surface,
        centerTitle: false,
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
                  Text('New orders will appear here.', style: theme.textTheme.bodyMedium),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final order = orders[index];
              final statusStr = order.status.name.toUpperCase();
              final isFinal = statusStr == 'DELIVERED' || statusStr == 'CANCELLED';
              final currentIndex = _statusFlow.indexOf(statusStr);
              final hasNext = currentIndex != -1 && currentIndex < _statusFlow.length - 1;
              final nextStatus = hasNext ? _statusFlow[currentIndex + 1] : '';

              final isCardUpdating = _updatingId && _updatingOrderId == order.id;

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order #${order.id.substring(0, 5)} • Cust: ${order.customerId.substring(0, 5)}',
                          style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            statusStr,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${order.createdAt?.split('T').first ?? 'Today'} • ${order.totalAmount.toStringAsFixed(0)}đ',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    if (order.items.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        order.items.map((i) => '${i.name} x${i.quantity}').join(', '),
                        style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (isCardUpdating)
                      const Center(child: CircularProgressIndicator())
                    else
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isFinal || !hasNext ? null : () => _advanceStatus(order),
                              child: Text(isFinal
                                  ? 'Completed'
                                  : 'Mark as $nextStatus'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton(
                            onPressed: statusStr == 'PENDING' ? () => _rejectOrder(order) : null,
                            style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.error),
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Failed to load restaurant orders: $err',
              textAlign: TextAlign.center,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ),
      ),
    );
  }
}
