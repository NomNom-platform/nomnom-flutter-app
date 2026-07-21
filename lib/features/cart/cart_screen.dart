import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../../shared/widgets/user_avatar.dart';
import 'package:go_router/go_router.dart';
import 'presentation/controllers/cart_controller.dart';

// Import phục vụ cảnh báo Calo dinh dưỡng dựa trên TDEE
import '../auth/presentation/controllers/auth_controller.dart';
import '../auth/domain/entities/health_metrics.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartControllerProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);

    // Watch chỉ số sức khỏe của người dùng
    final healthMetricsAsync = ref.watch(healthMetricsProvider);

    // Tính tổng lượng Calo hiện tại trong giỏ hàng
    final int totalCalories = cart.fold(0, (sum, item) => sum + (item.calories * item.quantity));

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_rounded, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 4),
            Text(
              'Giao đến nhà riêng', 
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 15, 
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: const UserAvatar(radius: 16),
          )
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined, 
                    size: 72, 
                    color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 16),
                  Text('Giỏ hàng trống', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    'Hãy khám phá nhà hàng và thêm các món ăn dinh dưỡng!', 
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.explore_outlined),
                    label: const Text('Khám phá ngay'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  )
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Giỏ hàng của tôi', 
                              style: theme.textTheme.displayLarge?.copyWith(
                                fontSize: 28, 
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: const Text('Xóa giỏ hàng?'),
                                    content: const Text('Bạn có chắc chắn muốn xóa toàn bộ sản phẩm trong giỏ hàng không?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx),
                                        child: const Text('Không'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          cartNotifier.clearCart();
                                          Navigator.pop(ctx);
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: theme.colorScheme.error,
                                        ),
                                        child: const Text('Có, Xóa hết'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              icon: Icon(Icons.delete_sweep_rounded, color: theme.colorScheme.error, size: 20),
                              label: Text('Xóa hết', style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // --- Tích hợp Panel Cảnh báo Dinh dưỡng/Calo (Calorie Budget Warning) ---
                        _buildCalorieWarningPanel(
                          theme: theme,
                          context: context,
                          healthMetricsAsync: healthMetricsAsync,
                          totalCalories: totalCalories,
                        ),
                        const SizedBox(height: 16),

                         ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cart.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = cart[index];
                            return Dismissible(
                              key: Key(item.menuItemId),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20.0),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.error,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
                              ),
                              onDismissed: (direction) {
                                cartNotifier.removeItem(item.menuItemId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Đã xóa món ${item.name} khỏi giỏ'),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
                                    action: SnackBarAction(
                                      label: 'Hoàn tác',
                                      onPressed: () {
                                        cartNotifier.addItem(item);
                                      },
                                    ),
                                  ),
                                );
                              },
                              child: _CartItem(
                                title: item.name,
                                subtitle: '${item.calories} kcal',
                                price: formatPrice(item.price),
                                quantity: item.quantity,
                                imageUrl: item.imageUrl,
                                onRemove: () => cartNotifier.removeItem(item.menuItemId),
                                onIncrement: () => cartNotifier.updateQuantity(item.menuItemId, item.quantity + 1),
                                onDecrement: () => cartNotifier.updateQuantity(item.menuItemId, item.quantity - 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Order Summary Sticky
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06), 
                        blurRadius: 24, 
                        offset: const Offset(0, -8),
                      )
                    ],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    border: Border(
                      top: BorderSide(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Tổng quan đơn hàng', 
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 18, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SummaryRow(label: 'Tạm tính', value: formatPrice(cartNotifier.subtotal)),
                      const SizedBox(height: 8),
                      _SummaryRow(label: 'Phí vận chuyển', value: formatPrice(cartNotifier.deliveryFee)),
                      const SizedBox(height: 8),
                      _SummaryRow(label: 'Thuế & Phí (8%)', value: formatPrice(cartNotifier.tax)),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tổng thanh toán', 
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatPrice(cartNotifier.total), 
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontSize: 20, 
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/cart/checkout');
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Tiến hành thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/for-you');
          if (index == 3) context.go('/inbox');
          if (index == 4) context.go('/profile');
        }
      ),
    );
  }

  // Tiện ích xây dựng bảng phân tích cảnh báo Calo/Dinh dưỡng trong giỏ hàng
  Widget _buildCalorieWarningPanel({
    required ThemeData theme,
    required BuildContext context,
    required AsyncValue<HealthMetrics> healthMetricsAsync,
    required int totalCalories,
  }) {
    return healthMetricsAsync.when(
      data: (health) {
        if (health.calorieGoal <= 0) {
          return const SizedBox.shrink();
        }

        final double caloTarget = health.calorieGoal;
        final double ratio = totalCalories / caloTarget;
        
        // Xác định mức độ cảnh báo
        final bool isExceeded = ratio > 0.40; // Đơn hàng chiếm trên 40% TDEE là quá cao cho 1 bữa ăn
        final String warningMsg = isExceeded
            ? '⚠️ Bữa ăn này chiếm ${(ratio * 100).toStringAsFixed(0)}% mục tiêu Calo ngày của bạn (${totalCalories} kcal). Bạn có thể cân nhắc giảm bớt số lượng hoặc đổi sang các món ít calo để giữ dáng.'
            : '✅ Bữa ăn này chiếm ${(ratio * 100).toStringAsFixed(0)}% mục tiêu Calo ngày (${totalCalories} kcal), hoàn toàn nằm trong ngân sách dinh dưỡng lành mạnh của bạn.';

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isExceeded ? Colors.red.withValues(alpha: 0.05) : Colors.green.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isExceeded ? Colors.red.withValues(alpha: 0.2) : Colors.green.withValues(alpha: 0.2),
              width: 1.5,
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    isExceeded ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                    color: isExceeded ? Colors.red[800] : Colors.green[800],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isExceeded ? 'Cảnh báo Calo vượt hạn mức' : 'Ngân sách Calo an toàn',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isExceeded ? Colors.red[900] : Colors.green[900],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              Text(
                warningMsg,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: isExceeded ? Colors.red[950] : Colors.green[950],
                ),
              ),
              const SizedBox(height: 10),
              
              // Thanh đo tỷ lệ calo
              Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: ratio.clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: Colors.grey[200],
                        color: isExceeded ? Colors.red : Colors.green,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${(ratio * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isExceeded ? Colors.red[900] : Colors.green[900],
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
      loading: () => const Center(child: LinearProgressIndicator()),
      // Đối với trạng thái Guest hoặc Lỗi, hiển thị gợi ý đăng nhập để theo dõi Calo
      error: (err, stack) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Đăng nhập để theo dõi Calo giỏ hàng',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  Text(
                    'Tự động so sánh lượng Calo đặt món với chỉ số TDEE cá nhân của bạn.',
                    style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                  )
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: theme.colorScheme.primary),
              onPressed: () => context.go('/login'),
            )
          ],
        ),
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final int quantity;
  final String imageUrl;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.imageUrl,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03), 
            blurRadius: 10, 
            offset: const Offset(0, 2),
          )
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (c, e, s) => Image.network(AppConstants.mockCafe, width: 80, height: 80, fit: BoxFit.cover)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title, 
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 15, 
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(Icons.close_rounded, color: theme.colorScheme.onSurfaceVariant, size: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle, 
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price, 
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 16, 
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: onDecrement,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.remove, size: 16, color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('$quantity', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onIncrement,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.add, size: 16, color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  
  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13)),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
