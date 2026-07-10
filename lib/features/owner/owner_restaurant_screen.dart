import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OwnerRestaurantScreen extends StatefulWidget {
  const OwnerRestaurantScreen({super.key});

  @override
  State<OwnerRestaurantScreen> createState() => _OwnerRestaurantScreenState();
}

class _OwnerRestaurantScreenState extends State<OwnerRestaurantScreen> {
  String _cuisine = 'VIETNAMESE';

  static const _cuisines = ['VIETNAMESE', 'ITALIAN', 'AMERICAN', 'JAPANESE', 'CAFE'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Restaurant Profile', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
        backgroundColor: theme.colorScheme.surface,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Restaurant name', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(hintText: 'Com Tam Suon Nuong', prefixIcon: Icon(Icons.storefront_outlined)),
                  ),
                  const SizedBox(height: 16),
                  Text('Description', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  const TextField(
                    maxLines: 3,
                    decoration: InputDecoration(hintText: 'Quan com tam ngon o Q1'),
                  ),
                  const SizedBox(height: 16),
                  Text('Address', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(hintText: '123 Nguyen Trai, Q1, TP.HCM', prefixIcon: Icon(Icons.location_on_outlined)),
                  ),
                  const SizedBox(height: 16),
                  Text('Phone', style: theme.textTheme.labelMedium),
                  const SizedBox(height: 8),
                  const TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: '0901234567', prefixIcon: Icon(Icons.phone_outlined)),
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
                  const TextField(
                    decoration: InputDecoration(hintText: 'https://...', prefixIcon: Icon(Icons.image_outlined)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
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
                  Text('Operating hours', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 16)),
                  const SizedBox(height: 12),
                  ...const [
                    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
                  ].map((day) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            SizedBox(width: 90, child: Text(day, style: theme.textTheme.bodyMedium)),
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(hintText: '08:00', isDense: true),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('—'),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(hintText: '21:00', isDense: true),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Restaurant profile saved')),
                );
                context.pop();
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save changes'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
