import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/auth_controller.dart';
import '../../domain/entities/health_profile_input.dart';

class HealthProfileSetupScreen extends ConsumerStatefulWidget {
  const HealthProfileSetupScreen({super.key});

  @override
  ConsumerState<HealthProfileSetupScreen> createState() => _HealthProfileSetupScreenState();
}

class _HealthProfileSetupScreenState extends ConsumerState<HealthProfileSetupScreen> {
  int _selectedGoal = 0; // 0: Maintain, 1: Lose, 2: Gain
  String _gender = 'MALE';
  String _activityLevel = 'MODERATE';

  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _ageController = TextEditingController();

  static const _activityLevels = ['SEDENTARY', 'LIGHT', 'MODERATE', 'ACTIVE', 'VERY_ACTIVE'];

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // Instant client-side estimate shown before the authoritative value comes
  // back from `GET /api/users/me/health` after submit.
  double? get _liveBmi {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    if (height == null || weight == null || height <= 0) return null;
    final meters = height / 100;
    return weight / (meters * meters);
  }

  Future<void> _handleSubmit() async {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    final age = int.tryParse(_ageController.text);

    if (height == null || weight == null || age == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid height, weight and age.')),
      );
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).updateHealthProfile(
          HealthProfileInput(
            height: height,
            weight: weight,
            age: age,
            gender: _gender,
            activityLevel: _activityLevel,
          ),
        );

    if (!mounted) return;

    if (success) {
      context.go('/home');
    } else {
      final failure = ref.read(authControllerProvider).failure;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failure?.message ?? 'Could not save your health profile.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final bmi = _liveBmi;

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

            // Body Metrics Card
            _buildGoalCard(
              title: 'Body Metrics',
              theme: theme,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _heightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(labelText: 'Height (cm)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(labelText: 'Weight (kg)'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Age'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _gender,
                          decoration: const InputDecoration(labelText: 'Gender'),
                          items: const [
                            DropdownMenuItem(value: 'MALE', child: Text('Male')),
                            DropdownMenuItem(value: 'FEMALE', child: Text('Female')),
                          ],
                          onChanged: (value) => setState(() => _gender = value ?? _gender),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Activity Level Card
            _buildGoalCard(
              title: 'Activity Level',
              theme: theme,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _activityLevels.map((level) {
                  return ChoiceChip(
                    label: Text(level.replaceAll('_', ' ')),
                    selected: _activityLevel == level,
                    onSelected: (_) => setState(() => _activityLevel = level),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

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
                          bmi != null ? 'BMI: ${bmi.toStringAsFixed(1)}' : 'Enter height & weight to see BMI',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onTertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'TDEE will be calculated after you continue',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onTertiary,
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
            onPressed: authState.isLoading ? null : _handleSubmit,
            child: authState.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Row(
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
