import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../auth/presentation/controllers/auth_controller.dart';
import '../order/data/models/order_model.dart';
import '../order/domain/entities/order_status.dart';
import '../order/presentation/controllers/owner_orders_controller.dart';
import '../restaurant/presentation/controllers/restaurant_controller.dart';
import '../restaurant/domain/entities/restaurant.dart';
import '../../shared/widgets/user_avatar.dart';

class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen> {
  bool _updatingId = false;
  String _updatingOrderId = '';
  final List<String> _statusFlow = const ['PENDING', 'CONFIRMED', 'READY', 'DELIVERED'];

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
    final restaurantAsync = ref.watch(restaurantControllerProvider);
    final ordersAsync = ref.watch(ownerOrdersControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildTopAppBar(),
      body: restaurantAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _buildError(err.toString()),
        data: (restaurant) {
          if (restaurant == null) {
            return _buildNoRestaurant();
          }
          return ordersAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => _buildError(err.toString()),
            data: (pageResponse) {
              final orders = pageResponse.content;
              return _buildDashboardContent(restaurant, orders);
            },
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Exporting report data...')),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.ios_share, color: AppColors.onPrimary),
      ),
    );
  }

  Widget _buildDashboardContent(Restaurant restaurant, List<OrderModel> orders) {
    double totalRevenue = 0;
    int completedOrdersCount = 0;
    int activeOrdersCount = 0;

    for (var order in orders) {
      if (order.status == OrderStatus.delivered) {
        totalRevenue += order.totalAmount;
        completedOrdersCount++;
      } else if (order.status == OrderStatus.pending ||
                 order.status == OrderStatus.confirmed ||
                 order.status == OrderStatus.ready) {
        activeOrdersCount++;
      }
    }

    final totalOrders = orders.length;
    final completionRate = totalOrders > 0 
        ? '${(completedOrdersCount / totalOrders * 100).toStringAsFixed(0)}%' 
        : '100%';
    final avgOrderValue = completedOrdersCount > 0 ? totalRevenue / completedOrdersCount : 0.0;

    final last7DaysRevenue = _getLast7DaysRevenue(orders);
    final topSellingDishes = _calculateTopSellingDishes(orders);
    final activeOrdersList = orders.where((o) => 
      o.status == OrderStatus.pending || 
      o.status == OrderStatus.confirmed || 
      o.status == OrderStatus.ready
    ).toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 768;
        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        
        return SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(),
              const SizedBox(height: 32),
              _buildKPIBentoGrid(
                isDesktop: isDesktop,
                totalRevenue: totalRevenue,
                totalOrders: totalOrders,
                completionRate: completionRate,
                avgOrderValue: avgOrderValue,
              ),
              const SizedBox(height: 32),
              _buildMainContentArea(
                isDesktop: isDesktop || isLandscape,
                last7DaysRevenue: last7DaysRevenue,
                activeOrders: activeOrdersList,
              ),
              const SizedBox(height: 32),
              _buildTopSellingSection(topSellingDishes),
              const SizedBox(height: 32),
              _buildSystemStatusFooter(isDesktop),
            ],
          ),
        );
      },
    );
  }

  List<DailyRevenue> _getLast7DaysRevenue(List<OrderModel> orders) {
    final now = DateTime.now();
    final last7Days = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      return DateTime(date.year, date.month, date.day);
    });

    final Map<DateTime, double> revenueMap = {
      for (var day in last7Days) day: 0.0,
    };

    for (var order in orders) {
      if (order.status != OrderStatus.delivered || order.createdAt == null) continue;
      try {
        final parsedDate = DateTime.parse(order.createdAt!);
        final orderDay = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
        if (revenueMap.containsKey(orderDay)) {
          revenueMap[orderDay] = revenueMap[orderDay]! + order.totalAmount;
        }
      } catch (_) {}
    }

    return last7Days.map((day) => DailyRevenue(day, revenueMap[day] ?? 0.0)).toList();
  }

  List<TopSellingDish> _calculateTopSellingDishes(List<OrderModel> orders) {
    final Map<String, _DishStats> stats = {};
    for (var order in orders) {
      if (order.status == OrderStatus.cancelled) continue;
      for (var item in order.items) {
        final name = item.name;
        final qty = item.quantity;
        final rev = item.quantity * item.unitPrice;
        if (stats.containsKey(name)) {
          stats[name]!.quantity += qty;
          stats[name]!.revenue += rev;
        } else {
          stats[name] = _DishStats(quantity: qty, revenue: rev);
        }
      }
    }

    final list = stats.entries.map((e) => TopSellingDish(
      name: e.key,
      quantity: e.value.quantity,
      revenue: e.value.revenue,
    )).toList();

    list.sort((a, b) => b.quantity.compareTo(a.quantity));
    return list.take(5).toList();
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildNoRestaurant() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.storefront_outlined, size: 64, color: AppColors.outline),
            const SizedBox(height: 16),
            const Text(
              'You have no restaurant yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create your restaurant profile before viewing the dashboard.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/owner/settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
              child: const Text('Go to settings'),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopAppBar() {
    final authState = ref.watch(authControllerProvider);
    final restaurantAsync = ref.watch(restaurantControllerProvider);
    final restaurant = restaurantAsync.valueOrNull;
    final statusLabel = restaurant?.status == 'APPROVED'
        ? 'Status: Open'
        : restaurant?.status == 'PENDING'
            ? 'Status: Pending'
            : restaurant?.status == 'SUSPENDED'
                ? 'Status: Suspended'
                : restaurant?.status == 'REJECTED'
                    ? 'Status: Rejected'
                    : 'Không có quán';
    final statusColor = restaurant?.status == 'APPROVED'
        ? AppColors.secondaryContainer
        : restaurant?.status == 'PENDING'
            ? Colors.orange.shade100
            : Colors.red.shade100;
    final statusTextColor = restaurant?.status == 'APPROVED'
        ? AppColors.onSecondaryContainer
        : restaurant?.status == 'PENDING'
            ? Colors.orange.shade800
            : Colors.red.shade800;

    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: const Icon(Icons.restaurant, color: AppColors.primary, size: 28),
      title: const Text(
        'NomNom',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      actions: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            statusLabel,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.05,
              color: statusTextColor,
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.onSurfaceVariant,
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          color: AppColors.onSurfaceVariant,
          tooltip: 'Logout',
          onPressed: _confirmLogout,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: UserAvatar(
            radius: 16,
            fallbackName: authState.profile?.fullName,
          ),
        ),
      ],
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onError,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(authControllerProvider.notifier).logout();
    if (mounted) context.go('/login');
  }

  Widget _buildWelcomeHeader() {
    final profile = ref.watch(authControllerProvider).profile;
    final firstName = profile?.fullName.split(' ').last ?? 'Chế';
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Chào buổi sáng' : hour < 18 ? 'Chào buổi chiều' : 'Chào buổi tối';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, $firstName 👋',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: AppColors.onSurfaceVariant,
            ),
            children: [
              TextSpan(text: 'Welcome back to your dashboard. Stay on top of your live metrics.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKPIBentoGrid({
    required bool isDesktop,
    required double totalRevenue,
    required int totalOrders,
    required String completionRate,
    required double avgOrderValue,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = isDesktop ? 3 : 1;
        
        return GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: isDesktop ? 1.5 : 1.3,
          ),
          children: [
            _KPICard(
              label: 'Total Revenue',
              value: formatPrice(totalRevenue),
              icon: Icons.payments,
              iconColor: AppColors.primary,
              iconBgColor: AppColors.primaryFixed,
              growth: '+12.4%',
              growthColor: AppColors.secondary,
            ),
            _KPICard(
              label: 'Total Orders',
              value: totalOrders.toString(),
              icon: Icons.shopping_bag,
              iconColor: AppColors.onSecondaryContainer,
              iconBgColor: AppColors.secondaryContainer,
              growth: completionRate,
              growthColor: AppColors.secondary,
            ),
            _KPICard(
              label: 'Average Order Value',
              value: formatPrice(avgOrderValue),
              icon: Icons.analytics,
              iconColor: AppColors.tertiary,
              iconBgColor: AppColors.tertiaryFixed,
              growth: 'AOV',
              growthColor: AppColors.tertiary,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainContentArea({
    required bool isDesktop,
    required List<DailyRevenue> last7DaysRevenue,
    required List<OrderModel> activeOrders,
  }) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: _RevenueTrendsChart(data: last7DaysRevenue),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: _LiveOrdersList(
              orders: activeOrders,
              onAdvanceStatus: _advanceStatus,
              onRejectOrder: _rejectOrder,
              updatingOrderId: _updatingOrderId,
              isUpdating: _updatingId,
            ),
          ),
        ],
      );
    }
    
    return Column(
      children: [
        _RevenueTrendsChart(data: last7DaysRevenue),
        const SizedBox(height: 16),
        _LiveOrdersList(
          orders: activeOrders,
          onAdvanceStatus: _advanceStatus,
          onRejectOrder: _rejectOrder,
          updatingOrderId: _updatingOrderId,
          isUpdating: _updatingId,
        ),
      ],
    );
  }

  Widget _buildTopSellingSection(List<TopSellingDish> topSellingDishes) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Selling Dishes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          _TopSellingTable(items: topSellingDishes),
        ],
      ),
    );
  }

  Widget _buildSystemStatusFooter(bool isDesktop) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.surfaceVariant),
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _StatusIndicator('System Online', AppColors.secondary),
                      const SizedBox(width: 24),
                      _StatusIndicator('Printer Connected', AppColors.secondary),
                      const SizedBox(width: 24),
                      Text(
                        'Last sync: 2 mins ago',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  if (isDesktop)
                    Row(
                      children: [
                        _FooterButton('Support'),
                        const SizedBox(width: 12),
                        _FooterButton('Documentation'),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
        if (!isDesktop) const SizedBox(height: 80),
      ],
    );
  }

  Widget _StatusIndicator(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _FooterButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.onSurface,
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard, 'Dashboard', true),
          _buildNavItem(Icons.menu_book, 'Menu', false),
          _buildNavItem(Icons.receipt_long, 'Orders', false),
          _buildNavItem(Icons.analytics, 'Analytics', false),
          _buildNavItem(Icons.settings, 'Settings', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {
        if (label == 'Menu') {
          context.go('/owner/menu');
        } else if (label == 'Orders') {
          context.go('/owner/orders');
        } else if (label == 'Settings') {
          context.go('/owner/settings');
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.05,
                color: isActive ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DailyRevenue {
  final DateTime date;
  final double amount;
  DailyRevenue(this.date, this.amount);
}

class TopSellingDish {
  final String name;
  final int quantity;
  final double revenue;
  TopSellingDish({
    required this.name,
    required this.quantity,
    required this.revenue,
  });
}

class _DishStats {
  int quantity;
  double revenue;
  _DishStats({required this.quantity, required this.revenue});
}

class _KPICard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String growth;
  final Color growthColor;

  const _KPICard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.growth,
    required this.growthColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: growthColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (growth.startsWith('+') || growth.startsWith('-'))
                      Icon(
                        growth.startsWith('+') ? Icons.trending_up : Icons.trending_down,
                        size: 14,
                        color: growthColor,
                      ),
                    const SizedBox(width: 2),
                    Text(
                      growth,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: growthColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurfaceVariant.withOpacity(0.7),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RevenueTrendsChart extends StatelessWidget {
  final List<DailyRevenue> data;
  const _RevenueTrendsChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final totalWeekRevenue = data.fold<double>(0.0, (sum, item) => sum + item.amount);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Revenue Trends',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Total this week: ${formatPrice(totalWeekRevenue)}',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.onSurfaceVariant.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  _LegendItem('Revenue', AppColors.primary),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: CustomPaint(
              painter: _RevenueChartPainter(data),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _LegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _RevenueChartPainter extends CustomPainter {
  final List<DailyRevenue> data;
  _RevenueChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double maxAmount = data.map((d) => d.amount).reduce(math.max);
    final double limitMax = maxAmount == 0 ? 1000.0 : maxAmount;

    final gridPaint = Paint()
      ..color = AppColors.outlineVariant.withOpacity(0.2)
      ..strokeWidth = 1;

    for (int i = 0; i <= 4; i++) {
      final y = size.height * 0.1 + (size.height * 0.7) * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final double stepX = size.width / (data.length - 1);
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final y = size.height * 0.8 - (data[i].amount / limitMax) * (size.height * 0.65);
      points.add(Offset(x, y));
    }

    final fillPath = Path();
    fillPath.moveTo(0, size.height * 0.8);
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        fillPath.lineTo(points[i].dx, points[i].dy);
      } else {
        final prev = points[i - 1];
        final curr = points[i];
        fillPath.cubicTo(
          prev.dx + stepX / 2, prev.dy,
          curr.dx - stepX / 2, curr.dy,
          curr.dx, curr.dy,
        );
      }
    }
    fillPath.lineTo(size.width, size.height * 0.8);
    fillPath.close();

    final fillGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        AppColors.primary.withOpacity(0.35),
        AppColors.primary.withOpacity(0.0),
      ],
    );
    final fillPaint = Paint()
      ..shader = fillGradient.createShader(
        Rect.fromLTRB(0, 0, size.width, size.height * 0.8),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    final linePath = Path();
    for (int i = 0; i < points.length; i++) {
      if (i == 0) {
        linePath.moveTo(points[i].dx, points[i].dy);
      } else {
        final prev = points[i - 1];
        final curr = points[i];
        linePath.cubicTo(
          prev.dx + stepX / 2, prev.dy,
          curr.dx - stepX / 2, curr.dy,
          curr.dx, curr.dy,
        );
      }
    }

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final borderPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var pt in points) {
      canvas.drawCircle(pt, 5, dotPaint);
      canvas.drawCircle(pt, 5, borderPaint);
    }

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    final weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for (int i = 0; i < data.length; i++) {
      final dayName = weekdayNames[data[i].date.weekday - 1];
      textPainter.text = TextSpan(
        text: dayName,
        style: TextStyle(
          color: AppColors.onSurfaceVariant.withOpacity(0.7),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      );
      textPainter.layout();
      final x = i * stepX - (textPainter.width / 2);
      final y = size.height * 0.88;
      textPainter.paint(canvas, Offset(math.max(0.0, math.min(x, size.width - textPainter.width)), y));
    }
  }

  @override
  bool shouldRepaint(covariant _RevenueChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }
}

class _LiveOrdersList extends StatelessWidget {
  final List<OrderModel> orders;
  final Function(OrderModel) onAdvanceStatus;
  final Function(OrderModel) onRejectOrder;
  final String updatingOrderId;
  final bool isUpdating;

  const _LiveOrdersList({
    required this.orders,
    required this.onAdvanceStatus,
    required this.onRejectOrder,
    required this.updatingOrderId,
    required this.isUpdating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Live Orders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              if (orders.isNotEmpty)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          if (orders.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle_outline, size: 48, color: AppColors.secondary.withOpacity(0.6)),
                    const SizedBox(height: 12),
                    const Text(
                      'No active orders',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                final isCardUpdating = isUpdating && updatingOrderId == order.id;
                return _OrderItemCard(
                  order: order,
                  isUpdating: isCardUpdating,
                  onAdvance: () => onAdvanceStatus(order),
                  onReject: () => onRejectOrder(order),
                );
              },
            ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/owner/orders'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.outlineVariant),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'View All Orders',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemCard extends StatelessWidget {
  final OrderModel order;
  final bool isUpdating;
  final VoidCallback onAdvance;
  final VoidCallback onReject;

  const _OrderItemCard({
    required this.order,
    required this.isUpdating,
    required this.onAdvance,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final statusStr = order.status.name.toUpperCase();
    final itemsText = order.items.map((i) => '${i.name} x${i.quantity}').join(', ');
    final amountText = formatPrice(order.totalAmount);

    Color borderLeftColor;
    Color statusBgColor;
    Color statusTextColor;
    String actionLabel = '';

    switch (statusStr) {
      case 'PENDING':
        borderLeftColor = AppColors.primary;
        statusBgColor = AppColors.primaryContainer.withValues(alpha: 0.3);
        statusTextColor = AppColors.primary;
        actionLabel = 'Accept';
        break;
      case 'CONFIRMED':
        borderLeftColor = AppColors.secondary;
        statusBgColor = AppColors.secondaryContainer.withValues(alpha: 0.3);
        statusTextColor = AppColors.secondary;
        actionLabel = 'Mark Ready';
        break;
      case 'READY':
        borderLeftColor = AppColors.tertiary;
        statusBgColor = AppColors.tertiaryContainer.withValues(alpha: 0.3);
        statusTextColor = AppColors.tertiary;
        actionLabel = 'Complete';
        break;
      default:
        borderLeftColor = AppColors.outlineVariant;
        statusBgColor = AppColors.surfaceVariant;
        statusTextColor = AppColors.onSurfaceVariant;
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border(
          left: BorderSide(color: borderLeftColor, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.substring(0, 5).toUpperCase()}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusStr,
                  style: TextStyle(
                    color: statusTextColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            itemsText,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amountText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              Text(
                order.createdAt?.split('T').first ?? 'Today',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.onSurfaceVariant.withOpacity(0.7),
                ),
              ),
            ],
          ),
          if (actionLabel.isNotEmpty) ...[
            const SizedBox(height: 12),
            if (isUpdating)
              const Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onAdvance,
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: Text(actionLabel, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  if (statusStr == 'PENDING') ...[
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: BorderSide(color: AppColors.error.withOpacity(0.4)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      child: const Text('Reject', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
          ],
        ],
      ),
    );
  }
}

class _TopSellingTable extends StatelessWidget {
  final List<TopSellingDish> items;
  const _TopSellingTable({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0),
        child: Center(
          child: Text(
            'No sales data yet to determine top selling dishes.',
            style: TextStyle(color: AppColors.outline),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        headingRowColor: MaterialStateProperty.all(AppColors.surfaceVariant.withOpacity(0.3)),
        columns: [
          DataColumn(
            label: Text(
              'Dish Name',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.05,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Orders',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.05,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
          DataColumn(
            label: Text(
              'Revenue',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.05,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
        rows: List.generate(items.length, (index) {
          final dish = items[index];
          String rankEmoji = '';
          if (index == 0) rankEmoji = '🥇 ';
          if (index == 1) rankEmoji = '🥈 ';
          if (index == 2) rankEmoji = '🥉 ';

          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '$rankEmoji${dish.name}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
              DataCell(
                Text(
                  dish.quantity.toString(),
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              DataCell(
                Text(
                  formatPrice(dish.revenue),
                  style: const TextStyle(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
