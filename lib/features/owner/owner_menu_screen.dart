import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/theme/colors.dart';
import '../auth/presentation/controllers/auth_controller.dart';
import '../menu/domain/entities/menu_category.dart';
import '../menu/domain/entities/menu_item.dart';
import '../menu/domain/entities/menu_item_input.dart';
import '../menu/presentation/controllers/menu_controller.dart';
import '../restaurant/domain/entities/restaurant.dart';
import '../restaurant/presentation/controllers/restaurant_controller.dart';

class OwnerMenuScreen extends ConsumerStatefulWidget {
  const OwnerMenuScreen({super.key});

  @override
  ConsumerState<OwnerMenuScreen> createState() => _OwnerMenuScreenState();
}

class _OwnerMenuScreenState extends ConsumerState<OwnerMenuScreen> {
  // null = "All"; otherwise filter by a single fixed category.
  MenuCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final restaurantAsync = ref.watch(restaurantControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildTopAppBar(),
      body: restaurantAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => _buildError(err.toString()),
        data: (restaurant) {
          if (restaurant == null) return _buildNoRestaurant();
          return _buildContent(restaurant);
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildContent(Restaurant restaurant) {
    final menuAsync = ref.watch(menuControllerProvider(restaurant.id));

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 768;

        return Stack(
          children: [
            Column(
              children: [
                _buildSearchBar(),
                _buildCategoryTabs(),
                Expanded(
                  child: menuAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => _buildError(err.toString()),
                    data: (items) {
                      final filtered = _selectedCategory == null
                          ? items
                          : items.where((i) => i.category == _selectedCategory!.apiValue).toList();
                      if (filtered.isEmpty) {
                        return _buildEmptyList();
                      }
                      return _buildMenuList(restaurant.id, filtered, isDesktop);
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                onPressed: () => _showItemForm(context, restaurant.id),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add, color: AppColors.onPrimary, size: 28),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNoRestaurant() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.storefront_outlined, size: 64, color: AppColors.outline),
            const SizedBox(height: 16),
            Text(
              'You have no restaurant yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your restaurant profile before adding menu items.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/owner/settings'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
              child: const Text('Go to settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.restaurant_menu, size: 48, color: AppColors.outline),
          const SizedBox(height: 12),
          Text('No menu items yet', style: TextStyle(color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center, style: TextStyle(color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: const Icon(Icons.restaurant, color: AppColors.primary, size: 24),
      title: Text(
        'NomNom',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.onSurfaceVariant),
          tooltip: 'Logout',
          onPressed: _confirmLogout,
        ),
      ],
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onError,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(authControllerProvider.notifier).logout();
    if (mounted) context.go('/login');
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.3)),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search menu items...',
            hintStyle: TextStyle(color: AppColors.outline),
            prefixIcon: Icon(Icons.search, color: AppColors.outline),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    // "All" plus the four fixed backend categories.
    final tabs = <_CategoryTab>[
      const _CategoryTab(null, 'All'),
      ...MenuCategory.values.map((c) => _CategoryTab(c, c.label)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 36,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: tabs.length,
          itemBuilder: (context, index) {
            final tab = tabs[index];
            final isSelected = _selectedCategory == tab.category;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => setState(() => _selectedCategory = tab.category),
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected ? Colors.transparent : AppColors.outlineVariant.withOpacity(0.3),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.15),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.05,
                      color: isSelected ? AppColors.onPrimary : AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard, 'Dashboard', false),
          _buildNavItem(Icons.menu_book, 'Menu', true),
          _buildNavItem(Icons.receipt_long, 'Orders', false),
          _buildNavItem(Icons.analytics, 'Analytics', false),
          _buildNavItem(Icons.settings, 'Settings', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {
        if (label == 'Menu') {
          // Already on menu page
        } else if (label == 'Settings') {
          context.go('/owner/settings');
        } else if (label == 'Dashboard') {
          context.go('/owner/dashboard');
        } else if (label == 'Orders') {
          context.go('/owner/orders');
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryContainer : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTab {
  final MenuCategory? category;
  final String label;
  const _CategoryTab(this.category, this.label);
}

final _menuImagePicker = ImagePicker();

String _mimeFromName(String name) {
  final lower = name.toLowerCase();
  if (lower.endsWith('.png')) return 'image/png';
  if (lower.endsWith('.webp')) return 'image/webp';
  if (lower.endsWith('.gif')) return 'image/gif';
  return 'image/jpeg';
}

/// Browses an image from the device and returns it as a base64 data URL —
/// same approach the `fe` frontend uses so the backend keeps storing
/// `imageUrl` as a plain string. Works on web and mobile. Returns null on
/// cancel; throws with a readable message on failure/too-large.
Future<String?> _pickMenuImage() async {
  final image = await _menuImagePicker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1920,
    maxHeight: 1080,
    imageQuality: 85,
  );
  if (image == null) return null;
  final bytes = await image.readAsBytes();
  if (bytes.length > 5 * 1024 * 1024) {
    throw 'Image is too large (over 5MB)';
  }
  final mime = _mimeFromName(image.name);
  return 'data:$mime;base64,${base64Encode(bytes)}';
}

extension _OwnerMenuActions on _OwnerMenuScreenState {
  Widget _buildMenuList(String restaurantId, List<MenuItem> items, bool isDesktop) {
    final useGrid = isDesktop || MediaQuery.of(context).orientation == Orientation.landscape;

    if (useGrid) {
      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => _menuCard(restaurantId, items[index]),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _menuCard(restaurantId, items[index]),
    );
  }

  Widget _menuCard(String restaurantId, MenuItem item) {
    final controller = ref.read(menuControllerProvider(restaurantId).notifier);
    return _MenuItemCard(
      item: item,
      onToggleAvailability: () async {
        try {
          await controller.toggleAvailability(item);
          if (!mounted) return;
          _snack(
            item.isAvailable ? '${item.name} is now hidden' : '${item.name} is now visible',
          );
        } catch (e) {
          if (mounted) _snack(e.toString(), isError: true);
        }
      },
      onEdit: () => _showItemForm(context, restaurantId, item: item),
      onDelete: () => _confirmDelete(restaurantId, item),
    );
  }

  Future<void> _confirmDelete(String restaurantId, MenuItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete item'),
        content: Text('Delete "${item.name}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: AppColors.onError,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(menuControllerProvider(restaurantId).notifier).remove(item.id);
      if (mounted) _snack('${item.name} deleted');
    } catch (e) {
      if (mounted) _snack(e.toString(), isError: true);
    }
  }

  void _snack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.secondary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showItemForm(BuildContext context, String restaurantId, {MenuItem? item}) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final descriptionController = TextEditingController(text: item?.description ?? '');
    final priceController = TextEditingController(text: item != null ? item.price.toStringAsFixed(2) : '');
    final imageUrlController = TextEditingController(text: item?.imageUrl ?? '');
    final caloriesController = TextEditingController(text: item != null ? item.calories.toString() : '');
    final proteinController = TextEditingController(text: item != null ? item.proteinG.toString() : '');
    final carbController = TextEditingController(text: item != null ? item.carbG.toString() : '');
    final fatController = TextEditingController(text: item != null ? item.fatG.toString() : '');
    var category = item != null ? MenuCategory.fromApi(item.category) : MenuCategory.main;
    var saving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 48,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      item == null ? 'Add menu item' : 'Edit menu item',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name', hintText: 'Garden Harvest Bowl'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: priceController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'Price (\$)'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<MenuCategory>(
                            value: category,
                            decoration: const InputDecoration(labelText: 'Category'),
                            items: MenuCategory.values
                                .map((c) => DropdownMenuItem(value: c, child: Text(c.label)))
                                .toList(),
                            onChanged: (value) {
                              if (value != null) setSheetState(() => category = value);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: caloriesController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Calories'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: proteinController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'Protein (g)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: carbController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'Carb (g)'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: fatController,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'Fat (g)'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        hintText: 'https://... or browse below',
                      ),
                      onChanged: (_) => setSheetState(() {}),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _MenuImagePreview(url: imageUrlController.text),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              try {
                                final dataUrl = await _pickMenuImage();
                                if (dataUrl != null) {
                                  setSheetState(() => imageUrlController.text = dataUrl);
                                }
                              } catch (e) {
                                if (context.mounted) _snack(e.toString(), isError: true);
                              }
                            },
                            icon: const Icon(Icons.photo_library_outlined),
                            label: const Text('Browse from device'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: saving
                          ? null
                          : () async {
                              if (nameController.text.trim().isEmpty || priceController.text.trim().isEmpty) {
                                _snack('Name and price are required', isError: true);
                                return;
                              }
                              setSheetState(() => saving = true);
                              final input = MenuItemInput(
                                name: nameController.text.trim(),
                                description: descriptionController.text.trim(),
                                price: double.tryParse(priceController.text.trim()) ?? 0,
                                calories: int.tryParse(caloriesController.text.trim()) ?? 0,
                                proteinG: double.tryParse(proteinController.text.trim()) ?? 0,
                                carbG: double.tryParse(carbController.text.trim()) ?? 0,
                                fatG: double.tryParse(fatController.text.trim()) ?? 0,
                                category: category.apiValue,
                                imageUrl: imageUrlController.text.trim(),
                                isAvailable: item?.isAvailable ?? true,
                              );
                              final controller = ref.read(menuControllerProvider(restaurantId).notifier);
                              try {
                                if (item == null) {
                                  await controller.create(input);
                                } else {
                                  await controller.edit(item.id, input);
                                }
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                                _snack(item == null ? 'Menu item added' : 'Menu item updated');
                              } catch (e) {
                                setSheetState(() => saving = false);
                                if (context.mounted) _snack(e.toString(), isError: true);
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                      ),
                      child: saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(item == null ? 'Add item' : 'Save changes'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onToggleAvailability;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MenuItemCard({
    required this.item,
    required this.onToggleAvailability,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: item.isAvailable ? 1.0 : 0.6,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColorFiltered(
                  colorFilter: item.isAvailable
                      ? const ColorFilter.mode(Colors.transparent, BlendMode.color)
                      : const ColorFilter.mode(Colors.grey, BlendMode.saturation),
                  child: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                      ? Image.network(
                          item.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.background,
                            child: const Icon(Icons.restaurant_menu, color: AppColors.outline),
                          ),
                        )
                      : Container(
                          color: AppColors.background,
                          child: const Icon(Icons.restaurant_menu, color: AppColors.outline),
                        ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '\$${item.price.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 6,
                    children: [
                      _badge(MenuCategory.fromApi(item.category).label),
                      _badge('${item.calories} kcal'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.edit, size: 18),
                              color: AppColors.onSecondaryContainer,
                              onPressed: onEdit,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.errorContainer.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.delete, size: 18),
                              color: AppColors.error,
                              onPressed: onDelete,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (!item.isAvailable)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Text('Hidden', style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant)),
                            ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Switch(
                              key: ValueKey(item.isAvailable),
                              value: item.isAvailable,
                              onChanged: (_) => onToggleAvailability(),
                              activeColor: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
    );
  }
}

/// Small square thumbnail for the item form. Renders a base64 data URL via
/// [Image.memory], an http(s) URL via [Image.network], or a placeholder.
class _MenuImagePreview extends StatelessWidget {
  final String url;
  const _MenuImagePreview({required this.url});

  @override
  Widget build(BuildContext context) {
    final trimmed = url.trim();
    Widget child;
    if (trimmed.startsWith('data:image')) {
      try {
        final base64Part = trimmed.substring(trimmed.indexOf(',') + 1);
        child = Image.memory(base64Decode(base64Part), fit: BoxFit.cover);
      } catch (_) {
        child = const Icon(Icons.broken_image, color: AppColors.outline);
      }
    } else if (trimmed.startsWith('http')) {
      child = Image.network(
        trimmed,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, color: AppColors.outline),
      );
    } else {
      child = const Icon(Icons.image_outlined, color: AppColors.outline);
    }

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.outlineVariant.withOpacity(0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Center(child: child),
    );
  }
}
