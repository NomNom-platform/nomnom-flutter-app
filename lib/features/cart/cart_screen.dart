import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
              backgroundColor: theme.colorScheme.surfaceVariant,
              child: Icon(Icons.person, color: theme.colorScheme.onSurfaceVariant),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Cart', style: theme.textTheme.displayLarge?.copyWith(fontSize: 32)),
                  const SizedBox(height: 24),
                  
                  // Cart Item 1
                  _CartItem(
                    title: 'Truffle Mushroom Burger',
                    subtitle: 'Medium Rare, No Onions',
                    price: '\$16.50',
                    quantity: 1,
                    imageUrl: AppConstants.mockBurger,
                  ),
                  const SizedBox(height: 16),
                  
                  // Cart Item 2
                  _CartItem(
                    title: 'Sweet Potato Fries',
                    subtitle: 'Side of Garlic Aioli',
                    price: '\$5.00',
                    quantity: 2,
                    imageUrl: AppConstants.mockFood2, // Replace with fries if available, using this as placeholder
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
                _SummaryRow(label: 'Subtotal', value: '\$26.50'),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Delivery Fee', value: '\$3.99'),
                const SizedBox(height: 8),
                _SummaryRow(label: 'Taxes & Fees', value: '\$2.40'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
                    Text('\$32.89', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
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

  const _CartItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.quantity,
    required this.imageUrl,
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
                    Icon(Icons.close, color: theme.colorScheme.onSurfaceVariant),
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
                          Icon(Icons.remove, size: 20, color: theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 12),
                          Text('$quantity', style: theme.textTheme.labelMedium),
                          const SizedBox(width: 12),
                          const Icon(Icons.add, size: 20),
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
