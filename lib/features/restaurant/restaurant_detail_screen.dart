import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import 'package:go_router/go_router.dart';
import '../cart/domain/entities/cart_item.dart';
import '../cart/presentation/controllers/cart_controller.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  const RestaurantDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartControllerProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);

    // Lấy restaurantId từ route parameter, mặc định dùng ID giả lập nếu không có
    final restaurantId = GoRouterState.of(context).pathParameters['id'] ?? '85cf7e85-ef80-4965-b778-4367cdfa741d';

    return Scaffold(
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
                AppConstants.mockCafe,
                fit: BoxFit.cover,
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
                      Text('The Green Kitchen', style: theme.textTheme.headlineLarge),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text('Open', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onTertiaryContainer, fontSize: 12)),
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
                        _buildFilterChip('Breakfast', true, theme),
                        const SizedBox(width: 8),
                        _buildFilterChip('Lunch', false, theme),
                        const SizedBox(width: 8),
                        _buildFilterChip('Sides', false, theme),
                        const SizedBox(width: 8),
                        _buildFilterChip('Drinks', false, theme),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  Text('Breakfast', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 16),
                  
                  // Menu Items
                  _MenuItemCard(
                    title: 'Avocado Toast',
                    description: 'Sourdough bread, smashed avocado, cherry tomatoes, radish...',
                    calories: 450,
                    protein: '15g Protein',
                    price: 12.00,
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDeIt0ybqWu2ouU9NRNoPIAwltpyuPPEk2pvxlp6NytfzagmHYeovcIRVgKU-SOmRbDEgEWt7cMN65mV_-Jei9USTxY9E0SH48PWVDy7IPRCuznjSzMeOsosZkYYwwIBwlfaxW14fCOmCw14lDN9Qyj9ffr3l0M65Po8foFspkp-gGhCrPJeWYmkSsNUbKbQVnVZMB9EY9YVmhM8L93XzOnRalr3pRt96Ir1EFkxJCK3tMQrWgofRvqd2XNrWVxcIaXUnoI7a2uFhbQ',
                    onAdd: () {
                      cartNotifier.addItem(
                        CartItem(
                          menuItemId: 'toast-1',
                          name: 'Avocado Toast',
                          price: 12.00,
                          quantity: 1,
                          calories: 450,
                          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDeIt0ybqWu2ouU9NRNoPIAwltpyuPPEk2pvxlp6NytfzagmHYeovcIRVgKU-SOmRbDEgEWt7cMN65mV_-Jei9USTxY9E0SH48PWVDy7IPRCuznjSzMeOsosZkYYwwIBwlfaxW14fCOmCw14lDN9Qyj9ffr3l0M65Po8foFspkp-gGhCrPJeWYmkSsNUbKbQVnVZMB9EY9YVmhM8L93XzOnRalr3pRt96Ir1EFkxJCK3tMQrWgofRvqd2XNrWVxcIaXUnoI7a2uFhbQ',
                          restaurantId: restaurantId,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added Avocado Toast to cart'), duration: Duration(seconds: 1)),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _MenuItemCard(
                    title: 'Acai Power Bowl',
                    description: 'Organic acai blend topped with house granola, fresh berries...',
                    calories: 320,
                    protein: '8g Protein',
                    price: 14.50,
                    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCxCHhfUbootqen9aQ7SV3K5HX1cRkM6uoVMSMEiFP7RO3o-jVSaH-Y5EMlfLfOroz3iDjXmAWhEpcuDcjS1KtujvpDSPPAJm5166cuFP7a-zhs0PePfWds4qghKkky0H6OXCARzgCDNncNkvI7XWSHHwRuWTu3kSuF6-8eRFgoOb8RMPI4d24-2_5XWsDXVyDH6sQ3Pnbym1CTtFiO4lgWUvbsFrE-UYtkn2uc3sQOCm6U71sZNbtqxJj6AY0V3i3VMJwoNTwbaWjd',
                    onAdd: () {
                      cartNotifier.addItem(
                        CartItem(
                          menuItemId: 'bowl-1',
                          name: 'Acai Power Bowl',
                          price: 14.50,
                          quantity: 1,
                          calories: 320,
                          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCxCHhfUbootqen9aQ7SV3K5HX1cRkM6uoVMSMEiFP7RO3o-jVSaH-Y5EMlfLfOroz3iDjXmAWhEpcuDcjS1KtujvpDSPPAJm5166cuFP7a-zhs0PePfWds4qghKkky0H6OXCARzgCDNncNkvI7XWSHHwRuWTu3kSuF6-8eRFgoOb8RMPI4d24-2_5XWsDXVyDH6sQ3Pnbym1CTtFiO4lgWUvbsFrE-UYtkn2uc3sQOCm6U71sZNbtqxJj6AY0V3i3VMJwoNTwbaWjd',
                          restaurantId: restaurantId,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added Acai Power Bowl to cart'), duration: Duration(seconds: 1)),
                      );
                    },
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
