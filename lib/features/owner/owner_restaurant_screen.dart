import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../restaurant/domain/entities/restaurant.dart';
import '../restaurant/domain/entities/restaurant_input.dart';
import '../restaurant/presentation/controllers/restaurant_controller.dart';

class OwnerRestaurantScreen extends ConsumerStatefulWidget {
  const OwnerRestaurantScreen({super.key});

  @override
  ConsumerState<OwnerRestaurantScreen> createState() => _OwnerRestaurantScreenState();
}

class _OwnerRestaurantScreenState extends ConsumerState<OwnerRestaurantScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _cuisine = 'VIETNAMESE';

  bool _populated = false;
  bool _saving = false;

  // Common cuisine presets; the field is free-text on the backend, but chips
  // keep the original UX. A value loaded from the server that isn't in this
  // list is added on the fly so it stays selectable.
  final List<String> _cuisines = ['VIETNAMESE', 'ITALIAN', 'AMERICAN', 'JAPANESE', 'CAFE'];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _populate(Restaurant r) {
    _nameController.text = r.name;
    _descriptionController.text = r.description;
    _addressController.text = r.address;
    _phoneController.text = r.phone;
    _imageUrlController.text = r.imageUrl ?? '';
    if (r.cuisineType.isNotEmpty) {
      _cuisine = r.cuisineType;
      if (!_cuisines.contains(_cuisine)) _cuisines.insert(0, _cuisine);
    }
    _populated = true;
  }

  Future<void> _save(Restaurant? existing) async {
    if (_nameController.text.trim().isEmpty || _addressController.text.trim().isEmpty) {
      _snack('Restaurant name and address are required', isError: true);
      return;
    }
    setState(() => _saving = true);
    final input = RestaurantInput(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      phone: _phoneController.text.trim(),
      cuisineType: _cuisine,
      imageUrl: _imageUrlController.text.trim(),
    );
    try {
      await ref.read(restaurantControllerProvider.notifier).save(input);
      if (!mounted) return;
      _snack(existing == null ? 'Restaurant created' : 'Restaurant profile saved');
      context.pop();
    } catch (e) {
      if (mounted) _snack(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _snack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: isError ? Theme.of(context).colorScheme.error : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final restaurantAsync = ref.watch(restaurantControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Restaurant Profile', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
        backgroundColor: theme.colorScheme.surface,
        centerTitle: false,
      ),
      body: restaurantAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(err.toString(), textAlign: TextAlign.center),
          ),
        ),
        data: (restaurant) {
          if (restaurant != null && !_populated) _populate(restaurant);
          return _buildForm(theme, restaurant);
        },
      ),
    );
  }

  Widget _buildForm(ThemeData theme, Restaurant? restaurant) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Restaurant name', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Com Tam Suon Nuong',
                    prefixIcon: Icon(Icons.storefront_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Description', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: const InputDecoration(hintText: 'Quan com tam ngon o Q1'),
                ),
                const SizedBox(height: 16),
                Text('Address', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    hintText: '123 Nguyen Trai, Q1, TP.HCM',
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Phone', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    hintText: '0901234567',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Cuisine type', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _cuisines.map((c) {
                    final selected = c == _cuisine;
                    return ChoiceChip(
                      label: Text(c),
                      selected: selected,
                      onSelected: (_) => setState(() => _cuisine = c),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('Image URL', style: theme.textTheme.labelMedium),
                const SizedBox(height: 8),
                TextField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(hintText: 'https://...', prefixIcon: Icon(Icons.image_outlined)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _saving ? null : () => _save(restaurant),
            icon: _saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.save_outlined),
            label: Text(_saving
                ? 'Saving...'
                : (restaurant == null ? 'Create restaurant' : 'Save changes')),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
