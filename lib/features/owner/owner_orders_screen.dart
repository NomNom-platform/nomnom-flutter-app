import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _OwnerOrder {
  final String id;
  final String customerName;
  final double total;
  final String time;
  String status;

  _OwnerOrder({
    required this.id,
    required this.customerName,
    required this.total,
    required this.time,
    required this.status,
  });
}

const _statusFlow = ['PENDING', 'CONFIRMED', 'PREPARING', 'READY', 'DELIVERING', 'DELIVERED'];

class OwnerOrdersScreen extends StatefulWidget {
  const OwnerOrdersScreen({super.key});

  @override
  State<OwnerOrdersScreen> createState() => _OwnerOrdersScreenState();
}

class _OwnerOrdersScreenState extends State<OwnerOrdersScreen> {
  final List<_OwnerOrder> _orders = [
    _OwnerOrder(id: '#12345', customerName: 'Alex Johnson', total: 110000, time: '12:30 PM', status: 'PENDING'),
    _OwnerOrder(id: '#12346', customerName: 'Minh Tran', total: 78000, time: '12:41 PM', status: 'CONFIRMED'),
    _OwnerOrder(id: '#12340', customerName: 'Lan Pham', total: 65000, time: '11:58 AM', status: 'PREPARING'),
    _OwnerOrder(id: '#12331', customerName: 'David Nguyen', total: 132000, time: '11:20 AM', status: 'READY'),
  ];

  void _advanceStatus(_OwnerOrder order) {
    final currentIndex = _statusFlow.indexOf(order.status);
    if (currentIndex < _statusFlow.length - 1) {
      setState(() => order.status = _statusFlow[currentIndex + 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Incoming Orders', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
        backgroundColor: theme.colorScheme.surface,
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: _orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = _orders[index];
          final isFinal = order.status == 'DELIVERED';
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
                    Text('${order.id} • ${order.customerName}', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(order.status, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('${order.time} • ${order.total.toStringAsFixed(0)}đ', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isFinal ? null : () => _advanceStatus(order),
                        child: Text(isFinal ? 'Completed' : 'Mark as ${_statusFlow[_statusFlow.indexOf(order.status) + 1]}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: order.status == 'PENDING'
                          ? () => setState(() => order.status = 'CANCELLED')
                          : null,
                      style: OutlinedButton.styleFrom(foregroundColor: theme.colorScheme.error),
                      child: const Text('Reject'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
