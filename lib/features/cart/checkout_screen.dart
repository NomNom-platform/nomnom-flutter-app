import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/currency_formatter.dart';
import '../../shared/widgets/user_avatar.dart';
import '../order/data/models/order_item_request_model.dart';
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
  final TextEditingController _addressController = TextEditingController();
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _noteController.dispose();
    _addressController.dispose();
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
          const SnackBar(content: Text('Không thể mở cổng thanh toán VNPay.')),
        );
      }
    }
  }

  Future<void> _handlePlaceOrder() async {
    final cart = ref.read(cartControllerProvider);
    final cartNotifier = ref.read(cartControllerProvider.notifier);

    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giỏ hàng trống.')),
      );
      return;
    }

    setState(() {
      _isPlacingOrder = true;
    });

    final orderItems = cart.map((item) {
      return OrderItemRequestModel(
        menuItemId: item.menuItemId,
        quantity: item.quantity,
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
      deliveryAddress: _addressController.text.trim().isEmpty ? 'Địa chỉ chưa điền' : _addressController.text.trim(),
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
          const SnackBar(
            content: Text('Đặt đơn hàng thành công!'),
            behavior: SnackBarBehavior.floating,
          ),
        );
        
        if (paymentMethod == 'VNPAY' && response.paymentUrl != null && response.paymentUrl!.isNotEmpty) {
          await _openPaymentWebView(response.paymentUrl!);
        }
        
        // Go to order tracking
        context.go('/track-order/${response.order.id}');
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Không thể đặt hàng. Vui lòng thử lại.')),
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
          title: const Text('Thanh toán'),
        ),
        body: const Center(
          child: Text('Không có sản phẩm nào cần thanh toán.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Xác nhận đặt hàng', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
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
            // Địa chỉ nhận hàng
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4))
                ]
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.home_rounded, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Nhà riêng', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                            GestureDetector(
                              onTap: () => _addressController.clear(),
                              child: Text('Xóa', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        TextField(
                          controller: _addressController,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          decoration: InputDecoration(
                            hintText: 'Nhập địa chỉ giao hàng của bạn...',
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Text(
              'Phương thức thanh toán', 
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Lựa chọn cổng thanh toán cao cấp
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4))
                ]
              ),
              child: Column(
                children: [
                  _PaymentOption(
                    title: 'Ví điện tử VNPay (Sandbox)',
                    icon: Icons.qr_code_scanner_rounded,
                    iconColor: theme.colorScheme.secondary,
                    bgColor: theme.colorScheme.secondaryContainer.withValues(alpha: 0.2),
                    isSelected: _selectedPayment == 0,
                    onTap: () => setState(() => _selectedPayment = 0),
                  ),
                  const Divider(height: 1),
                  _PaymentOption(
                    title: 'Thẻ tín dụng / Thẻ ghi nợ (Stripe)',
                    icon: Icons.credit_card_rounded,
                    iconColor: theme.colorScheme.tertiary,
                    bgColor: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.2),
                    isSelected: _selectedPayment == 1,
                    onTap: () => setState(() => _selectedPayment = 1),
                  ),
                  const Divider(height: 1),
                  _PaymentOption(
                    title: 'Thanh toán tiền mặt khi nhận hàng (COD)',
                    icon: Icons.payments_rounded,
                    iconColor: theme.colorScheme.primary,
                    bgColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                    isSelected: _selectedPayment == 2,
                    onTap: () => setState(() => _selectedPayment = 2),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Text(
              'Ghi chú giao hàng', 
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Ví dụ: Để trước cửa, bấm chuông khi tới...',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Icon(Icons.edit_note_rounded),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            ),
            
            const SizedBox(height: 24),
            // Tóm tắt đơn đặt hàng
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 16, offset: const Offset(0, 4))
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tóm tắt đơn hàng', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
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
                        price: formatPrice(item.price * item.quantity),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.0),
                    child: Divider(),
                  ),
                  _SummaryRow(label: 'Tạm tính', value: formatPrice(cartNotifier.subtotal), theme: theme),
                  const SizedBox(height: 8),
                  _SummaryRow(label: 'Phí giao hàng', value: formatPrice(cartNotifier.deliveryFee), theme: theme),
                  const SizedBox(height: 8),
                  _SummaryRow(label: 'Thuế & phí (8%)', value: formatPrice(cartNotifier.tax), theme: theme),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tổng tiền', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Text(
                        formatPrice(cartNotifier.total),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontSize: 18, 
                          fontWeight: FontWeight.w800, 
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 120), // Khoảng trống cho thanh đặt hàng dưới cùng
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 24, offset: const Offset(0, -8))
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3))),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _isPlacingOrder ? null : _handlePlaceOrder,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_isPlacingOrder ? 'Đang đặt đơn hàng...' : 'Đặt đơn ngay', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (!_isPlacingOrder)
                    Row(
                      children: [
                        Text(formatPrice(cartNotifier.total), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.white24,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.arrow_forward_rounded, size: 14),
                        )
                      ],
                    )
                ],
              ),
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
        color: isSelected ? theme.colorScheme.primaryContainer.withValues(alpha: 0.05) : Colors.transparent,
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
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
            color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            quantity,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
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
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w600),
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
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
        Text(value, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
