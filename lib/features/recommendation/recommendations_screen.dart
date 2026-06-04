import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/widgets/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

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
          children: [
            // AI Curated Banner
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.tertiaryFixed, theme.colorScheme.surfaceContainerLowest],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.colorScheme.surfaceVariant.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_awesome, color: theme.colorScheme.tertiary, size: 20),
                            const SizedBox(width: 8),
                            Text('AI CURATED', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onTertiaryContainer, letterSpacing: 1.1)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Find meals that match your goals',
                          style: theme.textTheme.headlineLarge,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _FilterChip(label: 'Meal type', icon: Icons.arrow_drop_down, isSelected: false),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Lose weight', icon: Icons.check, isSelected: true),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Preference', icon: Icons.arrow_drop_down, isSelected: false),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Result Card
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.colorScheme.surfaceContainerHigh),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))
                ]
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                        child: Image.network(
                          AppConstants.mockFood2,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiaryContainer.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome, size: 14, color: theme.colorScheme.onTertiaryContainer),
                              const SizedBox(width: 4),
                              Text('98% Match', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onTertiaryContainer)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Grilled Salmon Bowl', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 22)),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceContainerLow,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.favorite_border, color: theme.colorScheme.onSurfaceVariant),
                            )
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            _MacroBadge(text: '520 kcal'),
                            const SizedBox(width: 8),
                            _MacroBadge(text: '40g Protein'),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.lightbulb, color: theme.colorScheme.tertiary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'High protein and within your calorie target for weight loss.',
                                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                              ),
                            )
                          ],
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 2) context.go('/cart');
          if (index == 3) context.go('/inbox');
          if (index == 4) context.go('/profile');
        }
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;

  const _FilterChip({required this.label, required this.icon, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? theme.colorScheme.primaryContainer : theme.colorScheme.outlineVariant.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected) ...[
            Icon(icon, size: 18, color: theme.colorScheme.onPrimaryContainer),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
            ),
          ),
          if (!isSelected) ...[
            const SizedBox(width: 8),
            Icon(icon, size: 18, color: theme.colorScheme.onSurface),
          ],
        ],
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  final String text;

  const _MacroBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: Theme.of(context).colorScheme.surfaceVariant),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
    );
  }
}
