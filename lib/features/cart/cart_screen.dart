import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';
import 'presentation/controllers/cart_controller.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartControllerProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text('Delivery to Home', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16, color: theme.colorScheme.primary)),
          ],
        ),
        backgroundColor: theme.colorScheme.surface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: const NetworkImage(AppConstants.mockUserAvatars),
              backgroundColor: theme.colorScheme.surfaceVariant,
              radius: 16,
            ),
          )
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text('Your cart is empty', style: theme.textTheme.headlineMedium),
                  const SizedBox(height: 8),
                  Text('Add items from a restaurant to start ordering!', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Explore Restaurants'),
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
                        Text('My Cart', style: theme.textTheme.displayLarge?.copyWith(fontSize: 32)),
                        const SizedBox(height: 24),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cart.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final item = cart[index];
                            return _CartItem(
                              title: item.name,
                              subtitle: '${item.calories} kcal',
                              price: '\$${item.price.toStringAsFixed(2)}',
                              quantity: item.quantity,
                              imageUrl: item.imageUrl,
                              onRemove: () => cartNotifier.removeItem(item.menuItemId),
                              onIncrement: () => cartNotifier.updateQuantity(item.menuItemId, item.quantity + 1),
                              onDecrement: () => cartNotifier.updateQuantity(item.menuItemId, item.quantity - 1),
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
                      BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, -8))
                    ],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Order Summary', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
                      const SizedBox(height: 16),
                      _SummaryRow(label: 'Subtotal', value: '\$${cartNotifier.subtotal.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _SummaryRow(label: 'Delivery Fee', value: '\$${cartNotifier.deliveryFee.toStringAsFixed(2)}'),
                      const SizedBox(height: 8),
                      _SummaryRow(label: 'Taxes & Fees (8%)', value: '\$${cartNotifier.tax.toStringAsFixed(2)}'),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
                          Text('\$${cartNotifier.total.toStringAsFixed(2)}', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20, color: theme.colorScheme.primary)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context.push('/cart/checkout');
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Proceed to Checkout'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))
        ]
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(title, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18))),
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: theme.colorScheme.surfaceVariant),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: onDecrement,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.remove, size: 20, color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('$quantity', style: theme.textTheme.labelMedium),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: onIncrement,
                            child: const Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(Icons.add, size: 20),
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
        Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
