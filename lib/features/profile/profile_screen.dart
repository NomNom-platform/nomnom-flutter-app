import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Profile', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24, color: theme.colorScheme.primary)),
        centerTitle: false,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: theme.colorScheme.primary),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Hero Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))
                ]
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.05),
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(120)),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: theme.colorScheme.surfaceVariant, width: 2),
                          image: const DecorationImage(
                            image: NetworkImage(AppConstants.mockUserAvatars),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Alex Johnson', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 24)),
                            Text('alex.j@example.com', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.star, size: 14, color: theme.colorScheme.onSecondaryContainer),
                                  const SizedBox(width: 4),
                                  Text('Premium Member', style: theme.textTheme.labelMedium?.copyWith(fontSize: 12, color: theme.colorScheme.onSecondaryContainer)),
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Health Goal Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.surface, theme.colorScheme.tertiaryFixed.withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.tertiaryFixedDim.withOpacity(0.5)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))
                ]
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.monitor_weight, color: theme.colorScheme.tertiaryContainer),
                      const SizedBox(width: 8),
                      Text('Current Goal', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.colorScheme.surfaceVariant.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Objective', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                              Text('Lose Weight', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18, color: theme.colorScheme.primary)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.colorScheme.surfaceVariant.withOpacity(0.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Current BMI', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text('22.4', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18)),
                                  const SizedBox(width: 4),
                                  Text('Healthy', style: theme.textTheme.labelMedium?.copyWith(fontSize: 12, color: theme.colorScheme.secondary)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.65,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.tertiaryContainer),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('65% to goal', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Settings List Grid
            _SettingsItem(
              icon: Icons.person,
              iconColor: theme.colorScheme.primary,
              iconBgColor: theme.colorScheme.primaryFixed.withOpacity(0.3),
              title: 'Personal Info',
              subtitle: 'Name, Phone, Password',
            ),
            const SizedBox(height: 16),
            _SettingsItem(
              icon: Icons.monitor_heart,
              iconColor: theme.colorScheme.secondary,
              iconBgColor: theme.colorScheme.secondaryFixed.withOpacity(0.3),
              title: 'Health Data',
              subtitle: 'Macros, Allergies, Preferences',
            ),
            const SizedBox(height: 16),
            _SettingsItem(
              icon: Icons.location_on,
              iconColor: theme.colorScheme.onSurfaceVariant,
              iconBgColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              title: 'Saved Addresses',
              subtitle: 'Home, Work, Other',
            ),
            const SizedBox(height: 16),
            _SettingsItem(
              icon: Icons.receipt_long,
              iconColor: theme.colorScheme.onSurfaceVariant,
              iconBgColor: theme.colorScheme.surfaceVariant.withOpacity(0.5),
              title: 'Order History',
              subtitle: 'Past meals and receipts',
            ),
            
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.go('/login');
                },
                icon: Icon(Icons.logout, color: theme.colorScheme.onErrorContainer),
                label: Text('Log Out', style: TextStyle(color: theme.colorScheme.onErrorContainer)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.errorContainer.withOpacity(0.3),
                  elevation: 0,
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/for-you');
          if (index == 2) context.go('/cart');
          if (index == 3) context.go('/inbox');
        }
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;

  const _SettingsItem({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
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
        children: [
          Container(
            width: 40,
            height: 40,
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
                Text(title, style: theme.textTheme.labelMedium),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}
