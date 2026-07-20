import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go('/profile')),
        title: Text('Owner Dashboard', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
        backgroundColor: theme.colorScheme.surface,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _StatCard(label: 'Today\'s Orders', value: '18', icon: Icons.receipt_long, color: theme.colorScheme.primary)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'Revenue', value: '2.4M đ', icon: Icons.payments_outlined, color: theme.colorScheme.secondary)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _StatCard(label: 'Menu Items', value: '24', icon: Icons.restaurant_menu, color: theme.colorScheme.tertiaryContainer)),
                const SizedBox(width: 12),
                Expanded(child: _StatCard(label: 'Rating', value: '4.7', icon: Icons.star, color: theme.colorScheme.tertiaryContainer)),
              ],
            ),
            const SizedBox(height: 24),
            Text('Manage', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            _ManageTile(
              icon: Icons.storefront,
              title: 'Restaurant Profile',
              subtitle: 'Info, address, operating hours',
              onTap: () => context.push('/owner/restaurant'),
            ),
            const SizedBox(height: 12),
            _ManageTile(
              icon: Icons.restaurant_menu,
              title: 'Menu Management',
              subtitle: 'Add, edit, remove menu items',
              onTap: () => context.push('/owner/menu'),
            ),
            const SizedBox(height: 12),
            _ManageTile(
              icon: Icons.list_alt,
              title: 'Incoming Orders',
              subtitle: 'Confirm and update order status',
              onTap: () => context.push('/owner/orders'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(value, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22)),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _ManageTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ManageTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryFixed.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
