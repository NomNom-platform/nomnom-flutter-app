import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HealthProfileSetupScreen extends StatefulWidget {
  const HealthProfileSetupScreen({super.key});

  @override
  State<HealthProfileSetupScreen> createState() => _HealthProfileSetupScreenState();
}

class _HealthProfileSetupScreenState extends State<HealthProfileSetupScreen> {
  int _selectedGoal = 0; // 0: Maintain, 1: Lose, 2: Gain

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Profile Setup',
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Let\'s customize your experience to help you reach your goals.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            
            // Goal Selection Card
            _buildGoalCard(
              title: 'Primary Goal',
              theme: theme,
              child: Column(
                children: [
                  _GoalOption(
                    title: 'Maintain weight',
                    subtitle: 'Stay healthy and balanced',
                    isSelected: _selectedGoal == 0,
                    onTap: () => setState(() => _selectedGoal = 0),
                  ),
                  const SizedBox(height: 12),
                  _GoalOption(
                    title: 'Lose weight',
                    subtitle: 'Burn fat effectively',
                    isSelected: _selectedGoal == 1,
                    onTap: () => setState(() => _selectedGoal = 1),
                  ),
                  const SizedBox(height: 12),
                  _GoalOption(
                    title: 'Gain muscle',
                    subtitle: 'Build strength and size',
                    isSelected: _selectedGoal == 2,
                    onTap: () => setState(() => _selectedGoal = 2),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Live Estimate Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [theme.colorScheme.tertiary, theme.colorScheme.tertiaryContainer],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LIVE ESTIMATE',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.onTertiary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'BMI: 22.4 (Normal)',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onTertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'TDEE: 2,150 kcal/day',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onTertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ElevatedButton(
            onPressed: () {
              context.go('/home');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Calculate & Continue'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard({required String title, required ThemeData theme, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.labelMedium),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _GoalOption({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primaryContainer.withOpacity(0.1) : theme.colorScheme.surface,
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surfaceVariant,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : null,
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
            )
          ],
        ),
      ),
    );
  }
}
