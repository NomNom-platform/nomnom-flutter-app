import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

class _OrderHistoryItem {
  final String id;
  final String restaurantName;
  final String imageUrl;
  final String status;
  final double total;
  final String date;
  final int itemCount;

  const _OrderHistoryItem({
    required this.id,
    required this.restaurantName,
    required this.imageUrl,
    required this.status,
    required this.total,
    required this.date,
    required this.itemCount,
  });
}

const _mockOrders = [
  _OrderHistoryItem(
    id: '#12345',
    restaurantName: 'Com Tam Suon Nuong',
    imageUrl: AppConstants.mockFood1,
    status: 'Delivering',
    total: 110000,
    date: 'Today, 12:30 PM',
    itemCount: 2,
  ),
  _OrderHistoryItem(
    id: '#12298',
    restaurantName: 'Pizza Corner',
    imageUrl: AppConstants.mockPizza,
    status: 'Delivered',
    total: 245000,
    date: 'Yesterday, 7:12 PM',
    itemCount: 3,
  ),
  _OrderHistoryItem(
    id: '#12190',
    restaurantName: 'Burger House',
    imageUrl: AppConstants.mockBurger,
    status: 'Delivered',
    total: 89000,
    date: 'Jul 5, 1:05 PM',
    itemCount: 1,
  ),
  _OrderHistoryItem(
    id: '#12034',
    restaurantName: 'Green Cafe',
    imageUrl: AppConstants.mockCafe,
    status: 'Cancelled',
    total: 55000,
    date: 'Jun 28, 9:40 AM',
    itemCount: 1,
  ),
];

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Order History', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
        centerTitle: false,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _mockOrders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final order = _mockOrders[index];
          return _OrderHistoryCard(
            order: order,
            onTap: () {
              if (order.status == 'Delivering') {
                context.push('/track-order');
              }
            },
          );
        },
      ),
    );
  }
}

class _OrderHistoryCard extends StatelessWidget {
  final _OrderHistoryItem order;
  final VoidCallback onTap;

  const _OrderHistoryCard({required this.order, required this.onTap});

  Color _statusColor(ThemeData theme) {
    switch (order.status) {
      case 'Delivering':
        return theme.colorScheme.primary;
      case 'Delivered':
        return theme.colorScheme.secondary;
      case 'Cancelled':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(theme);

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
                order.imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
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
                          order.restaurantName,
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
                          order.status,
                          style: theme.textTheme.bodySmall?.copyWith(color: statusColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${order.id} • ${order.itemCount} item(s)',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  Text(
                    order.date,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${order.total.toStringAsFixed(0)}đ',
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
