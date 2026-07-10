import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_constants.dart';

class _MenuItem {
  final String name;
  final String imageUrl;
  final double price;
  final String category;
  final bool available;

  const _MenuItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.category,
    this.available = true,
  });
}

class OwnerMenuScreen extends StatefulWidget {
  const OwnerMenuScreen({super.key});

  @override
  State<OwnerMenuScreen> createState() => _OwnerMenuScreenState();
}

class _OwnerMenuScreenState extends State<OwnerMenuScreen> {
  final List<_MenuItem> _items = const [
    _MenuItem(name: 'Com Tam Suon Bi Cha', imageUrl: AppConstants.mockFood1, price: 55000, category: 'MAIN'),
    _MenuItem(name: 'Pho Bo Tai', imageUrl: AppConstants.mockFood2, price: 45000, category: 'MAIN'),
    _MenuItem(name: 'Pizza Margherita', imageUrl: AppConstants.mockPizza, price: 120000, category: 'MAIN', available: false),
    _MenuItem(name: 'Cheese Burger', imageUrl: AppConstants.mockBurger, price: 65000, category: 'MAIN'),
  ].toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text('Menu Management', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 20)),
        backgroundColor: theme.colorScheme.surface,
        centerTitle: false,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showItemForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        itemCount: _items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = _items[index];
          return _MenuItemCard(
            item: item,
            onEdit: () => _showItemForm(context, item: item),
            onDelete: () => setState(() => _items.removeAt(index)),
          );
        },
      ),
    );
  }

  void _showItemForm(BuildContext context, {_MenuItem? item}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(width: 48, height: 6, decoration: BoxDecoration(color: theme.colorScheme.surfaceVariant, borderRadius: BorderRadius.circular(4))),
                ),
                const SizedBox(height: 16),
                Text(item == null ? 'Add menu item' : 'Edit menu item', style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18)),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: item?.name,
                  decoration: const InputDecoration(labelText: 'Name', hintText: 'Com Tam Suon Bi Cha'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: item?.price.toStringAsFixed(0),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Price (đ)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Calories'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Protein (g)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Carb (g)'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(labelText: 'Fat (g)'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  initialValue: item?.imageUrl,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(item == null ? 'Menu item added' : 'Menu item updated')),
                    );
                  },
                  child: Text(item == null ? 'Add item' : 'Save changes'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final _MenuItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MenuItemCard({required this.item, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Opacity(
              opacity: item.available ? 1.0 : 0.4,
              child: Image.network(item.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text('${item.category} • ${item.price.toStringAsFixed(0)}đ', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                if (!item.available)
                  Text('Unavailable', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.edit_outlined), onPressed: onEdit),
          IconButton(icon: Icon(Icons.delete_outline, color: theme.colorScheme.error), onPressed: onDelete),
        ],
      ),
    );
  }
}
