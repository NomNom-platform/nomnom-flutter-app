import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/currency_formatter.dart';
import 'presentation/controllers/order_details_controller.dart';
import 'data/models/order_model.dart';
import 'domain/entities/order_status.dart';

class TrackOrderScreen extends ConsumerWidget {
  final String orderId;
  const TrackOrderScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final orderAsync = ref.watch(orderDetailsControllerProvider(orderId));

    return Scaffold(
      body: orderAsync.when(
        data: (order) => _TrackOrderBody(order: order, orderId: orderId),
        loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator())),
        error: (err, _) => Scaffold(
          appBar: AppBar(
            leading: BackButton(
                onPressed: () => context.canPop()
                    ? context.pop()
                    : context.go('/home')),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wifi_off_rounded,
                      size: 56,
                      color: theme.colorScheme.onSurfaceVariant
                          .withOpacity(0.4)),
                  const SizedBox(height: 16),
                  Text('Không tải được đơn hàng',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('$err',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: theme.colorScheme.error, fontSize: 12)),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => ref.refresh(
                        orderDetailsControllerProvider(orderId).future),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Body tách riêng để tái sử dụng và dễ test
// ---------------------------------------------------------------------------
class _TrackOrderBody extends ConsumerWidget {
  final OrderModel order;
  final String orderId;

  const _TrackOrderBody({required this.order, required this.orderId});

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
      case OrderStatus.shipping:
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
    final activeIndex = _getStatusIndex(order.status);
    final isCancelled = order.status == OrderStatus.cancelled;
    final isDelivered = order.status == OrderStatus.delivered;
    final isDelivering = order.status == OrderStatus.outForDelivery ||
        order.status == OrderStatus.delivering ||
        order.status == OrderStatus.shipping;

    final steps = [
      _TrackingStep(
        title: 'Đã gửi đơn hàng',
        subtitle: 'Hệ thống đã nhận đơn hàng của bạn',
        isCompleted: activeIndex >= 0 && !isCancelled,
        isActive: activeIndex == 0 && !isCancelled,
        icon: Icons.assignment_turned_in_rounded,
      ),
      _TrackingStep(
        title: 'Xác nhận đơn hàng',
        subtitle: 'Nhà hàng đang xem xét và chấp nhận đơn',
        isCompleted: activeIndex >= 1 && !isCancelled,
        isActive: activeIndex == 1 && !isCancelled,
        icon: Icons.restaurant_rounded,
      ),
      _TrackingStep(
        title: 'Đang chế biến',
        subtitle: 'Các đầu bếp đang làm món ăn của bạn',
        isCompleted: activeIndex >= 2 && !isCancelled,
        isActive: activeIndex == 2 && !isCancelled,
        icon: Icons.soup_kitchen_rounded,
      ),
      _TrackingStep(
        title: 'Sẵn sàng giao hàng',
        subtitle: 'Món ăn đã đóng gói và bàn giao shipper',
        isCompleted: activeIndex >= 3 && !isCancelled,
        isActive: activeIndex == 3 && !isCancelled,
        icon: Icons.delivery_dining_rounded,
      ),
      _TrackingStep(
        title: isCancelled
            ? 'Đã hủy đơn hàng'
            : (isDelivered ? 'Giao thành công 🎉' : 'Đang trên đường giao'),
        subtitle: isCancelled
            ? 'Đơn hàng của bạn đã bị hủy.'
            : (isDelivered
                ? 'Chúc bạn ngon miệng!'
                : 'Shipper đang trên đường tới chỗ bạn'),
        isCompleted: isCancelled || activeIndex >= 4,
        isActive: isCancelled || (activeIndex >= 4 && activeIndex <= 5),
        icon: isCancelled
            ? Icons.cancel_rounded
            : (isDelivered
                ? Icons.task_alt_rounded
                : Icons.local_shipping_rounded),
        isLast: true,
      ),
    ];

    return Stack(
      children: [
        // ── 1. Simulated Map Background ────────────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.42,
          child: _SimulatedMapBackground(
            isCancelled: isCancelled,
            isDelivered: isDelivered,
          ),
        ),

        // ── 2. AppBar trong suốt ──────────────────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor:
                theme.colorScheme.surface.withValues(alpha: 0.85),
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor:
                    theme.colorScheme.surface.withValues(alpha: 0.9),
                child: BackButton(
                  onPressed: () => context.canPop()
                      ? context.pop()
                      : context.go('/home'),
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            title: Text(
              'Đơn #${orderId.length > 8 ? orderId.substring(0, 8) : orderId}',
              style: theme.textTheme.headlineMedium?.copyWith(
                  fontSize: 17, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
        ),

        // ── 3. Bottom Sheet ──────────────────────────────────────────────
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.62,
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 30,
                  offset: const Offset(0, -8),
                )
              ],
              border: Border(
                  top: BorderSide(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.3))),
            ),
            child: Column(
              children: [
                // Drag handle
                const SizedBox(height: 12),
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 14),

                // Mã đơn hàng (copyable)
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: order.id));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Đã sao chép mã đơn hàng'),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: theme.colorScheme.secondary
                              .withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.copy_rounded,
                            size: 14,
                            color:
                                theme.colorScheme.onSecondaryContainer),
                        const SizedBox(width: 8),
                        Text(
                          'MÃ ĐƠN: #${order.id}',
                          style: TextStyle(
                            color: theme.colorScheme.onSecondaryContainer,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Trạng thái
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TRẠNG THÁI',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: 1.1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isCancelled
                                ? 'Đã hủy đơn'
                                : isDelivered
                                    ? 'Đã giao 🎉'
                                    : 'Đang thực hiện...',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: isCancelled
                                  ? theme.colorScheme.error
                                  : isDelivered
                                      ? const Color(0xFF059669)
                                      : theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      // Pulse indicator khi đang xử lý
                      if (!isCancelled && !isDelivered)
                        _PulsingDot(color: theme.colorScheme.primary),
                    ],
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Divider(height: 1),
                ),

                // Steps + Info sections (scrollable)
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 4),
                    children: [
                      // Tracking Steps
                      ...steps,

                      const SizedBox(height: 8),
                      const Divider(height: 1),
                      const SizedBox(height: 12),

                      // ── Thông tin giao hàng ──────────────────────────
                      _InfoSection(
                        icon: Icons.location_on_rounded,
                        title: 'Địa chỉ giao hàng',
                        content: order.deliveryAddress.isNotEmpty
                            ? order.deliveryAddress
                            : 'Không rõ địa chỉ',
                      ),

                      if (order.note != null &&
                          order.note!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        _InfoSection(
                          icon: Icons.sticky_note_2_rounded,
                          title: 'Ghi chú',
                          content: order.note!,
                          contentColor:
                              const Color(0xFF92400E), // amber-800
                          bgColor: const Color(0xFFFFFBEB), // amber-50
                        ),
                      ],

                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),

                      // ── Danh sách món ────────────────────────────────
                      Text(
                        'Món ăn',
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...order.items.map((item) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer
                                        .withOpacity(0.2),
                                    borderRadius:
                                        BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${item.quantity}×',
                                    style: theme.textTheme.labelSmall
                                        ?.copyWith(
                                      color:
                                          theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.name,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                                Text(
                                  formatPrice(
                                      item.unitPrice * item.quantity),
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: theme.colorScheme
                                        .onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )),

                      // Total
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tổng cộng',
                              style: theme.textTheme.labelMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold)),
                          Text(
                            formatPrice(order.totalAmount),
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 100), // safe scroll space
                    ],
                  ),
                ),

                // ── Bottom action buttons ──────────────────────────────
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(20, 8, 20, 12),
                    child: Column(
                      children: [
                        // Nút "Xác nhận đã nhận hàng" khi đang giao
                        if (isDelivering)
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FilledButton.icon(
                              onPressed: () async {
                                final confirm =
                                    await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                20)),
                                    title: const Text(
                                        'Xác nhận đã nhận hàng?'),
                                    content: const Text(
                                        'Hành động này sẽ hoàn tất đơn hàng của bạn.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Chưa'),
                                      ),
                                      FilledButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        child:
                                            const Text('Đã nhận ✓'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true &&
                                    context.mounted) {
                                  final success = await ref
                                      .read(orderDetailsControllerProvider(
                                              orderId)
                                          .notifier)
                                      .confirmDelivery();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(success
                                            ? 'Cảm ơn bạn! Đơn hàng đã hoàn tất. 🎉'
                                            : 'Không thể xác nhận đơn hàng lúc này'),
                                        behavior:
                                            SnackBarBehavior.floating,
                                        backgroundColor: success
                                            ? const Color(0xFF059669)
                                            : theme.colorScheme.error,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(
                                                    12)),
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(
                                  Icons.check_circle_rounded),
                              label: const Text(
                                'Xác nhận đã nhận hàng',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF059669),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14)),
                              ),
                            ),
                          ),

                        // Nút "Hủy đơn" khi pending
                        if (order.status == OrderStatus.pending)
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final confirm =
                                    await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                20)),
                                    title:
                                        const Text('Hủy đơn hàng'),
                                    content: const Text(
                                        'Bạn có chắc chắn muốn hủy đơn hàng này không?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text('Không'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, true),
                                        style: TextButton.styleFrom(
                                            foregroundColor:
                                                Theme.of(context)
                                                    .colorScheme
                                                    .error),
                                        child: const Text('Có, Hủy ngay'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  final success = await ref
                                      .read(orderDetailsControllerProvider(
                                              orderId)
                                          .notifier)
                                      .cancelOrder();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(
                                        content: Text(success
                                            ? 'Đã hủy đơn hàng thành công'
                                            : 'Không thể hủy đơn hàng lúc này'),
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(
                                  Icons.cancel_outlined),
                              label: const Text('Hủy đơn hàng',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .error),
                                foregroundColor:
                                    Theme.of(context).colorScheme.error,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Simulated Map Background — dùng CustomPainter, không phụ thuộc URL ngoài
// ---------------------------------------------------------------------------
class _SimulatedMapBackground extends StatelessWidget {
  final bool isCancelled;
  final bool isDelivered;

  const _SimulatedMapBackground({
    required this.isCancelled,
    required this.isDelivered,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = isCancelled
        ? theme.colorScheme.error
        : isDelivered
            ? const Color(0xFF059669)
            : theme.colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.06),
            theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
            primaryColor.withOpacity(0.08),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _MapGridPainter(
            gridColor: theme.colorScheme.outlineVariant.withOpacity(0.3)),
        child: Stack(
          children: [
            // Store marker
            Positioned(
              left: 56,
              top: 100,
              child: _MapPin(
                icon: Icons.store_rounded,
                color: const Color(0xFFDC2626), // red-600
                label: 'Cửa hàng',
              ),
            ),
            // Customer marker
            Positioned(
              right: 56,
              bottom: 80,
              child: _MapPin(
                icon: Icons.person_pin_circle_rounded,
                color: const Color(0xFF059669), // emerald-600
                label: 'Bạn',
              ),
            ),
            // Shipper / status indicator
            Positioned(
              top: 140,
              right: 130,
              child: _ShipperPin(
                color: primaryColor,
                isCancelled: isCancelled,
                isDelivered: isDelivered,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapGridPainter extends CustomPainter {
  final Color gridColor;
  _MapGridPainter({required this.gridColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    const spacing = 32.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_MapGridPainter oldDelegate) => false;
}

class _MapPin extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _MapPin(
      {required this.icon, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(height: 3),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 9, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class _ShipperPin extends StatelessWidget {
  final Color color;
  final bool isCancelled;
  final bool isDelivered;

  const _ShipperPin(
      {required this.color,
      required this.isCancelled,
      required this.isDelivered});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: color.withValues(alpha: 0.45),
              blurRadius: 18,
              spreadRadius: 5)
        ],
      ),
      child: Icon(
        isCancelled
            ? Icons.close_rounded
            : isDelivered
                ? Icons.task_alt_rounded
                : Icons.directions_bike_rounded,
        color: Colors.white,
        size: 22,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Pulsing dot indicator (active order)
// ---------------------------------------------------------------------------
class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: 12,
        height: 12,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.color.withValues(alpha: _anim.value),
          boxShadow: [
            BoxShadow(
                color: widget.color.withValues(alpha: _anim.value * 0.5),
                blurRadius: 6,
                spreadRadius: 2)
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info Section widget
// ---------------------------------------------------------------------------
class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final Color? contentColor;
  final Color? bgColor;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.content,
    this.contentColor,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor ??
            theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon,
              size: 16,
              color: contentColor ??
                  theme.colorScheme.onSurfaceVariant.withOpacity(0.7)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurfaceVariant,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  content,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: contentColor ?? theme.colorScheme.onSurface,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tracking Step widget (tách riêng, không đổi logic)
// ---------------------------------------------------------------------------
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? theme.colorScheme.primary
                        : (isCompleted
                            ? const Color(0xFF059669)
                            : theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.5)),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                        : null,
                  ),
                  child: Icon(icon,
                      size: 14,
                      color: isActive
                          ? theme.colorScheme.onPrimary
                          : (isCompleted
                              ? Colors.white
                              : theme.colorScheme.onSurfaceVariant)),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: isCompleted
                          ? const Color(0xFF059669)
                          : theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.5),
                      margin:
                          const EdgeInsets.symmetric(vertical: 4),
                    ),
                  )
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: isActive
                          ? theme.colorScheme.primary
                          : (isCompleted
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurfaceVariant),
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isActive
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
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
