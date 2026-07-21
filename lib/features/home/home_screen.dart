import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import '../../shared/widgets/user_avatar.dart';
import 'package:go_router/go_router.dart';
import '../restaurant/presentation/controllers/customer_restaurant_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  // Trạng thái tìm kiếm và bộ lọc nhanh
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = ''; // Tách riêng để trigger rebuild chính xác
  String _activeFilter = ''; // '', 'nearby', 'rating', 'fast', 'low_calo'
  String _selectedCategory = ''; // Danh mục đồ ăn được chọn

  // Scroll controller để cuộn tới phần nhà hàng khi chọn danh mục
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _restaurantSectionKey = GlobalKey();

  // Quản lý Banner khuyến mãi tự động trượt
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _bannerTimer;

  // Dữ liệu giả lập Banner quảng cáo
  final List<Map<String, String>> _promoBanners = [
    {
      'title': 'Healthy Salad Combo',
      'discount': 'GIẢM GIÁ 20%',
      'tagline': 'Thực đơn xanh chuẩn TDEE của bạn',
      'image': AppConstants.mockFood1,
      'gradientStart': '#4CAF50',
      'gradientEnd': '#2E7D32',
    },
    {
      'title': 'Freeship Nhà Hàng Organic',
      'discount': 'MIỄN PHÍ VẬN CHUYỂN',
      'tagline': 'Áp dụng cho đơn hàng healthy từ 150k',
      'image': AppConstants.mockFood2,
      'gradientStart': '#FF9800',
      'gradientEnd': '#F57C00',
    },
    {
      'title': 'Năng lượng xanh tràn đầy',
      'discount': 'ĐỒNG GIÁ 149.000 đ',
      'tagline': 'Bữa sáng healthy đầy đủ protein',
      'image': AppConstants.mockCafe,
      'gradientStart': '#2196F3',
      'gradientEnd': '#1565C0',
    }
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    
    // Đặt Timer trượt banner sau mỗi 3.5 giây
    _bannerTimer = Timer.periodic(const Duration(milliseconds: 3500), (timer) {
      if (!mounted) return;
      setState(() {
        _currentPage = (_currentPage + 1) % _promoBanners.length;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  /// Cuộn xuống phần nhà hàng sau khi setState
  void _scrollToRestaurants() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = _restaurantSectionKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.0,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _pageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Chuyển đổi mã màu hex sang Color
  Color _parseHexColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final restaurantsAsync = ref.watch(customerRestaurantsProvider);
    final categories = restaurantsAsync.maybeWhen(
      data: (list) => list.map((r) => r.cuisineType).where((c) => c.isNotEmpty).toSet().toList(),
      orElse: () => <String>[],
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on_rounded, color: theme.colorScheme.primary, size: 22),
            const SizedBox(width: 6),
            Text(
              'Giao đến nhà riêng', 
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const Icon(Icons.expand_more_rounded, size: 20),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: const UserAvatar(radius: 18),
          )
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Ô tìm kiếm & Bộ lọc nhanh thông minh
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04), 
                          blurRadius: 16, 
                          offset: const Offset(0, 4),
                        )
                      ],
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                      )
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) => setState(() {
                              _searchQuery = value.trim().toLowerCase();
                            }),
                            decoration: const InputDecoration(
                              hintText: 'Tìm nhà hàng, ẩm thực...',
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.close_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() { _searchQuery = ''; });
                            },
                          )
                        else
                          IconButton(
                            icon: Icon(Icons.tune_rounded, color: theme.colorScheme.primary),
                            tooltip: 'Bộ lọc',
                            onPressed: () => _showFilterSheet(context, theme),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Các thẻ lọc nhanh (Filter Chips)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Gần tôi', 'nearby', Icons.near_me_outlined, theme),
                        _buildFilterChip('Đánh giá 4.8+', 'rating', Icons.star_border_rounded, theme),
                        _buildFilterChip('Giao nhanh', 'fast', Icons.speed_outlined, theme),
                        _buildFilterChip('Dưới 500 kcal', 'low_calo', Icons.spa_outlined, theme),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Carousel phân loại Đồ ăn hình tròn sinh động
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Khám phá danh mục', 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: categories.isEmpty
                  ? const Center(child: Text('Đang tải danh mục...'))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        return _buildCategoryCircle(
                          cat,
                          _getCuisineIcon(cat),
                          _getCuisineBgColor(cat),
                          _getCuisineIconColor(cat),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),

            // 3. Banner khuyến mãi tự động trượt (Promo Carousel PageView)
            SizedBox(
              height: 130,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _promoBanners.length,
                onPageChanged: (idx) => setState(() => _currentPage = idx),
                itemBuilder: (context, index) {
                  final banner = _promoBanners[index];
                  final colorStart = _parseHexColor(banner['gradientStart']!);
                  final colorEnd = _parseHexColor(banner['gradientEnd']!);

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [colorStart, colorEnd], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: colorStart.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      ]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            top: -20,
                            child: Opacity(
                              opacity: 0.15,
                              child: Icon(Icons.stars_rounded, size: 160, color: Colors.white),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: Colors.white24,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          banner['discount']!,
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.8),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        banner['title']!,
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        banner['tagline']!,
                                        style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 2,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      banner['image']!,
                                      fit: BoxFit.cover,
                                      height: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Image.network(AppConstants.mockFood1, fit: BoxFit.cover),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            
            // Chỉ báo chấm chuyển trang PageView
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_promoBanners.length, (idx) {
                final isActive = _currentPage == idx;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),

            // 4. Panel AI Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () => context.push('/for-you'),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.tertiaryContainer.withValues(alpha: 0.7), theme.colorScheme.tertiary.withValues(alpha: 0.1)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.tertiary.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Đề xuất calo thông minh', 
                              style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.onTertiaryContainer, 
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Để AI tìm món ăn khớp với TDEE của bạn', 
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, color: theme.colorScheme.tertiary)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 5. Khu vực AI Gợi ý - CTA thực tế
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Gợi ý ăn uống lành mạnh', 
                style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GestureDetector(
                onTap: () => context.push('/for-you'),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.tertiaryContainer.withValues(alpha: 0.9),
                        theme.colorScheme.tertiary.withValues(alpha: 0.15),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: theme.colorScheme.tertiary.withValues(alpha: 0.25)),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.tertiary.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiary.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome, size: 12, color: theme.colorScheme.tertiary),
                                    const SizedBox(width: 4),
                                    Text(
                                      'AI POWERED',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: theme.colorScheme.tertiary,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.8,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'Xem gợi ý calo\ncá nhân hóa cho bạn',
                                style: theme.textTheme.headlineMedium?.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onTertiaryContainer,
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Dựa trên TDEE & mục tiêu dinh dưỡng của bạn',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.restaurant_menu_rounded, color: Colors.white, size: 28),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // 6. Danh sách Nhà hàng lân cận
            Padding(
              key: _restaurantSectionKey,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedCategory.isNotEmpty
                          ? 'Nhà hàng • $_selectedCategory'
                          : 'Nhà hàng lân cận',
                      style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (_selectedCategory.isNotEmpty)
                    GestureDetector(
                      onTap: () => setState(() => _selectedCategory = ''),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.close_rounded, size: 14, color: theme.colorScheme.primary),
                            const SizedBox(width: 4),
                            Text(
                              'Xóa lọc',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: restaurantsAsync.when(
                data: (restaurants) {
                  if (restaurants.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('Không tìm thấy nhà hàng nào đang hoạt động.'),
                      ),
                    );
                  }
                  
                  // Lọc theo danh mục được chọn
                  var filtered = List.of(restaurants);
                  if (_selectedCategory.isNotEmpty) {
                    filtered = filtered.where((r) =>
                      r.cuisineType.toLowerCase() == _selectedCategory.toLowerCase()
                    ).toList();
                  }

                  // Lọc theo từ khóa tìm kiếm (Tên, Cuisine, Description)
                  if (_searchQuery.isNotEmpty) {
                    filtered = filtered.where((r) =>
                      r.name.toLowerCase().contains(_searchQuery) ||
                      r.cuisineType.toLowerCase().contains(_searchQuery) ||
                      r.description.toLowerCase().contains(_searchQuery)
                    ).toList();
                  }

                  // Lọc/Sắp xếp theo filter chips hoạt động
                  if (_activeFilter == 'nearby') {
                    filtered.sort((a, b) => a.address.length.compareTo(b.address.length));
                  } else if (_activeFilter == 'rating') {
                    filtered.sort((a, b) => b.name.length.compareTo(a.name.length));
                  } else if (_activeFilter == 'fast') {
                    filtered = filtered.where((r) => r.address.length < 50).toList();
                    filtered.sort((a, b) => a.address.length.compareTo(b.address.length));
                  } else if (_activeFilter == 'low_calo') {
                    filtered = filtered.where((r) =>
                      r.cuisineType.toLowerCase().contains('salad') ||
                      r.cuisineType.toLowerCase().contains('healthy') ||
                      r.cuisineType.toLowerCase().contains('vegan') ||
                      r.description.toLowerCase().contains('calo') ||
                      r.description.toLowerCase().contains('diet') ||
                      r.description.toLowerCase().contains('healthy')
                    ).toList();
                  }

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Text('Không tìm thấy nhà hàng nào khớp với tìm kiếm & bộ lọc.'),
                      ),
                    );
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final r = filtered[index];
                      return _RestaurantCard(
                        title: r.name,
                        subtitle: '${r.cuisineType} • ${r.address}',
                        rating: '4.8',
                        time: '20-30 phút',
                        imageUrl: (r.imageUrl != null && r.imageUrl!.isNotEmpty) ? r.imageUrl! : AppConstants.mockPizza,
                        onTap: () => context.push('/restaurant/${r.id}'),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Lỗi tải danh sách nhà hàng: $err')),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.go('/for-you');
          if (index == 2) context.go('/cart');
          if (index == 3) context.go('/inbox');
          if (index == 4) context.go('/profile');
        }
      ),
    );
  }

  IconData _getCuisineIcon(String cuisine) {
    switch (cuisine.toLowerCase()) {
      case 'pizza':
        return Icons.local_pizza_outlined;
      case 'burger':
      case 'fastfood':
      case 'fast food':
        return Icons.lunch_dining_outlined;
      case 'salad':
      case 'healthy':
      case 'vegan':
        return Icons.eco_outlined;
      case 'sushi':
      case 'seafood':
        return Icons.set_meal_outlined;
      case 'drink':
      case 'beverage':
      case 'đồ uống':
        return Icons.local_drink_outlined;
      case 'cafe':
      case 'coffee':
        return Icons.local_cafe_outlined;
      case 'dessert':
      case 'cake':
      case 'desserts':
        return Icons.cake_outlined;
      default:
        return Icons.restaurant_menu_outlined;
    }
  }

  Color _getCuisineBgColor(String cuisine) {
    final index = cuisine.hashCode.abs() % 6;
    final colors = [
      const Color(0xFFFFF8E1), // Amber 50
      const Color(0xFFFFF3E0), // Orange 50
      const Color(0xFFE8F5E9), // Green 50
      const Color(0xFFFFEBEE), // Red 50
      const Color(0xFFE0F2F1), // Teal 50
      const Color(0xFFE3F2FD), // Blue 50
    ];
    return colors[index];
  }

  Color _getCuisineIconColor(String cuisine) {
    final index = cuisine.hashCode.abs() % 6;
    final colors = [
      const Color(0xFFFF8F00), // Amber 800
      const Color(0xFFEF6C00), // Orange 800
      const Color(0xFF2E7D32), // Green 800
      const Color(0xFFC62828), // Red 800
      const Color(0xFF00695C), // Teal 800
      const Color(0xFF1565C0), // Blue 800
    ];
    return colors[index];
  }

  // Trình xây dựng Thẻ lọc nhanh
  Widget _buildFilterChip(String label, String code, IconData icon, ThemeData theme) {
    final isSelected = _activeFilter == code;
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeFilter = isSelected ? '' : code;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          )
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              size: 16, 
              color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label, 
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Trình xây dựng Vòng tròn Danh mục thức ăn (Category Circle)
  Widget _buildCategoryCircle(String label, IconData icon, Color bgColor, Color iconColor) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = isSelected ? '' : label;
        });
        // Cuộn xuống phần nhà hàng để người dùng thấy kết quả lọc
        if (!isSelected) _scrollToRestaurants();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? iconColor : bgColor,
                shape: BoxShape.circle,
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: iconColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : null,
              ),
              child: Icon(
                icon, 
                size: 24, 
                color: isSelected ? Colors.white : iconColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label, 
              style: TextStyle(
                fontSize: 12, 
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? iconColor : null,
              ),
            )
          ],
        ),
      ),
    );
  }

  // Bottom sheet bộ lọc nâng cao
  void _showFilterSheet(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40, height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Bộ lọc', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Text('Sắp xếp theo', style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _sheetFilterChip(setSheetState, theme, 'Gần tôi', 'nearby', Icons.near_me_outlined),
                      _sheetFilterChip(setSheetState, theme, 'Đánh giá cao', 'rating', Icons.star_border_rounded),
                      _sheetFilterChip(setSheetState, theme, 'Giao nhanh', 'fast', Icons.speed_outlined),
                      _sheetFilterChip(setSheetState, theme, 'Dưới 500 kcal', 'low_calo', Icons.spa_outlined),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _activeFilter = '';
                              _selectedCategory = '';
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text('Xóa bộ lọc'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text('Áp dụng'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _sheetFilterChip(StateSetter setSheetState, ThemeData theme, String label, String code, IconData icon) {
    final isSelected = _activeFilter == code;
    return GestureDetector(
      onTap: () {
        setSheetState(() {});
        setState(() {
          _activeFilter = isSelected ? '' : code;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class _RestaurantCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String rating;
  final String time;
  final String imageUrl;
  final VoidCallback onTap;

  const _RestaurantCard({required this.title, required this.subtitle, required this.rating, required this.time, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04), 
              blurRadius: 16, 
              offset: const Offset(0, 4),
            )
          ]
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      time, 
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontSize: 11, 
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star_rounded, size: 16, color: Colors.amber[700]),
                        const SizedBox(width: 4),
                        Text(
                          rating, 
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
