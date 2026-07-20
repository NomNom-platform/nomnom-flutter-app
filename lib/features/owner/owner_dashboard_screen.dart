import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/colors.dart';
import '../auth/presentation/controllers/auth_controller.dart';

class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 768;
        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildTopAppBar(),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 32 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(),
                const SizedBox(height: 32),
                _buildKPIBentoGrid(isDesktop),
                const SizedBox(height: 32),
                _buildMainContentArea(isDesktop || isLandscape),
                const SizedBox(height: 32),
                _buildTopSellingSection(),
                const SizedBox(height: 32),
                _buildSystemStatusFooter(isDesktop),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNav(),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export data...')),
              );
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.ios_share, color: AppColors.onPrimary),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: const Icon(Icons.restaurant, color: AppColors.primary, size: 28),
      title: Text(
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
            color: AppColors.secondaryContainer,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            'Status: Open',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.05,
              color: AppColors.onSecondaryContainer,
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
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: ClipOval(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuDs1sroiJdRqtzW8fFpjrrkihwBhSiJpRR8M-AyHGpzmsho7udfOoo-2GmAs8qh3luNIaChtQye4K76NX0R7K4KzCj7Bh6293-YB4s_H7X7KpI22fZeIRMmPlGI6p8RoSSY77KiaAd5nikDCMZNmPhJGqqRnlTk08LZ_vvJ1TKM0rrvO1ejK6LSD4i2dS6nmR61ZHRaGSgfhPSad-8qeWFWVSO06n9fJXp_PNBKvg604aBB3mgs8VnFj7BBgN99shCVIHjlgsjgeOo',
              fit: BoxFit.cover,
            ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning, Chef Marco',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: AppColors.onSurfaceVariant,
            ),
            children: [
              const TextSpan(text: 'Your kitchen performance is up '),
              TextSpan(
                text: '12%',
                style: TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: ' from yesterday.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKPIBentoGrid(bool isDesktop) {
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
              value: '\$12,482.00',
              icon: Icons.payments,
              iconColor: AppColors.primary,
              iconBgColor: AppColors.primaryFixed,
              growth: '+8.4%',
              growthColor: AppColors.secondary,
            ),
            _KPICard(
              label: 'Total Orders',
              value: '1,248',
              icon: Icons.shopping_bag,
              iconColor: AppColors.onSecondaryContainer,
              iconBgColor: AppColors.secondaryContainer,
              growth: '+12%',
              growthColor: AppColors.secondary,
            ),
            _KPICard(
              label: 'Average Rating',
              value: '4.8 / 5.0',
              icon: Icons.star_rate,
              iconColor: AppColors.tertiary,
              iconBgColor: AppColors.tertiaryFixed,
              growth: 'No change',
              growthColor: AppColors.onSurfaceVariant,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainContentArea(bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 8,
            child: _RevenueTrendsChart(),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: _LiveOrdersList(),
          ),
        ],
      );
    }
    
    return Column(
      children: [
        _RevenueTrendsChart(),
        const SizedBox(height: 16),
        _LiveOrdersList(),
      ],
    );
  }

  Widget _buildTopSellingSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Top Selling Dishes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      'All Categories',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.expand_more, size: 20, color: AppColors.onSurfaceVariant),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _TopSellingTable(),
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
          style: TextStyle(
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
        style: TextStyle(
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
        } else if (label == 'Analytics') {
          // Analytics page not implemented yet
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
              fill: isActive ? 1 : 0,
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              Row(
                children: [
                  Icon(
                    growth.startsWith('+') ? Icons.trending_up : Icons.remove,
                    size: 16,
                    color: growthColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    growth,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: growthColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.05,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueTrendsChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Revenue Trends',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              Row(
                children: [
                  _LegendItem('Revenue', AppColors.primary),
                  const SizedBox(width: 16),
                  _LegendItem('Target', AppColors.secondary),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            height: 180,
            child: CustomPaint(
              painter: _RevenueChartPainter(),
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _RevenueChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF983C00)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final targetPaint = Paint()
      ..color = const Color(0xFF006B5F).withOpacity(0.5)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.87);
    path.cubicTo(
      size.width * 0.125, size.height * 0.87,
      size.width * 0.25, size.height * 0.33,
      size.width * 0.375, size.height * 0.53,
    );
    path.cubicTo(
      size.width * 0.5, size.height * 0.73,
      size.width * 0.625, size.height * 0.13,
      size.width * 0.75, size.height * 0.47,
    );
    path.cubicTo(
      size.width * 0.875, size.height * 0.8,
      size.width, size.height * 0.2,
      size.width, size.height * 0.2,
    );

    final targetPath = Path();
    targetPath.moveTo(0, size.height * 0.73);
    targetPath.cubicTo(
      size.width * 0.125, size.height * 0.73,
      size.width * 0.25, size.height * 0.6,
      size.width * 0.375, size.height * 0.67,
    );
    targetPath.cubicTo(
      size.width * 0.5, size.height * 0.73,
      size.width * 0.625, size.height * 0.47,
      size.width * 0.75, size.height * 0.6,
    );
    targetPath.cubicTo(
      size.width * 0.875, size.height * 0.73,
      size.width, size.height * 0.53,
      size.width, size.height * 0.53,
    );

    canvas.drawPath(path, paint);
    canvas.drawPath(targetPath, targetPaint);

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final textStyle = TextStyle(
      color: const Color(0xFF584238),
      fontSize: 10,
    );

    for (int i = 0; i < days.length; i++) {
      textPainter.text = TextSpan(text: days[i], style: textStyle);
      textPainter.layout();
      final x = (size.width / 6) * i;
      textPainter.paint(canvas, Offset(x, size.height - 12));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LiveOrdersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Live Orders',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _OrderItem(
            orderId: '#ORD-4921',
            time: 'Now',
            items: '2x Truffle Pasta, 1x Coke',
            deliveryInfo: 'Delivery: 3.2 miles away',
            icon: Icons.local_shipping,
            borderColor: AppColors.primary,
            timeColor: AppColors.primary,
          ),
          const SizedBox(height: 12),
          _OrderItem(
            orderId: '#ORD-4918',
            time: '5 min ago',
            items: '1x Wagyu Burger, Fries',
            deliveryInfo: 'Pickup: Ready in 10 mins',
            icon: Icons.restaurant,
            borderColor: AppColors.secondary,
            timeColor: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          _OrderItem(
            orderId: '#ORD-4912',
            time: '12 min ago',
            items: '4x Margherita Pizza',
            deliveryInfo: 'Delivery: Dispatched',
            icon: Icons.check_circle,
            borderColor: AppColors.outline,
            timeColor: AppColors.onSurfaceVariant,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.go('/owner/orders'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.outline),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
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

class _OrderItem extends StatelessWidget {
  final String orderId;
  final String time;
  final String items;
  final String deliveryInfo;
  final IconData icon;
  final Color borderColor;
  final Color timeColor;

  const _OrderItem({
    required this.orderId,
    required this.time,
    required this.items,
    required this.deliveryInfo,
    required this.icon,
    required this.borderColor,
    required this.timeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          left: BorderSide(color: borderColor, width: 4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                orderId,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: timeColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            items,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, size: 12, color: AppColors.onSurfaceVariant),
              const SizedBox(width: 4),
              Text(
                deliveryInfo,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopSellingTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 16,
        headingRowColor: MaterialStateProperty.all(AppColors.surfaceVariant),
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
          DataColumn(
            label: Text(
              'Rating',
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
              'Growth',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.05,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
        rows: [
          _buildDishRow(
            'Signature Truffle Pasta',
            '482',
            '\$11,568',
            '4.9',
            '+14.2%',
            AppColors.secondary,
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBJH13noGctafI9vOGfL_OD3256YPJi-Yc17hd1KAD2-wwdu5mopF39xYxQj2XuxoZwyxp6ieeeHWkxUIhA0vKs1cE96sSy3g4lkcp31O6Mc119_SxxYyUAHZT1o_7hQVqnYQaZok4LZ5T9TqjmNIaCM02-ocD1hvc_sfLd05wZQHmNGJMFzpwN0zz-dTPLhrM7AeDdZiIM-7G5V4mq3xAWk1uOGlWCHuXpbCopMqbfDykS5dVXNv-dMXn0l6DpGuY4v-G16r6ObZ8',
          ),
          _buildDishRow(
            'Double Wagyu Burger',
            '351',
            '\$8,424',
            '4.7',
            '+9.1%',
            AppColors.secondary,
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCkRfWn8rKM0sKzg0qtRFh2QioEGb2hsduXXwt-X1yMnZ0rzKbWYyksiYkpITWWTny88fk27YE5G6WWov8bAk--6x0s7YZmHEw3fswRSAhtNNKr15KKpc_guZESnk8geSyrZLLmfWy1ioI5_0vI6YybG5MR7mqda3Ny9gdxevo_UnIKSS2BpBo-Yvip8jDgO7RRyXuaqiJzxZZvLj0FrRS0vyaA33AeZc6UysYOTXWpIL-xih1xnAKfPDC8F-hBc6HOZL-iwMRGsrs',
          ),
          _buildDishRow(
            'Classic Margherita Pizza',
            '290',
            '\$4,640',
            '4.8',
            '-2.4%',
            AppColors.error,
            'https://lh3.googleusercontent.com/aida-public/AB6AXuCTfxxK_AFAA9OcOwVF7T9fFE0DICvVEQ5aZ_Xu6YNSrqbi4TYdCI2tA-BPK9OBARSNSotiOXtG9cxrp12YWROzsy68nu6kaOWKNWwwgWCJ7V-jp-cIjzXscmYMWRLKiht7cPJSGApdhkP_YW87p22dhan20YDM-tKjN5uiZd83fb83ZGaBi7yV1fw9QZcGrQBf-qnhCb0QIY237-n2UzBzumNVarFzjtunreXwCDYQKsxRUrIWBwb4xIt1kkQQ6XxvotgC1uBDJ08',
          ),
        ],
      ),
    );
  }

  DataRow _buildDishRow(
    String name,
    String orders,
    String revenue,
    String rating,
    String growth,
    Color growthColor,
    String imageUrl,
  ) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            orders,
            style: TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(
          Text(
            revenue,
            style: TextStyle(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              Icon(Icons.star, size: 16, color: AppColors.tertiary, fill: 1),
              const SizedBox(width: 4),
              Text(
                rating,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        DataCell(
          Text(
            growth,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: growthColor,
            ),
          ),
        ),
      ],
    );
  }
}

