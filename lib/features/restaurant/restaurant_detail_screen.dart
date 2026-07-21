import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import 'package:go_router/go_router.dart';
import '../cart/domain/entities/cart_item.dart';
import '../cart/presentation/controllers/cart_controller.dart';

import '../restaurant/presentation/controllers/customer_restaurant_controller.dart';
import '../menu/presentation/controllers/menu_controller.dart';
import '../menu/domain/entities/menu_category.dart';

// Import các Controller & Model phục vụ gợi ý dinh dưỡng
import '../recommendation/presentation/controllers/recommendation_controller.dart';
import '../recommendation/presentation/state/recommendation_state.dart';
import '../recommendation/domain/entities/meal_type.dart';
import '../auth/presentation/controllers/auth_controller.dart';
import '../auth/domain/entities/health_metrics.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  const RestaurantDetailScreen({super.key});

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {
  MenuCategory? _selectedCategory;
  
  // Trạng thái cho Panel gợi ý dinh dưỡng (Mobile-first UX)
  MealType _selectedMealType = MealType.lunch;
  bool _useAi = true;
  
  // Các biến kiểm soát việc tự động gọi API gợi ý tránh bị lặp vô tận
  String? _lastRestaurantId;
  MealType? _lastMealType;
  bool? _lastUseAi;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartControllerProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);

    // Lấy restaurantId từ route parameter
    final restaurantId = GoRouterState.of(context).pathParameters['id'] ?? '85cf7e85-ef80-4965-b778-4367cdfa741d';

    final restaurantAsync = ref.watch(restaurantDetailProvider(restaurantId));
    final menuAsync = ref.watch(menuControllerProvider(restaurantId));
    
    // Watch trạng thái gợi ý dinh dưỡng
    final recommendationState = ref.watch(recommendationControllerProvider);
    final healthMetricsAsync = ref.watch(healthMetricsProvider);

    // Kích hoạt tự động fetch gợi ý món ăn dinh dưỡng khi đổi tham số
    if (restaurantId != _lastRestaurantId || _selectedMealType != _lastMealType || _useAi != _lastUseAi) {
      _lastRestaurantId = restaurantId;
      _lastMealType = _selectedMealType;
      _lastUseAi = _useAi;
      
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(recommendationControllerProvider.notifier).generate(
            restaurantId: restaurantId,
            mealType: _selectedMealType,
            useAi: _useAi,
          );
        }
      });
    }

    return restaurantAsync.when(
      data: (restaurant) {
        final menuItems = menuAsync.valueOrNull;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // 1. Sleek SliverAppBar với hiệu ứng đổ mờ và Gradient
              SliverAppBar(
                expandedHeight: 220.0,
                floating: false,
                pinned: true,
                backgroundColor: theme.colorScheme.surface,
                elevation: 0,
                leading: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.9),
                    child: BackButton(
                      onPressed: () => context.pop(), 
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.9),
                      child: IconButton(
                        icon: Icon(Icons.favorite_border, color: theme.colorScheme.primary), 
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.9),
                      child: IconButton(
                        icon: Icon(Icons.share, color: theme.colorScheme.onSurface), 
                        onPressed: () {},
                      ),
                    ),
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        (restaurant.imageUrl != null && restaurant.imageUrl!.isNotEmpty) 
                            ? restaurant.imageUrl! 
                            : AppConstants.mockCafe,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.network(
                          AppConstants.mockCafe, 
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Lớp phủ Gradient giúp text nổi bật và tăng tính thẩm mỹ cao cấp
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black38,
                              Colors.transparent,
                              Colors.black54,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Thẻ thông tin nhà hàng sang trọng
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              restaurant.name, 
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              'Đang mở', 
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.primary, 
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Meta info: Rating, Time, Delivery
                      Row(
                        children: [
                          Icon(Icons.star_rounded, size: 20, color: Colors.amber[700]),
                          const SizedBox(width: 4),
                          Text(
                            '4.8', 
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(100+ đánh giá)', 
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildDotDivider(theme),
                          const SizedBox(width: 8),
                          Icon(Icons.access_time_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Text(
                            '20-30 phút', 
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(width: 8),
                          _buildDotDivider(theme),
                          const SizedBox(width: 8),
                          Text(
                            '\$\$', 
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${restaurant.cuisineType} • ${restaurant.address}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                    ],
                  ),
                ),
              ),

              // 3. Tích hợp "Gợi ý món phù hợp sức khỏe (TDEE/Calo/AI)" - Mobile-first UX
              SliverToBoxAdapter(
                child: _buildHealthRecommendationPanel(
                  context: context,
                  theme: theme,
                  healthMetricsAsync: healthMetricsAsync,
                  recommendationState: recommendationState,
                  restaurantId: restaurantId,
                  menuItems: menuItems,
                  cartNotifier: cartNotifier,
                ),
              ),

              // 4. Sticky Category Filter Tab Bar (Ghim trên cùng khi cuộn màn hình)
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyCategoryHeaderDelegate(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      border: Border(
                        bottom: BorderSide(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _selectedCategory = null),
                            child: _buildFilterChip('Tất cả', _selectedCategory == null, theme),
                          ),
                          const SizedBox(width: 8),
                          ...MenuCategory.values.map((cat) => Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedCategory = cat),
                              child: _buildFilterChip(cat.label, _selectedCategory == cat, theme),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // 5. Section Header cho Danh mục món ăn
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
                  child: Text(
                    _selectedCategory?.label ?? 'Toàn bộ thực đơn', 
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),

              // 6. Danh sách Menu dạng Row compact tối ưu không gian cuộn dọc
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                sliver: menuAsync.when(
                  data: (items) {
                    final filteredItems = _selectedCategory == null
                        ? items
                        : items.where((item) => item.category == _selectedCategory!.apiValue).toList();

                    if (filteredItems.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 48.0),
                          child: Center(
                            child: Text(
                              'Không tìm thấy món ăn nào thuộc danh mục này.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = filteredItems[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _MenuItemRowCard(
                              title: item.name,
                              description: item.description,
                              calories: item.calories,
                              protein: '${item.proteinG.toStringAsFixed(0)}g Protein',
                              price: item.price,
                              imageUrl: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                                  ? item.imageUrl!
                                  : AppConstants.mockCafe,
                              onAdd: () {
                                cartNotifier.addItem(
                                  CartItem(
                                    menuItemId: item.id,
                                    name: item.name,
                                    price: item.price,
                                    quantity: 1,
                                    calories: item.calories,
                                    imageUrl: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                                        ? item.imageUrl!
                                        : AppConstants.mockCafe,
                                    restaurantId: restaurantId,
                                  ),
                                );
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Đã thêm ${item.name} vào giỏ'), 
                                    duration: const Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        childCount: filteredItems.length,
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 48.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                  error: (err, stack) => SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48.0),
                      child: Center(child: Text('Lỗi tải thực đơn: $err')),
                    ),
                  ),
                ),
              ),

              // Khoảng trống cuối màn hình để không bị nút giỏ hàng che khuất
              const SliverToBoxAdapter(
                child: SizedBox(height: 100),
              )
            ],
          ),
          
          // Nút xem giỏ hàng nổi phía dưới cùng
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: cart.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => context.go('/cart'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.onPrimary.withValues(alpha: 0.2), 
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${cart.fold(0, (sum, item) => sum + item.quantity)}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Text(
                                    'Xem giỏ hàng', 
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                ],
                              ),
                              Text(
                                formatPrice(cartNotifier.subtotal), 
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: Center(child: Text('Lỗi tải thông tin nhà hàng: $err')),
      ),
    );
  }

  // Tiện ích phân tách các thẻ MetaInfo
  Widget _buildDotDivider(ThemeData theme) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: theme.colorScheme.outlineVariant,
        shape: BoxShape.circle,
      ),
    );
  }

  // Widget xây dựng chip lọc danh mục
  Widget _buildFilterChip(String label, bool isSelected, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
        )
      ),
    );
  }

  // --- Widget Panel Gợi ý Sức khỏe Cá nhân hóa (Health Recommendation) ---
  Widget _buildHealthRecommendationPanel({
    required BuildContext context,
    required ThemeData theme,
    required AsyncValue<HealthMetrics> healthMetricsAsync,
    required RecommendationState recommendationState,
    required String restaurantId,
    required List<dynamic>? menuItems,
    required CartController cartNotifier,
  }) {
    return healthMetricsAsync.when(
      data: (health) {
        if (health.tdee <= 0) {
          return _buildNotConfiguredHealthWidget(theme);
        }
        
        // Tính Calorie Target cho bữa ăn hiện tại
        final double mealQuota = switch (_selectedMealType) {
          MealType.breakfast => 0.25,
          MealType.lunch => 0.35,
          MealType.dinner => 0.30,
          MealType.snack => 0.10,
        };
        final double targetCalo = health.calorieGoal * mealQuota;

        return Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.green.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          color: Colors.green.withValues(alpha: 0.03),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Panel
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.spa, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gợi ý món ăn dinh dưỡng', 
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                          Text(
                            'Dựa trên mục tiêu calo (TDEE) cá nhân',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Chỉ số sức khỏe hiện tại
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricWidget('TDEE', '${health.tdee.toStringAsFixed(0)} kcal', theme),
                      _buildMetricWidget('Mục tiêu ngày', '${health.calorieGoal.toStringAsFixed(0)} kcal', theme),
                      _buildMetricWidget('Chỉ số BMI', health.bmiCategory, theme),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Bộ chọn bữa ăn (Breakfast, Lunch, Dinner, Snack)
                const Text(
                  'Chọn bữa ăn hôm nay:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: MealType.values.map((m) {
                      final isSelected = _selectedMealType == m;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(m.label),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _selectedMealType = m);
                          },
                          selectedColor: Colors.green[100],
                          backgroundColor: theme.colorScheme.surface,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.green[900] : theme.colorScheme.onSurface,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? Colors.green : theme.colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // Toggle AI ranking & explanation
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.psychology, color: Colors.purple, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Xếp hạng & Giải thích bằng AI',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: _useAi,
                      activeColor: Colors.green,
                      onChanged: (val) => setState(() => _useAi = val),
                    )
                  ],
                ),
                
                // Explanatory note
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.amber.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
                  ),
                  child: Text(
                    'Mục tiêu bữa ${_selectedMealType.label.toLowerCase()} chiếm ${(mealQuota * 100).toStringAsFixed(0)}% calo hằng ngày (≈ ${targetCalo.toStringAsFixed(0)} kcal).',
                    style: TextStyle(color: Colors.amber[900], fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),

                // Hiển thị kết quả gợi ý
                if (recommendationState.isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Center(child: CircularProgressIndicator(color: Colors.green)),
                  )
                else if (recommendationState.failure != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Không lấy được gợi ý: ${recommendationState.failure.toString()}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else if (recommendationState.result != null) ...[
                  // AI Explanation
                  if (recommendationState.result!.aiExplanation != null &&
                      recommendationState.result!.aiExplanation!.isNotEmpty) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple.withValues(alpha: 0.15)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.auto_awesome, color: Colors.purple, size: 16),
                              const SizedBox(width: 6),
                              Text(
                                'AI nhận định sức khỏe:',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple[800],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            recommendationState.result!.aiExplanation!,
                            style: const TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  
                  // Recommended items horizontal slider
                  if (recommendationState.result!.items.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Text('Không tìm thấy món ăn phù hợp với bữa này trong menu.', style: TextStyle(color: Colors.grey, fontSize: 13)),
                    )
                  else ...[
                    const Text(
                      'Món ăn khuyên dùng:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 220,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: recommendationState.result!.items.length,
                        itemBuilder: (context, idx) {
                          final recItem = recommendationState.result!.items[idx];
                          final itemImageUrl = _findItemImageUrl(recItem.itemId, menuItems);
                          final double itemCalo = (recItem.calories ?? 0).toDouble();
                          
                          // Tính % calo chiếm dụng so với mục tiêu bữa ăn
                          final double pct = targetCalo > 0 ? (itemCalo / targetCalo).clamp(0.0, 1.0) : 0.0;

                          return Container(
                            width: 250,
                            margin: const EdgeInsets.only(right: 12.0),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.green.withValues(alpha: 0.15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Ảnh và giá tiền
                                  Stack(
                                    children: [
                                      Image.network(
                                        itemImageUrl,
                                        height: 90,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Image.network(
                                          AppConstants.mockCafe,
                                          height: 90,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.black.withValues(alpha: 0.8),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            formatPrice(recItem.price),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            recItem.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Icon(Icons.local_fire_department, size: 14, color: Colors.orange[800]),
                                              Text(
                                                '${recItem.calories ?? 0} kcal',
                                                style: TextStyle(
                                                  color: Colors.orange[900],
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              if (recItem.proteinG != null) ...[
                                                const SizedBox(width: 6),
                                                Text(
                                                  '•  ${recItem.proteinG!.toStringAsFixed(0)}g Đạm',
                                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                                )
                                              ]
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          
                                          // Thanh tiến trình Calo (%)
                                          Row(
                                            children: [
                                              Expanded(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(4),
                                                  child: LinearProgressIndicator(
                                                    value: pct,
                                                    minHeight: 6,
                                                    backgroundColor: Colors.grey[200],
                                                    color: pct > 0.9 ? Colors.red : Colors.green,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                '${(pct * 100).toStringAsFixed(0)}%',
                                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          
                                          // Lý do gợi ý
                                          Expanded(
                                            child: Text(
                                              recItem.reason,
                                              style: TextStyle(color: Colors.grey[600], fontSize: 10),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          
                                          // Nút add nhanh
                                          SizedBox(
                                            width: double.infinity,
                                            height: 28,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                cartNotifier.addItem(
                                                  CartItem(
                                                    menuItemId: recItem.itemId,
                                                    name: recItem.name,
                                                    price: recItem.price,
                                                    quantity: 1,
                                                    calories: recItem.calories ?? 0,
                                                    imageUrl: itemImageUrl,
                                                    restaurantId: restaurantId,
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).clearSnackBars();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Đã thêm ${recItem.name} vào giỏ'), 
                                                    duration: const Duration(seconds: 1),
                                                    behavior: SnackBarBehavior.floating,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.zero,
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: const Text('Thêm vào giỏ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ]
                ],
              ],
            ),
          ),
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => _buildNoProfileStateWidget(theme, context),
    );
  }

  // Lấy ảnh bìa món ăn từ danh mục menu chính nếu khớp ID
  String _findItemImageUrl(String itemId, List<dynamic>? menuItems) {
    if (menuItems == null) return AppConstants.mockCafe;
    try {
      final matched = menuItems.firstWhere((item) => item.id == itemId);
      if (matched != null && matched.imageUrl != null && matched.imageUrl!.isNotEmpty) {
        return matched.imageUrl!;
      }
    } catch (_) {}
    return AppConstants.mockCafe;
  }

  Widget _buildMetricWidget(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          label, 
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 2),
        Text(
          value, 
          style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
        ),
      ],
    );
  }

  Widget _buildNotConfiguredHealthWidget(ThemeData theme) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.info_outline, size: 40, color: Colors.orange),
            const SizedBox(height: 12),
            const Text(
              'Chưa thiết lập chỉ số sức khỏe',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'Vui lòng cập nhật chiều cao, cân nặng và TDEE trong hồ sơ để nhận gợi ý bữa ăn cá nhân hóa.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.push('/health-setup'),
              child: const Text('Thiết lập hồ sơ ngay'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoProfileStateWidget(ThemeData theme, BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 0,
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.lock_person_outlined, size: 36, color: theme.colorScheme.primary),
            const SizedBox(height: 12),
            const Text(
              'Đăng nhập để nhận Gợi ý Sức khỏe',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 6),
            const Text(
              'Hệ thống cần hồ sơ sức khỏe và chỉ số TDEE của bạn để thiết lập bữa ăn khoa học.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text('Đăng nhập', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// --- Sticky Tab Bar Delegate ---
class _StickyCategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyCategoryHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 58.0;

  @override
  double get minExtent => 58.0;

  @override
  bool shouldRebuild(covariant _StickyCategoryHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}

// --- MenuItemRowCard: Card Món ăn layout dòng ngang (Row) tinh tế, tối ưu cho Mobile ---
class _MenuItemRowCard extends StatelessWidget {
  final String title;
  final String description;
  final int calories;
  final String protein;
  final double price;
  final String imageUrl;
  final VoidCallback onAdd;

  const _MenuItemRowCard({
    required this.title,
    required this.description,
    required this.calories,
    required this.protein,
    required this.price,
    required this.imageUrl,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03), 
            blurRadius: 10, 
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bên trái: Chi tiết món ăn (Tiêu đề, mô tả, calo, giá, nút add)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title, 
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    description, 
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 11,
                    ),
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                
                // Hàng Nutrition badges
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department, size: 12, color: Colors.orange[800]),
                          const SizedBox(width: 2),
                          Text(
                            '$calories kcal', 
                            style: TextStyle(
                              fontSize: 10, 
                              fontWeight: FontWeight.bold, 
                              color: Colors.orange[900],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        protein, 
                        style: TextStyle(
                          fontSize: 10, 
                          fontWeight: FontWeight.bold, 
                          color: Colors.green[900],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Giá và nút bấm thêm món (Touch target to đạt chuẩn)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatPrice(price), 
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                    
                    // Nút thêm (Touch target tối thiểu 40x40)
                    InkWell(
                      onTap: onAdd,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.add, 
                              size: 14, 
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              'Thêm', 
                              style: TextStyle(
                                fontSize: 12, 
                                fontWeight: FontWeight.bold, 
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Bên phải: Ảnh đại diện món ăn
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl, 
              height: 84, 
              width: 84, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Image.network(
                AppConstants.mockCafe, 
                height: 84, 
                width: 84, 
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
