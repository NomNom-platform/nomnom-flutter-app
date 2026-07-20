import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import '../cart/domain/entities/cart_item.dart';
import '../cart/presentation/controllers/cart_controller.dart';

import '../restaurant/presentation/controllers/customer_restaurant_controller.dart';
import '../menu/presentation/controllers/menu_controller.dart';
import '../menu/domain/entities/menu_category.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  const RestaurantDetailScreen({super.key});

  @override
  ConsumerState<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends ConsumerState<RestaurantDetailScreen> {
  MenuCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartControllerProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);

    // Lấy restaurantId từ route parameter, mặc định dùng ID giả lập nếu không có
    final restaurantId = GoRouterState.of(context).pathParameters['id'] ?? '85cf7e85-ef80-4965-b778-4367cdfa741d';

    final restaurantAsync = ref.watch(restaurantDetailProvider(restaurantId));
    final menuAsync = ref.watch(menuControllerProvider(restaurantId));

    return restaurantAsync.when(
      data: (restaurant) => Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250.0,
              floating: false,
              pinned: true,
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: theme.colorScheme.surface,
                  child: BackButton(onPressed: () => context.pop(), color: theme.colorScheme.onSurface),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: theme.colorScheme.surface,
                    child: IconButton(icon: Icon(Icons.favorite_border, color: theme.colorScheme.primary), onPressed: () {}),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: theme.colorScheme.surface,
                    child: IconButton(icon: Icon(Icons.share, color: theme.colorScheme.onSurface), onPressed: () {}),
                  ),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  (restaurant.imageUrl != null && restaurant.imageUrl!.isNotEmpty) ? restaurant.imageUrl! : AppConstants.mockCafe,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.network(AppConstants.mockCafe, fit: BoxFit.cover),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(restaurant.name, style: theme.textTheme.headlineLarge),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text('Active', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onTertiaryContainer, fontSize: 12)),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star, size: 18, color: theme.colorScheme.tertiary),
                        const SizedBox(width: 4),
                        Text('4.8', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 4),
                        Text('(100+)', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        const SizedBox(width: 12),
                        Container(width: 4, height: 4, decoration: BoxDecoration(color: theme.colorScheme.outlineVariant, shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        const Icon(Icons.schedule, size: 18),
                        const SizedBox(width: 4),
                        Text('20-30 min', style: theme.textTheme.bodyMedium),
                        const SizedBox(width: 12),
                        Container(width: 4, height: 4, decoration: BoxDecoration(color: theme.colorScheme.outlineVariant, shape: BoxShape.circle)),
                        const SizedBox(width: 12),
                        Text('\$\$', style: theme.textTheme.bodyMedium),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${restaurant.cuisineType} • ${restaurant.address}',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    
                    // Tabs
                    Container(
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: theme.colorScheme.surfaceContainerHighest)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: theme.colorScheme.primary, width: 2))
                            ),
                            child: Text('Menu', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('Reviews', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text('Info', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _selectedCategory = null),
                            child: _buildFilterChip('All', _selectedCategory == null, theme),
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
                    
                    const SizedBox(height: 24),
                    Text(_selectedCategory?.label ?? 'Full Menu', style: theme.textTheme.headlineMedium),
                    const SizedBox(height: 16),
                    
                    // Menu Items
                    menuAsync.when(
                      data: (items) {
                        final filteredItems = _selectedCategory == null
                            ? items
                            : items.where((item) => item.category == _selectedCategory).toList();

                        if (filteredItems.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 32.0),
                            child: Center(child: Text('No items available in this category.')),
                          );
                        }

                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredItems.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return _MenuItemCard(
                              title: item.name,
                              description: item.description,
                              calories: item.calories ?? 0,
                              protein: '${item.proteinG?.toStringAsFixed(0) ?? "0"}g Protein',
                              price: item.price,
                              imageUrl: item.imageUrl != null && item.imageUrl!.isNotEmpty
                                  ? item.imageUrl!
                                  : AppConstants.mockCafe,
                              onAdd: () {
                                cartNotifier.addItem(
                                  CartItem(
                                    menuItemId: item.id,
                                    name: item.name,
                                    price: item.price,
                                    quantity: 1,
                                    calories: item.calories ?? 0,
                                    imageUrl: item.imageUrl != null && item.imageUrl!.isNotEmpty
                                        ? item.imageUrl!
                                        : AppConstants.mockCafe,
                                    restaurantId: restaurantId,
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Added ${item.name} to cart'), duration: const Duration(seconds: 1)),
                                );
                              },
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Error loading menu: $err')),
                    ),
                    
                    const SizedBox(height: 100), // Space for bottom cart
                  ],
                ),
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: cart.isEmpty
            ? null
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.go('/cart'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                              child: Text('${cart.fold(0, (sum, item) => sum + item.quantity)}'),
                            ),
                            const SizedBox(width: 8),
                            const Text('View Cart'),
                          ],
                        ),
                        Text('\$${cartNotifier.subtotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        appBar: AppBar(leading: BackButton(onPressed: () => context.pop())),
        body: Center(child: Text('Error loading restaurant: $err')),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isSelected ? Colors.transparent : theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant
        )
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final String title;
  final String description;
  final int calories;
  final String protein;
  final double price;
  final String imageUrl;
  final VoidCallback onAdd;

  const _MenuItemCard({
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
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 4))
        ],
        border: Border.all(color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5))
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_fire_department, size: 14),
                      const SizedBox(width: 4),
                      Text('$calories kcal | $protein', style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${price.toStringAsFixed(2)}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: onAdd,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.add, size: 18, color: theme.colorScheme.onPrimaryContainer),
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
