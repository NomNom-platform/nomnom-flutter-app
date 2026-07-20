import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import '../order/data/models/order_item_model.dart';
import '../order/data/models/order_request_model.dart';
import '../order/presentation/controllers/order_controller.dart';
import 'presentation/controllers/cart_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}


class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _selectedPayment = 2; // 0: VNPay, 1: Stripe, 2: Cash
  final TextEditingController _noteController = TextEditingController();
  final String _deliveryAddress = '123 Culinary Boulevard, Apt 4B, Foodville, CA 90210';
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _openPaymentWebView(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open VNPay payment gateway.')),
        );
      }
    }
  }

  Future<void> _handlePlaceOrder() async {
    final cart = ref.read(cartControllerProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your cart is empty.')),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    final orderItems = cart.map((item) {
      return OrderItemModel(
        menuItemId: item.menuItemId,
        name: item.name,
        quantity: item.quantity,
        unitPrice: item.price,
        calories: item.calories,
      );
    }).toList();

    final String paymentMethod;
    if (_selectedPayment == 0) {
      paymentMethod = 'VNPAY';
    } else if (_selectedPayment == 1) {
      paymentMethod = 'CARD';
    } else {
      paymentMethod = 'CASH';
    }

    final request = OrderRequestModel(
      restaurantId: cartNotifier.restaurantId ?? '',
      deliveryAddress: _deliveryAddress,
      paymentMethod: paymentMethod,
      note: _noteController.text,
      items: orderItems,
    );

    final response = await ref.read(orderControllerProvider.notifier).placeOrder(request);

    setState(() {
      _isPlacingOrder = false;
    });

    if (response != null) {
      // Clear the cart
      cartNotifier.clearCart();

      // Show success popup/snack
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order placed successfully!')),
        );
        
        if (paymentMethod == 'VNPAY' && response.paymentUrl != null && response.paymentUrl!.isNotEmpty) {
          await _openPaymentWebView(response.paymentUrl!);
        }
        
        // Go to order tracking
        context.go('/track-order');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to place order. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = ref.watch(cartControllerProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);

    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => context.pop()),
          title: const Text('Checkout'),
        ),
        body: const Center(
          child: Text('No items to check out.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Delivery to Home', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16)),
        centerTitle: true,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delivery Address
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.surfaceContainerLow),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))
                ]
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.home, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Home', style: theme.textTheme.labelMedium),
                            Text('Edit', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _deliveryAddress,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Payment Method', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.surfaceContainerLow),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))
                ]
              ),
              child: Column(
                children: [
                  _PaymentOption(
                    title: 'VNPay E-Wallet',
                    icon: Icons.qr_code_scanner,
                    iconColor: theme.colorScheme.secondary,
                    bgColor: theme.colorScheme.secondaryContainer.withOpacity(0.2),
                    isSelected: _selectedPayment == 0,
                    onTap: () => setState(() => _selectedPayment = 0),
                  ),
                  const Divider(height: 1),
                  _PaymentOption(
                    title: 'Credit/Debit Card (Stripe)',
                    icon: Icons.credit_card,
                    iconColor: theme.colorScheme.tertiary,
                    bgColor: theme.colorScheme.tertiaryContainer.withOpacity(0.2),
                    isSelected: _selectedPayment == 1,
                    onTap: () => setState(() => _selectedPayment = 1),
                  ),
                  const Divider(height: 1),
                  _PaymentOption(
                    title: 'Cash on Delivery',
                    icon: Icons.payments,
                    iconColor: theme.colorScheme.primary,
                    bgColor: theme.colorScheme.primaryContainer.withOpacity(0.2),
                    isSelected: _selectedPayment == 2,
                    onTap: () => setState(() => _selectedPayment = 2),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Delivery Note', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'e.g. Leave at door, ring bell...',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Icon(Icons.edit_note),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.surfaceContainerLow),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Order Summary', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cart.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return _SummaryItemRow(
                        quantity: '${item.quantity}x',
                        title: item.name,
                        price: '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(),
                  ),
                  _SummaryRow(label: 'Subtotal', value: '\$${cartNotifier.subtotal.toStringAsFixed(2)}', theme: theme),
                  const SizedBox(height: 8),
                  _SummaryRow(label: 'Delivery Fee', value: '\$${cartNotifier.deliveryFee.toStringAsFixed(2)}', theme: theme),
                  const SizedBox(height: 8),
                  _SummaryRow(label: 'Taxes & Fees (8%)', value: '\$${cartNotifier.tax.toStringAsFixed(2)}', theme: theme),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: theme.textTheme.labelMedium),
                      Text('\$${cartNotifier.total.toStringAsFixed(2)}', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18, color: theme.colorScheme.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120), // Space for sticky bottom CTA
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 30, offset: const Offset(0, -8))
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24))
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _isPlacingOrder ? null : _handlePlaceOrder,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_isPlacingOrder ? 'Placing Order...' : 'Place Order', style: const TextStyle(fontSize: 18)),
                if (!_isPlacingOrder)
                  Row(
                    children: [
                      Text('\$${cartNotifier.total.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, color: Colors.white70)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward, size: 16),
                      )
                    ],
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: isSelected ? theme.colorScheme.surfaceContainerLowest : Colors.transparent,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (_) => onTap(),
              activeColor: theme.colorScheme.primary,
            )
          ],
        ),
      ),
    );
  }
}

class _SummaryItemRow extends StatelessWidget {
  final String quantity;
  final String title;
  final String price;

  const _SummaryItemRow({required this.quantity, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            quantity,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
          ),
        ),
        Text(
          price,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _SummaryRow({required this.label, required this.value, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
