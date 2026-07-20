import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import 'presentation/controllers/order_details_controller.dart';
import 'data/models/order_model.dart';
import 'domain/entities/order_status.dart';

class TrackOrderScreen extends ConsumerWidget {
  final String orderId;

  const TrackOrderScreen({super.key, required this.orderId});

  int _getStatusIndex(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
      case OrderStatus.accepted:
        return 1;
      case OrderStatus.preparing:
        return 2;
      case OrderStatus.ready:
      case OrderStatus.readyForPickup:
        return 3;
      case OrderStatus.outForDelivery:
      case OrderStatus.delivering:
        return 4;
      case OrderStatus.delivered:
        return 5;
      case OrderStatus.cancelled:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final orderAsync = ref.watch(orderDetailsControllerProvider(orderId));

    return Scaffold(
      body: orderAsync.when(
        data: (order) {
          final activeIndex = _getStatusIndex(order.status);
          final isCancelled = order.status == OrderStatus.cancelled;

          final steps = [
            _TrackingStep(
              title: 'Order Pending',
              subtitle: 'Order received by system',
              isCompleted: activeIndex >= 0 && !isCancelled,
              isActive: activeIndex == 0 && !isCancelled,
              icon: Icons.check,
            ),
            _TrackingStep(
              title: 'Order Confirmed',
              subtitle: 'Restaurant accepted your order',
              isCompleted: activeIndex >= 1 && !isCancelled,
              isActive: activeIndex == 1 && !isCancelled,
              icon: Icons.check,
            ),
            _TrackingStep(
              title: 'Preparing',
              subtitle: 'Your food is being made with care',
              isCompleted: activeIndex >= 2 && !isCancelled,
              isActive: activeIndex == 2 && !isCancelled,
              icon: Icons.soup_kitchen,
            ),
            _TrackingStep(
              title: isCancelled
                  ? 'Order Cancelled'
                  : (activeIndex == 5
                      ? 'Delivered'
                      : (activeIndex == 4 ? 'Out for Delivery' : 'Ready for Pickup')),
              subtitle: isCancelled
                  ? 'Your order has been cancelled.'
                  : (activeIndex == 5
                      ? 'Enjoy your meal!'
                      : (activeIndex == 4
                          ? 'Driver is heading to you'
                          : 'Waiting for delivery partner')),
              isCompleted: isCancelled || activeIndex >= 3,
              isActive: isCancelled || (activeIndex >= 3 && activeIndex <= 5),
              icon: isCancelled
                  ? Icons.cancel
                  : (activeIndex == 5 ? Icons.done_all : Icons.local_mall),
              isLast: true,
            ),
          ];

          return Stack(
            children: [
              // Simulated Map Background
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.45,
                child: Container(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Opacity(
                        opacity: 0.1,
                        child: Image.network(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuC949o5b2i1hUPhkcx3-_oSYmcjKxqD0DyQnnr2lB0EcCsU_dKjWCHg-X44aTmbOarkd2a8a0OZIIzaAyXbBKyr7TZyJMl-J1NU_CmZQnpVTK0ZzVFgNEEX09tKOWLCYQUuYAhLQ-HcEnEFXOAseqGkBBMWOGu6EWNTAK6zqXQ62fg-K7sHydaBHzCeuqHleMCeestj5WkiWMejyCcdK5yFAWzt3c8o56eyGBpb4Q1NM7o8PoFv_-7ob3yyiCV9uKOoCPzMcflUIBUa',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isCancelled
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: (isCancelled
                                      ? theme.colorScheme.error
                                      : theme.colorScheme.primary)
                                  .withOpacity(0.4),
                              blurRadius: 20,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: Icon(
                          isCancelled ? Icons.close : Icons.directions_car,
                          color: theme.colorScheme.onPrimary,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              
              // AppBar (Transparent)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AppBar(
                  backgroundColor: theme.colorScheme.surface.withOpacity(0.9),
                  elevation: 0,
                  leading: BackButton(
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go('/home');
                      }
                    },
                  ),
                  title: Text('Track Order #${order.id.substring(0, 5)}',
                      style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18)),
                  centerTitle: true,
                ),
              ),
              
              // Bottom Sheet
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).size.height * 0.6,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 30,
                        offset: const Offset(0, -8),
                      )
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: 48,
                        height: 6,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Text('ORDER STATUS',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            letterSpacing: 1.2,
                          )),
                      const SizedBox(height: 8),
                      Text(
                        isCancelled
                            ? 'Cancelled'
                            : (order.status == OrderStatus.delivered
                                ? 'Delivered'
                                : 'In Progress'),
                        style: theme.textTheme.displayMedium?.copyWith(
                          color: isCancelled
                              ? theme.colorScheme.error
                              : theme.colorScheme.primary,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isCancelled
                            ? 'This order is no longer active.'
                            : 'Updates occur automatically.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), child: Divider()),
                      
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                          children: steps,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
        },
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (err, _) => Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: () => context.go('/home')),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Failed to load order status: $err',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.error),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TrackingStep extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isActive;
  final IconData icon;
  final bool isLast;

  const _TrackingStep({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isActive,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? theme.colorScheme.primary
                        : (isCompleted ? theme.colorScheme.secondary : theme.colorScheme.surfaceVariant),
                  ),
                  child: Icon(icon,
                      size: 14,
                      color: isActive
                          ? theme.colorScheme.onPrimary
                          : (isCompleted
                              ? theme.colorScheme.onSecondary
                              : theme.colorScheme.onSurfaceVariant)),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted
                          ? theme.colorScheme.secondary
                          : theme.colorScheme.surfaceVariant,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isActive
                          ? theme.colorScheme.primary
                          : (isCompleted ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant),
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isActive ? theme.colorScheme.onSurface : theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
