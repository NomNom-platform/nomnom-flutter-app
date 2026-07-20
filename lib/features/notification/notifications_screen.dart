import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';
import 'data/models/notification_model.dart';
import 'presentation/controllers/notification_controller.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _selectedFilter = 'All';

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notificationsAsync = ref.watch(notificationControllerProvider);

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
      body: RefreshIndicator(
        onRefresh: () => ref.read(notificationControllerProvider.notifier).refresh(),
        child: Column(
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
                  _FilterTab(
                    label: 'All',
                    isSelected: _selectedFilter == 'All',
                    onTap: () => setState(() => _selectedFilter = 'All'),
                  ),
                  const SizedBox(width: 8),
                  _FilterTab(
                    label: 'Orders',
                    isSelected: _selectedFilter == 'Orders',
                    onTap: () => setState(() => _selectedFilter = 'Orders'),
                  ),
                  const SizedBox(width: 8),
                  _FilterTab(
                    label: 'Promotions',
                    isSelected: _selectedFilter == 'Promotions',
                    onTap: () => setState(() => _selectedFilter = 'Promotions'),
                  ),
                  const SizedBox(width: 8),
                  _FilterTab(
                    label: 'AI Picks',
                    icon: Icons.auto_awesome,
                    isSelected: _selectedFilter == 'AI Picks',
                    onTap: () => setState(() => _selectedFilter = 'AI Picks'),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Notifications List
            Expanded(
              child: notificationsAsync.when(
                data: (pageResponse) {
                  var list = pageResponse.content;
                  
                  // Filter content locally
                  if (_selectedFilter == 'Orders') {
                    list = list.where((n) => n.type.toUpperCase() == 'ORDER').toList();
                  } else if (_selectedFilter == 'Promotions') {
                    list = list.where((n) => n.type.toUpperCase() == 'PROMOTION').toList();
                  } else if (_selectedFilter == 'AI Picks') {
                    list = list.where((n) => n.type.toUpperCase() == 'AI_PICK').toList();
                  }

                  if (list.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.notifications_off_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5)),
                              const SizedBox(height: 16),
                              Text('No notifications', style: theme.textTheme.headlineMedium),
                              const SizedBox(height: 8),
                              Text('We will let you know when something arrives!', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: list.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = list[index];
                      
                      // Render card based on type
                      if (item.type.toUpperCase() == 'AI_PICK') {
                        return _buildAiPickCard(item, theme);
                      }

                      IconData icon = Icons.notifications;
                      Color iconColor = theme.colorScheme.onSurfaceVariant;
                      Color iconBgColor = theme.colorScheme.surfaceVariant;
                      String? actionText;
                      VoidCallback? onAction;

                      if (item.type.toUpperCase() == 'ORDER') {
                        icon = Icons.local_shipping;
                        iconColor = theme.colorScheme.onPrimaryContainer;
                        iconBgColor = theme.colorScheme.primaryContainer;
                        actionText = 'Track Order';
                        onAction = () => context.push('/track-order');
                      } else if (item.type.toUpperCase() == 'PROMOTION') {
                        icon = Icons.percent;
                        iconColor = theme.colorScheme.onSecondaryContainer;
                        iconBgColor = theme.colorScheme.secondaryContainer;
                        actionText = 'Claim Offer';
                      }

                      return InkWell(
                        onTap: () {
                          if (!item.isRead) {
                            ref.read(notificationControllerProvider.notifier).markAsRead(item.id);
                          }
                        },
                        child: Opacity(
                          opacity: item.isRead ? 0.75 : 1.0,
                          child: _NotificationCard(
                            icon: icon,
                            iconColor: iconColor,
                            iconBgColor: iconBgColor,
                            title: item.title,
                            time: _getTimeAgo(item.createdAt),
                            description: item.body,
                            actionText: actionText,
                            actionColor: item.type.toUpperCase() == 'ORDER'
                                ? theme.colorScheme.primary
                                : theme.colorScheme.secondary,
                            onAction: onAction,
                            isUnread: !item.isRead,
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 64, color: theme.colorScheme.error),
                          const SizedBox(height: 16),
                          Text('Failed to load notifications', style: theme.textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          Text('Please swipe down to try again.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
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

  Widget _buildAiPickCard(NotificationModel item, ThemeData theme) {
    return InkWell(
      onTap: () {
        if (!item.isRead) {
          ref.read(notificationControllerProvider.notifier).markAsRead(item.id);
        }
      },
      child: Opacity(
        opacity: item.isRead ? 0.75 : 1.0,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.colorScheme.surface, theme.colorScheme.surfaceContainerLow],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: item.isRead 
                  ? theme.colorScheme.outlineVariant.withOpacity(0.3)
                  : theme.colorScheme.tertiaryFixedDim.withOpacity(0.5),
              width: item.isRead ? 1 : 2,
            ),
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
                            Text(item.title, style: theme.textTheme.labelMedium),
                            if (!item.isRead) ...[
                              const SizedBox(width: 6),
                              Container(
                                width: 8, height: 8,
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.tertiaryFixedDim,
                                  shape: BoxShape.circle,
                                ),
                              )
                            ]
                          ],
                        ),
                        Text(_getTimeAgo(item.createdAt), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.body,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 12),
                    // Inner Bento Item Placeholder
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
                            child: Image.network(AppConstants.mockFood1, width: 48, height: 48, fit: BoxFit.cover),
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
      ),
    );
  }
}

class _FilterTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final IconData? icon;
  final VoidCallback onTap;

  const _FilterTab({required this.label, required this.isSelected, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
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
  final bool isUnread;

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
    required this.isUnread,
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
                    Row(
                      children: [
                        Text(title, style: theme.textTheme.labelMedium),
                        if (isUnread) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 6, height: 6,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          )
                        ]
                      ],
                    ),
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
