import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import 'presentation/controllers/order_controller.dart';
import 'presentation/controllers/cart_controller_reorder.dart';
import 'data/models/order_model.dart';
import 'domain/entities/order_status.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'Đơn hàng của tôi',
          style: theme.textTheme.headlineMedium
              ?.copyWith(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        backgroundColor: theme.colorScheme.surface,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: theme.textTheme.labelMedium
              ?.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: theme.textTheme.labelMedium,
          tabs: const [
            Tab(text: 'Tất cả'),
            Tab(text: 'Đang xử lý'),
            Tab(text: 'Hoàn thành'),
            Tab(text: 'Đã hủy'),
          ],
        ),
      ),
      body: ordersAsync.when(
        data: (pageResponse) {
          final allOrders = pageResponse.content;

          return TabBarView(
            controller: _tabController,
            children: [
              _OrderList(
                orders: allOrders,
                filter: null,
                onRefresh: () => ref.refresh(orderControllerProvider.future),
              ),
              _OrderList(
                orders: allOrders,
                filter: 'active',
                onRefresh: () => ref.refresh(orderControllerProvider.future),
              ),
              _OrderList(
                orders: allOrders,
                filter: 'completed',
                onRefresh: () => ref.refresh(orderControllerProvider.future),
              ),
              _OrderList(
                orders: allOrders,
                filter: 'cancelled',
                onRefresh: () => ref.refresh(orderControllerProvider.future),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => RefreshIndicator(
          onRefresh: () => ref.refresh(orderControllerProvider.future),
          child: ListView(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.wifi_off_rounded,
                            size: 48,
                            color: theme.colorScheme.onSurfaceVariant
                                .withOpacity(0.4)),
                        const SizedBox(height: 16),
                        Text(
                          'Không tải được đơn hàng',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Kéo xuống để thử lại',
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filtered list widget với pull-to-refresh
// ---------------------------------------------------------------------------
class _OrderList extends ConsumerWidget {
  final List<OrderModel> orders;
  final String? filter; // null=all, 'active', 'completed', 'cancelled'
  final Future<void> Function() onRefresh;

  const _OrderList({
    required this.orders,
    required this.filter,
    required this.onRefresh,
  });

  List<OrderModel> _filtered(List<OrderModel> all) {
    switch (filter) {
      case 'active':
        return all
            .where((o) => ![
                  OrderStatus.delivered,
                  OrderStatus.cancelled,
                ].contains(o.status))
            .toList();
      case 'completed':
        return all
            .where((o) => o.status == OrderStatus.delivered)
            .toList();
      case 'cancelled':
        return all
            .where((o) => o.status == OrderStatus.cancelled)
            .toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtered = _filtered(orders);

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: filtered.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: _EmptyState(filter: filter),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final order = filtered[index];
                return _OrderHistoryCard(
                  order: order,
                  onTap: () => context.push('/track-order/${order.id}'),
                  onReorder: order.status == OrderStatus.delivered
                      ? () => _handleReorder(context, ref, order)
                      : null,
                );
              },
            ),
    );
  }

  Future<void> _handleReorder(
      BuildContext context, WidgetRef ref, OrderModel order) async {
    if (order.items.isEmpty) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đặt lại đơn hàng?'),
        content: Text(
          'Thêm ${order.items.length} món vào giỏ hàng? Giỏ hàng hiện tại sẽ bị thay thế nếu khác nhà hàng.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Không'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Đặt lại'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      // Thực thi reorder thông qua CartController
      try {
        await ref
            .read(reorderControllerProvider.notifier)
            .reorder(order);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Đã thêm vào giỏ hàng! 🛒'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              action: SnackBarAction(
                label: 'Xem giỏ',
                onPressed: () => context.go('/cart'),
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Không thể đặt lại: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Empty state widget
// ---------------------------------------------------------------------------
class _EmptyState extends StatelessWidget {
  final String? filter;
  const _EmptyState({this.filter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = switch (filter) {
      'active' => Icons.hourglass_empty_rounded,
      'completed' => Icons.task_alt_rounded,
      'cancelled' => Icons.cancel_outlined,
      _ => Icons.receipt_long_outlined,
    };
    final label = switch (filter) {
      'active' => 'Không có đơn đang xử lý',
      'completed' => 'Chưa có đơn hoàn thành',
      'cancelled' => 'Không có đơn đã hủy',
      _ => 'Bạn chưa có đơn hàng nào',
    };
    final sub = switch (filter) {
      'active' => 'Các đơn đang giao sẽ hiển thị tại đây',
      'completed' => 'Đơn giao thành công sẽ xuất hiện ở đây',
      'cancelled' => 'Đơn bị hủy sẽ xuất hiện ở đây',
      _ => 'Hãy đặt món đầu tiên của bạn!',
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(icon,
              size: 48, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
        ),
        const SizedBox(height: 16),
        Text(label,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(sub,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Order card
// ---------------------------------------------------------------------------
class _OrderHistoryCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  final VoidCallback? onReorder;

  const _OrderHistoryCard({
    required this.order,
    required this.onTap,
    this.onReorder,
  });

  Color _statusColor(ThemeData theme) {
    switch (order.status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
      case OrderStatus.accepted:
      case OrderStatus.preparing:
      case OrderStatus.ready:
      case OrderStatus.readyForPickup:
        return theme.colorScheme.primary;
      case OrderStatus.outForDelivery:
      case OrderStatus.delivering:
      case OrderStatus.shipping:
        return const Color(0xFF7C3AED); // violet
      case OrderStatus.delivered:
        return const Color(0xFF059669); // emerald
      case OrderStatus.cancelled:
        return theme.colorScheme.error;
    }
  }

  String _statusLabel() {
    switch (order.status) {
      case OrderStatus.pending:
        return 'Chờ xác nhận';
      case OrderStatus.confirmed:
      case OrderStatus.accepted:
        return 'Đã xác nhận';
      case OrderStatus.preparing:
        return 'Đang chế biến';
      case OrderStatus.ready:
      case OrderStatus.readyForPickup:
        return 'Sẵn sàng giao';
      case OrderStatus.outForDelivery:
      case OrderStatus.delivering:
      case OrderStatus.shipping:
        return 'Đang giao 🛵';
      case OrderStatus.delivered:
        return 'Đã giao ✓';
      case OrderStatus.cancelled:
        return 'Đã hủy';
    }
  }

  IconData _paymentIcon() {
    // Heuristic: nếu app không lưu paymentMethod trong OrderModel,
    // hiển thị icon mặc định; sẵn sàng mở rộng khi backend thêm field
    return Icons.payments_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _statusColor(theme);
    final statusText = _statusLabel();

    final itemCount =
        order.items.fold(0, (sum, item) => sum + item.quantity);

    // Tên hiển thị: dùng restaurantId (ngắn gọn) vì model không có restaurantName.
    // Hiển thị "#ID" như Web Frontend. Khi backend thêm restaurantName thì update tại đây.
    final restaurantLabel =
        'Đơn hàng #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}';

    final itemSummary = order.items.isNotEmpty
        ? order.items
            .take(2)
            .map((i) => '${i.quantity}× ${i.name}')
            .join(', ')
        : 'Không có món';
    final hasMore = order.items.length > 2;

    final imageUrl = order.items.isNotEmpty
        ? AppConstants.mockFood1
        : AppConstants.mockPizza;

    final isActive = ![OrderStatus.delivered, OrderStatus.cancelled]
        .contains(order.status);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: isActive
              ? Border.all(
                  color: statusColor.withOpacity(0.25), width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header row ──────────────────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.restaurant_rounded,
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + status badge
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                restaurantLabel,
                                style: theme.textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusText,
                                style: theme.textTheme.bodySmall?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Item summary
                        Text(
                          hasMore
                              ? '$itemSummary và ${order.items.length - 2} món khác'
                              : itemSummary,
                          style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        // Date + count
                        Row(
                          children: [
                            Icon(Icons.access_time_rounded,
                                size: 12,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withOpacity(0.6)),
                            const SizedBox(width: 4),
                            Text(
                              order.createdAt != null &&
                                      order.createdAt!.isNotEmpty
                                  ? order.createdAt!
                                      .split('T')
                                      .first
                                  : 'N/A',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withOpacity(0.6),
                                  fontSize: 11),
                            ),
                            const SizedBox(width: 10),
                            Icon(Icons.dining_rounded,
                                size: 12,
                                color: theme.colorScheme.onSurfaceVariant
                                    .withOpacity(0.6)),
                            const SizedBox(width: 4),
                            Text(
                              '$itemCount món',
                              style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withOpacity(0.6),
                                  fontSize: 11),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Divider ─────────────────────────────────────────────────
            Divider(
              height: 1,
              indent: 12,
              endIndent: 12,
              color: theme.colorScheme.outlineVariant.withOpacity(0.4),
            ),

            // ── Footer: price + actions ──────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(_paymentIcon(),
                          size: 14,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.6)),
                      const SizedBox(width: 6),
                      Text(
                        formatPrice(order.totalAmount),
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      // Reorder button (chỉ hiển thị khi delivered)
                      if (onReorder != null) ...[
                        OutlinedButton.icon(
                          onPressed: onReorder,
                          icon: const Icon(Icons.refresh_rounded, size: 14),
                          label: const Text('Đặt lại',
                              style: TextStyle(fontSize: 12)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            side: BorderSide(
                                color: theme.colorScheme.primary
                                    .withOpacity(0.5)),
                            foregroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      // Track button (khi đang active)
                      if (isActive)
                        FilledButton.icon(
                          onPressed: onTap,
                          icon: const Icon(Icons.location_on_rounded,
                              size: 14),
                          label: const Text('Theo dõi',
                              style: TextStyle(fontSize: 12)),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        )
                      else
                        Icon(
                          Icons.chevron_right_rounded,
                          color: theme.colorScheme.onSurfaceVariant
                              .withOpacity(0.4),
                        ),
                    ],
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
