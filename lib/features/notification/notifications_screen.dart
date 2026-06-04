import 'package:flutter/material.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

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
              backgroundImage: const NetworkImage(AppConstants.mockUserAvatars),
              backgroundColor: theme.colorScheme.surfaceVariant,
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('Notifications', style: theme.textTheme.headlineLarge),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('Stay updated on your orders and offers.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          const SizedBox(height: 24),
          
          // Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _FilterTab(label: 'All', isSelected: true),
                const SizedBox(width: 8),
                _FilterTab(label: 'Orders', isSelected: false),
                const SizedBox(width: 8),
                _FilterTab(label: 'Promotions', isSelected: false),
                const SizedBox(width: 8),
                _FilterTab(label: 'AI Picks', icon: Icons.auto_awesome, isSelected: false),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Notifications List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _NotificationCard(
                  icon: Icons.local_shipping,
                  iconColor: theme.colorScheme.onPrimaryContainer,
                  iconBgColor: theme.colorScheme.primaryContainer,
                  title: 'Order Out for Delivery',
                  time: '2m ago',
                  description: 'Your order from \'The Burger Joint\' is on its way and should arrive in 15 mins.',
                  actionText: 'Track Order',
                  actionColor: theme.colorScheme.primary,
                  onAction: () => context.push('/track-order'),
                ),
                const SizedBox(height: 12),
                _NotificationCard(
                  icon: Icons.percent,
                  iconColor: theme.colorScheme.onSecondaryContainer,
                  iconBgColor: theme.colorScheme.secondaryContainer,
                  title: '20% Off Your Next Meal',
                  time: '1h ago',
                  description: 'Use code YUMMY20 at checkout for a tasty discount on healthy bowls.',
                  actionText: 'Claim Offer',
                  actionColor: theme.colorScheme.secondary,
                ),
                const SizedBox(height: 12),
                
                // AI Specially Formatted Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.surface, theme.colorScheme.surfaceContainerLow],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: theme.colorScheme.tertiaryFixedDim.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))
                    ]
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.tertiaryContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.psychology, color: theme.colorScheme.onTertiaryContainer),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('New meal match found!', style: theme.textTheme.labelMedium),
                                    const SizedBox(width: 4),
                                    Container(
                                      width: 8, height: 8,
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.tertiaryFixedDim,
                                        shape: BoxShape.circle,
                                      ),
                                    )
                                  ],
                                ),
                                Text('3h ago', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Based on your recent love for spicy vegan dishes, we think you\'ll crave this.',
                              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 12),
                            // Inner Bento Item
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: theme.colorScheme.surfaceVariant.withOpacity(0.5)),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Image.network(AppConstants.mockFood1, width: 64, height: 64, fit: BoxFit.cover),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Spicy Tofu Power Bowl', style: theme.textTheme.labelMedium),
                                        Text('Green Kitchen • \$14.50', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                
                // Old notification
                Opacity(
                  opacity: 0.75,
                  child: _NotificationCard(
                    icon: Icons.check_circle,
                    iconColor: theme.colorScheme.onSurfaceVariant,
                    iconBgColor: theme.colorScheme.surfaceVariant,
                    title: 'Order Delivered',
                    time: 'Yesterday',
                    description: 'Your order from \'Pizza Paradiso\' was delivered successfully.',
                  ),
                ),
                
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/for-you');
          if (index == 2) context.go('/cart');
          if (index == 4) context.go('/profile');
        }
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;

  const _FilterTab({required this.label, required this.isSelected, this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String time;
  final String description;
  final String? actionText;
  final Color? actionColor;
  final VoidCallback? onAction;

  const _NotificationCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.time,
    required this.description,
    this.actionText,
    this.actionColor,
    this.onAction,
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
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: theme.textTheme.labelMedium),
                    Text(time, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                if (actionText != null) ...[
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: onAction,
                    child: Text(
                      actionText!,
                      style: theme.textTheme.labelMedium?.copyWith(color: actionColor),
                    ),
                  )
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}
