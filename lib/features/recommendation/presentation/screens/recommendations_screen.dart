import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/bottom_nav_bar.dart';
import '../../domain/entities/meal_type.dart';
import '../../domain/entities/recommended_item.dart';
import '../controllers/recommendation_controller.dart';

class RecommendationsScreen extends ConsumerStatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  ConsumerState<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends ConsumerState<RecommendationsScreen> {
  final _restaurantIdController = TextEditingController();
  MealType _mealType = MealType.lunch;
  bool _useAi = true;

  @override
  void dispose() {
    _restaurantIdController.dispose();
    super.dispose();
  }

  Future<void> _handleGenerate() async {
    final restaurantId = _restaurantIdController.text.trim();
    if (restaurantId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a restaurant ID.')),
      );
      return;
    }
    await ref.read(recommendationControllerProvider.notifier).generate(
          restaurantId: restaurantId,
          mealType: _mealType,
          useAi: _useAi,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(recommendationControllerProvider);

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
                  Text('Find meals that match your goals', style: theme.textTheme.headlineLarge),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Query form
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Restaurant ID', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _restaurantIdController,
                    decoration: const InputDecoration(
                      hintText: 'Paste a restaurant UUID',
                      prefixIcon: Icon(Icons.storefront_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Meal type', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: MealType.values.map((meal) {
                      return ChoiceChip(
                        label: Text(meal.label),
                        selected: _mealType == meal,
                        onSelected: (_) => setState(() => _mealType = meal),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _useAi,
                    onChanged: (value) => setState(() => _useAi = value),
                    title: const Text('Use AI ranking'),
                    subtitle: const Text('Personalized explanation for each pick'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: state.isLoading ? null : _handleGenerate,
                    child: state.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('Get recommendations'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (state.failure != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  state.failure!.message,
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onErrorContainer),
                ),
              ),

            if (state.result != null) ...[
              if (state.result!.usedAi && (state.result!.aiExplanation?.isNotEmpty ?? false))
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiaryFixed.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.lightbulb, color: theme.colorScheme.tertiary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.result!.aiExplanation!,
                          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ),
              if (state.result!.items.isEmpty)
                Text('No matching items found for this restaurant.', style: theme.textTheme.bodyMedium)
              else
                ...state.result!.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _RecommendedItemCard(item: item),
                    )),
            ],

            const SizedBox(height: 8),
            Text('Recent recommendations', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            const _HistoryList(),
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
        },
      ),
    );
  }
}

class _RecommendedItemCard extends StatelessWidget {
  final RecommendedItem item;

  const _RecommendedItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.surfaceContainerHigh),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(item.name, style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20))),
              Text('${item.price.toStringAsFixed(0)}đ', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if (item.calories != null) _MacroBadge(text: '${item.calories} kcal'),
              if (item.proteinG != null) _MacroBadge(text: '${item.proteinG!.toStringAsFixed(0)}g Protein'),
              if (item.carbG != null) _MacroBadge(text: '${item.carbG!.toStringAsFixed(0)}g Carb'),
              if (item.fatG != null) _MacroBadge(text: '${item.fatG!.toStringAsFixed(0)}g Fat'),
            ],
          ),
          if (item.reason.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lightbulb, color: theme.colorScheme.tertiary, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(item.reason, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ),
              ],
            ),
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

class _HistoryList extends ConsumerWidget {
  const _HistoryList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final historyAsync = ref.watch(recommendationHistoryProvider);

    return historyAsync.when(
      data: (page) {
        if (page.content.isEmpty) {
          return Text('No recommendation history yet.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant));
        }
        return Column(
          children: page.content.map((log) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  Icon(log.usedAi ? Icons.auto_awesome : Icons.restaurant_menu, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${log.mealType} • ${log.recommendedItemIds.length} item(s)', style: theme.textTheme.labelMedium),
                        Text(
                          '${log.createdAt.toLocal()}'.split('.').first,
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator())),
      error: (error, _) => Text(
        'Could not load history.',
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}
