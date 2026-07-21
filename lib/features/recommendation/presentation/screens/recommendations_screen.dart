import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../domain/entities/meal_type.dart';
import '../../domain/entities/recommended_item.dart';
import '../controllers/recommendation_controller.dart';
import '../state/recommendation_state.dart';

// Import thêm để quản lý chọn nhà hàng trực quan và thêm vào giỏ hàng
import '../../../restaurant/presentation/controllers/customer_restaurant_controller.dart';
import '../../../menu/presentation/controllers/menu_controller.dart';
import '../../../cart/presentation/controllers/cart_controller.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class RecommendationsScreen extends ConsumerStatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  ConsumerState<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen> {
  String? _selectedRestaurantId; // Thay thế nhập ID bằng chạm chọn nhà hàng
  MealType _mealType = MealType.lunch;
  bool _useAi = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(recommendationControllerProvider);
    final restaurantsAsync = ref.watch(customerRestaurantsProvider);
    final healthMetricsAsync = ref.watch(healthMetricsProvider);

    // Tự động chọn nhà hàng đầu tiên trong danh sách nếu chưa chọn
    restaurantsAsync.whenData((list) {
      if (_selectedRestaurantId == null && list.isNotEmpty) {
        setState(() {
          _selectedRestaurantId = list.first.id;
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome, color: theme.colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              'Gợi ý dinh dưỡng AI', 
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 18, 
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner giới thiệu AI
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.tertiaryContainer.withValues(alpha: 0.8), theme.colorScheme.surfaceContainerLowest],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.auto_awesome, color: theme.colorScheme.tertiary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'AI CURATED FOR YOU', 
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onTertiaryContainer, 
                          letterSpacing: 1.1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tìm món ăn phù hợp với TDEE và thể trạng của bạn', 
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 18, 
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Form cấu hình
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04), 
                    blurRadius: 20, 
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Thay thế ô nhập Restaurant ID bằng danh sách ngang chọn trực quan ---
                  const Text(
                    'Chọn Nhà hàng:', 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  restaurantsAsync.when(
                    data: (list) {
                      if (list.isEmpty) {
                        return const Text('Không có nhà hàng khả dụng.');
                      }
                      return SizedBox(
                        height: 72,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: list.length,
                          itemBuilder: (context, idx) {
                            final r = list[idx];
                            final isSelected = _selectedRestaurantId == r.id;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedRestaurantId = r.id),
                              child: Container(
                                width: 140,
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected ? theme.colorScheme.primaryContainer.withValues(alpha: 0.15) : theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: Image.network(
                                        (r.imageUrl != null && r.imageUrl!.isNotEmpty) ? r.imageUrl! : AppConstants.mockPizza,
                                        width: 32,
                                        height: 32,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        r.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, s) => Text('Lỗi tải nhà hàng: $e'),
                  ),
                  const SizedBox(height: 16),
                  
                  const Text('Chọn Bữa ăn:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: MealType.values.map((meal) {
                      final isSelected = _mealType == meal;
                      return ChoiceChip(
                        label: Text(meal.label),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _mealType = meal),
                        selectedColor: theme.colorScheme.primaryContainer,
                        labelStyle: TextStyle(
                          color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    value: _useAi,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (value) => setState(() => _useAi = value),
                    title: const Text('Xếp hạng bằng AI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: const Text('Giải thích cá nhân hóa cho từng món ăn phù hợp với thể trạng', style: TextStyle(fontSize: 11)),
                  ),
                  const SizedBox(height: 16),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: (state.isLoading || _selectedRestaurantId == null)
                          ? null
                          : () {
                              ref.read(recommendationControllerProvider.notifier).generate(
                                    restaurantId: _selectedRestaurantId!,
                                    mealType: _mealType,
                                    useAi: _useAi,
                                  );
                            },
                      icon: const Icon(Icons.auto_awesome),
                      label: Text(state.isLoading ? 'Đang phân tích calo...' : 'Nhận gợi ý món ăn'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (state.failure != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.3)),
                ),
                child: Text(
                  state.failure!.message,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onErrorContainer),
                ),
              ),

            if (state.result != null) ...[
              // AI Explanation
              if (state.result!.usedAi && (state.result!.aiExplanation?.isNotEmpty ?? false))
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.purple.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.purple, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.result!.aiExplanation!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (state.result!.items.isEmpty)
                const Text('Không tìm thấy món ăn nào phù hợp với thể trạng tại nhà hàng này.', style: TextStyle(color: Colors.grey))
              else ...[
                const Text('Thực đơn đề cử dành riêng cho bạn:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 12),
                ...state.result!.items.map((item) {
                  // Watch menu items để lấy ảnh bìa món ăn thật
                  final menuAsync = _selectedRestaurantId != null 
                      ? ref.watch(menuControllerProvider(_selectedRestaurantId!))
                      : null;
                  final String imageUrl = _findItemImageUrl(item.itemId, menuAsync?.valueOrNull);
                  
                  // Nhận định Calo bữa ăn cho thanh tiến trình Calo (%)
                  double targetCalo = 2000.0 * 0.35; // Default target
                  final health = healthMetricsAsync.valueOrNull;
                  if (health != null && health.calorieGoal > 0) {
                    final double mealQuota = switch (_mealType) {
                      MealType.breakfast => 0.25,
                      MealType.lunch => 0.35,
                      MealType.dinner => 0.30,
                      MealType.snack => 0.10,
                    };
                    targetCalo = health.calorieGoal * mealQuota;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _RecommendedItemCard(
                      item: item, 
                      imageUrl: imageUrl,
                      restaurantId: _selectedRestaurantId ?? '',
                      targetCalo: targetCalo,
                    ),
                  );
                }),
              ],
            ],

            const SizedBox(height: 24),
            Text(
              'Gợi ý gần đây', 
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const _HistoryList(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 2) context.go('/cart');
          if (index == 3) context.go('/inbox');
          if (index == 4) context.go('/profile');
        },
      ),
    );
  }

  // Lấy ảnh bìa từ danh sách menu
  String _findItemImageUrl(String itemId, List<dynamic>? list) {
    if (list == null) return AppConstants.mockCafe;
    try {
      final matched = list.firstWhere((i) => i.id == itemId);
      if (matched != null && matched.imageUrl != null && matched.imageUrl!.isNotEmpty) {
        return matched.imageUrl!;
      }
    } catch (_) {}
    return AppConstants.mockCafe;
  }
}

// Thẻ món ăn được gợi ý nâng cấp UI/UX cao cấp
class _RecommendedItemCard extends ConsumerWidget {
  final RecommendedItem item;
  final String imageUrl;
  final String restaurantId;
  final double targetCalo;

  const _RecommendedItemCard({
    required this.item, 
    required this.imageUrl, 
    required this.restaurantId,
    required this.targetCalo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final double itemCalo = (item.calories ?? 0).toDouble();
    final double pct = targetCalo > 0 ? (itemCalo / targetCalo).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bên trái: Ảnh món
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl, 
              width: 80, 
              height: 80, 
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Image.network(AppConstants.mockCafe, width: 80, height: 80, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 14),
          
          // Bên phải: Chi tiết và hành động mua nhanh
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.name, 
                        style: theme.textTheme.headlineMedium?.copyWith(fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      formatPrice(item.price), 
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                
                // Các chỉ số dinh dưỡng có vạch màu phân biệt
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    if (item.calories != null) _MacroBadge(text: '${item.calories} kcal', color: Colors.orange[700]!),
                    if (item.proteinG != null) _MacroBadge(text: '${item.proteinG!.toStringAsFixed(0)}g Đạm', color: Colors.green[700]!),
                    if (item.carbG != null) _MacroBadge(text: '${item.carbG!.toStringAsFixed(0)}g Carb', color: Colors.blue[700]!),
                    if (item.fatG != null) _MacroBadge(text: '${item.fatG!.toStringAsFixed(0)}g Fat', color: Colors.red[700]!),
                  ],
                ),
                const SizedBox(height: 8),

                // Thanh đo tỉ lệ Calo của món ăn trong bữa ăn
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 5,
                          backgroundColor: Colors.grey[200],
                          color: pct > 0.9 ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${(pct * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                
                if (item.reason.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.reason, 
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 11, fontStyle: FontStyle.italic),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 10),
                
                // Nút "Thêm vào giỏ" trực tiếp (Upgrade UX)
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ref.read(cartControllerProvider.notifier).addItem(
                        CartItem(
                          menuItemId: item.itemId,
                          name: item.name,
                          price: item.price,
                          quantity: 1,
                          calories: item.calories ?? 0,
                          imageUrl: imageUrl,
                          restaurantId: restaurantId,
                        ),
                      );
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã thêm ${item.name} vào giỏ hàng'),
                          duration: const Duration(seconds: 1),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart_outlined, size: 14),
                    label: const Text('Thêm vào giỏ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  final String text;
  final Color color;

  const _MacroBadge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Text(
        text, 
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          fontSize: 10, 
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _HistoryList extends ConsumerWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final historyAsync = ref.watch(recommendationHistoryProvider);

    return historyAsync.when(
      data: (page) {
        if (page.content.isEmpty) {
          return Text('Chưa có lịch sử gợi ý nào.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant));
        }
        return Column(
          children: page.content.map((log) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 2)),
                ],
              ),
              child: Row(
                children: [
                  Icon(log.usedAi ? Icons.auto_awesome : Icons.restaurant_menu, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${log.mealType.toUpperCase()} • ${log.recommendedItemIds.length} món gợi ý', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                        Text(
                          '${log.createdAt.toLocal()}'.split('.').first,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
      error: (error, _) => Text(
        'Không thể tải lịch sử gợi ý.',
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}
