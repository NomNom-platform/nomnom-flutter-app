import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            const Icon(Icons.expand_more, size: 20),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0,2))
                ]
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search restaurants or dishes',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  icon: Icon(Icons.search),
                  filled: false,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Categories
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _CategoryChip(icon: Icons.local_pizza_outlined, label: 'Pizza'),
                  _CategoryChip(icon: Icons.lunch_dining_outlined, label: 'Burger'),
                  _CategoryChip(icon: Icons.eco_outlined, label: 'Salad'),
                  _CategoryChip(icon: Icons.set_meal_outlined, label: 'Sushi'),
                  _CategoryChip(icon: Icons.spa_outlined, label: 'Healthy'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            // AI Banner
            GestureDetector(
              onTap: () => context.push('/for-you'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [theme.colorScheme.tertiaryContainer, theme.colorScheme.tertiary],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Find meals for your goal', style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.onTertiaryContainer, fontSize: 18)),
                          Text('Let AI curate your perfect menu.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onTertiaryContainer.withOpacity(0.8))),
                        ],
                      ),
                    ),
                    const CircleAvatar(
                      backgroundColor: Colors.black26,
                      child: Icon(Icons.auto_awesome, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text('AI Recommended for You', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _FoodCard(title: 'Green Power Bowl', subtitle: 'The Salad Studio • 15-25 min', imageUrl: AppConstants.mockFood1, matchScore: '98% Match'),
                  _FoodCard(title: 'Lemon Herb Salmon', subtitle: 'Ocean Grill • 30-40 min', imageUrl: AppConstants.mockFood2, matchScore: '95% Match'),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Nearby Restaurants', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
            const SizedBox(height: 16),
            _RestaurantCard(
              title: 'Artisan Pizza Co.',
              subtitle: 'Italian • Pizza • \$\$',
              rating: '4.8',
              time: '20-30 min',
              imageUrl: AppConstants.mockPizza,
              onTap: () => context.push('/restaurant/1'),
            ),
            const SizedBox(height: 16),
            _RestaurantCard(
              title: 'Burger Joint',
              subtitle: 'American • Burgers • \$',
              rating: '4.6',
              time: '15-25 min',
              imageUrl: AppConstants.mockBurger,
              onTap: () => context.push('/restaurant/2'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) context.go('/for-you');
          if (index == 2) context.go('/cart');
          if (index == 3) context.go('/inbox');
          if (index == 4) context.go('/profile');
        }
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 8),
          Text(label, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String matchScore;

  const _FoodCard({required this.title, required this.subtitle, required this.imageUrl, required this.matchScore});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.surfaceVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(imageUrl, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.bolt, size: 12, color: theme.colorScheme.onTertiary),
                        const SizedBox(width: 4),
                        Text(matchScore, style: theme.textTheme.labelMedium?.copyWith(fontSize: 10, color: theme.colorScheme.onTertiary)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.labelMedium),
          Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _RestaurantCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String rating;
  final String time;
  final String imageUrl;
  final VoidCallback onTap;

  const _RestaurantCard({required this.title, required this.subtitle, required this.rating, required this.time, required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
          ]
        ),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(imageUrl, height: 140, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(time, style: theme.textTheme.labelMedium?.copyWith(fontSize: 12)),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHigh,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 14, color: theme.colorScheme.tertiaryContainer),
                        const SizedBox(width: 4),
                        Text(rating, style: theme.textTheme.labelMedium?.copyWith(fontSize: 12)),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
