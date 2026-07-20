import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/theme/colors.dart';
import '../restaurant/domain/entities/restaurant.dart';
import '../restaurant/domain/entities/restaurant_input.dart';
import '../restaurant/presentation/controllers/restaurant_controller.dart';

class OwnerSettingsScreen extends ConsumerStatefulWidget {
  const OwnerSettingsScreen({super.key});

  @override
  ConsumerState<OwnerSettingsScreen> createState() => _OwnerSettingsScreenState();
}

class _OwnerSettingsScreenState extends ConsumerState<OwnerSettingsScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cuisineController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  bool _populated = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _cuisineController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _populate(Restaurant restaurant) {
    _nameController.text = restaurant.name;
    _descriptionController.text = restaurant.description;
    _addressController.text = restaurant.address;
    _phoneController.text = restaurant.phone;
    _cuisineController.text = restaurant.cuisineType;
    _imageUrlController.text = restaurant.imageUrl ?? '';
    _populated = true;
  }

  /// Browses an image from the device and stores it as a base64 data URL in the
  /// image field — same approach the `fe` frontend uses so the backend keeps
  /// storing `imageUrl` as a plain string. Works on web and mobile.
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image == null) return;
      final bytes = await image.readAsBytes();
      // Keep payloads reasonable — the fe frontend caps uploads at 5MB.
      if (bytes.length > 5 * 1024 * 1024) {
        if (mounted) _snack('Image is too large (over 5MB)', isError: true);
        return;
      }
      final mime = _mimeFromName(image.name);
      setState(() => _imageUrlController.text = 'data:$mime;base64,${base64Encode(bytes)}');
    } catch (e) {
      if (mounted) _snack('Failed to pick image: $e', isError: true);
    }
  }

  String _mimeFromName(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.png')) return 'image/png';
    if (lower.endsWith('.webp')) return 'image/webp';
    if (lower.endsWith('.gif')) return 'image/gif';
    return 'image/jpeg';
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
      cuisineType: _cuisineController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
    );
    try {
      await ref.read(restaurantControllerProvider.notifier).save(input);
      if (mounted) _snack(existing == null ? 'Restaurant created' : 'Settings saved successfully');
    } catch (e) {
      if (mounted) _snack(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Restaurant'),
        content: const Text('Are you sure you want to delete this restaurant? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: AppColors.onError),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(restaurantControllerProvider.notifier).delete();
      if (mounted) {
        _populated = false;
        _snack('Restaurant deleted');
      }
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

  @override
  Widget build(BuildContext context) {
    final restaurantAsync = ref.watch(restaurantControllerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildTopAppBar(),
      body: restaurantAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(err.toString(), textAlign: TextAlign.center, style: TextStyle(color: AppColors.onSurfaceVariant)),
          ),
        ),
        data: (restaurant) {
          // Populate the form once from the loaded profile (or reset after a
          // delete). Editing afterwards is local until the owner saves.
          if (restaurant != null && !_populated) {
            _populate(restaurant);
          }
          return _buildForm(restaurant);
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildForm(Restaurant? restaurant) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 768;
        final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
        final useGrid = isDesktop || isLandscape;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: useGrid
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildPageHeader(restaurant),
                          const SizedBox(height: 24),
                          _buildGeneralInfoSection(),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildContactLocationSection(),
                          const SizedBox(height: 24),
                          _buildActionButtons(restaurant),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPageHeader(restaurant),
                    const SizedBox(height: 24),
                    _buildGeneralInfoSection(),
                    const SizedBox(height: 24),
                    _buildContactLocationSection(),
                    const SizedBox(height: 24),
                    _buildActionButtons(restaurant),
                  ],
                ),
        );
      },
    );
  }

  PreferredSizeWidget _buildTopAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      leading: const Icon(Icons.restaurant, color: AppColors.primary, size: 28),
      title: Text(
        'NomNom',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: AppColors.onSurfaceVariant,
          onPressed: () {},
        ),
        Container(
          width: 32,
          height: 32,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryFixed,
            border: Border.all(color: AppColors.outlineVariant),
          ),
          child: const Center(
            child: Text('GH', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
        ),
      ],
    );
  }

  Widget _buildPageHeader(Restaurant? restaurant) {
    final status = restaurant?.status;
    final (statusColor, statusBg, statusLabel) = switch (status) {
      'APPROVED' => (AppColors.secondary, AppColors.secondaryContainer, 'Status: Open'),
      'PENDING' => (Colors.orange, AppColors.tertiaryContainer, 'Status: Pending'),
      'REJECTED' => (AppColors.error, AppColors.errorContainer, 'Status: Rejected'),
      'SUSPENDED' => (AppColors.error, AppColors.errorContainer, 'Status: Suspended'),
      _ => (AppColors.outline, AppColors.surfaceVariant, 'Status: Not created'),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                restaurant == null ? 'Create Restaurant' : 'Restaurant Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(999)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    statusLabel,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.05, color: statusColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          restaurant == null
              ? 'Set up your restaurant to get started.'
              : 'Manage your store presence and contact information.',
          style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
        ),
        if (restaurant?.status == 'REJECTED' && (restaurant?.rejectionReason?.isNotEmpty ?? false)) ...[
          const SizedBox(height: 12),
          _buildStatusBanner(restaurant!.rejectionReason!, showResubmit: true),
        ],
        if (restaurant?.status == 'SUSPENDED' && (restaurant?.suspendReason?.isNotEmpty ?? false)) ...[
          const SizedBox(height: 12),
          _buildStatusBanner(restaurant!.suspendReason!, showResubmit: false),
        ],
      ],
    );
  }

  Widget _buildStatusBanner(String message, {required bool showResubmit}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.errorContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(message, style: TextStyle(color: AppColors.onErrorContainer)),
          if (showResubmit) ...[
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ref.read(restaurantControllerProvider.notifier).resubmit();
                  if (mounted) _snack('Resubmitted for approval');
                } catch (e) {
                  if (mounted) _snack(e.toString(), isError: true);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: AppColors.onError),
              child: const Text('Resubmit'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGeneralInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(Icons.settings, 'General Information'),
          const SizedBox(height: 24),
          _buildTextField('RESTAURANT NAME', _nameController),
          const SizedBox(height: 24),
          _buildTextArea('DESCRIPTION', _descriptionController, 3),
          const SizedBox(height: 24),
          _buildTextField('CUISINE TYPE', _cuisineController),
          const SizedBox(height: 24),
          _buildCoverImage(),
        ],
      ),
    );
  }

  Widget _buildContactLocationSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceVariant.withOpacity(0.5)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(Icons.location_on, 'Contact & Location'),
          const SizedBox(height: 24),
          _buildTextFieldWithIcon('STORE ADDRESS', _addressController, Icons.map),
          const SizedBox(height: 24),
          _buildTextFieldWithIcon('PUBLIC PHONE', _phoneController, Icons.call),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.primaryContainer, size: 24),
        ),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryContainer)),
      ],
    );
  }

  InputDecoration _fieldDecoration({IconData? icon}) {
    return InputDecoration(
      filled: true,
      fillColor: AppColors.surface,
      prefixIcon: icon != null ? Icon(icon, color: AppColors.onSurfaceVariant, size: 20) : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primary),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _fieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.05, color: AppColors.onSurfaceVariant),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 8),
        TextField(controller: controller, decoration: _fieldDecoration()),
      ],
    );
  }

  Widget _buildTextArea(String label, TextEditingController controller, int maxLines) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 8),
        TextField(controller: controller, maxLines: maxLines, decoration: _fieldDecoration()),
      ],
    );
  }

  Widget _buildTextFieldWithIcon(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        const SizedBox(height: 8),
        TextField(controller: controller, decoration: _fieldDecoration(icon: icon)),
      ],
    );
  }

  Widget _buildCoverImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('COVER IMAGE'),
        const SizedBox(height: 8),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.outlineVariant, width: 2),
                color: AppColors.background,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _buildImagePreview(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.upload_outlined, size: 18),
                label: const Text('Browse from device'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  minimumSize: const Size(0, 44),
                ),
              ),
            ),
            if (_imageUrlController.text.trim().isNotEmpty) ...[
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => setState(() => _imageUrlController.clear()),
                icon: const Icon(Icons.close),
                color: AppColors.error,
                tooltip: 'Remove image',
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _imageUrlController,
          decoration: _fieldDecoration(icon: Icons.link).copyWith(hintText: 'Or paste an image URL'),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildImagePreview() {
    final url = _imageUrlController.text.trim();
    if (url.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo, color: AppColors.primary, size: 48),
            const SizedBox(height: 8),
            Text(
              'Tap to browse an image',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.05, color: AppColors.primary),
            ),
          ],
        ),
      );
    }
    Widget errored() => Container(color: AppColors.background, child: const Center(child: Icon(Icons.broken_image, size: 48)));
    if (url.startsWith('data:')) {
      try {
        return Image.memory(
          base64Decode(url.split(',').last),
          fit: BoxFit.cover,
          width: double.infinity,
          errorBuilder: (_, __, ___) => errored(),
        );
      } catch (_) {
        return errored();
      }
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      errorBuilder: (_, __, ___) => errored(),
    );
  }

  Widget _buildActionButtons(Restaurant? restaurant) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _saving ? null : () => _save(restaurant),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
          ),
          child: _saving
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save),
                    const SizedBox(width: 8),
                    Text(
                      restaurant == null ? 'Create Restaurant' : 'Save Changes',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
        ),
        if (restaurant != null) ...[
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: _delete,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              backgroundColor: AppColors.errorContainer.withOpacity(0.1),
              minimumSize: const Size(double.infinity, 56),
              side: BorderSide(color: AppColors.error),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_forever),
                SizedBox(width: 8),
                Text('Delete Restaurant', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, -4))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard, 'Dashboard', false),
          _buildNavItem(Icons.menu_book, 'Menu', false),
          _buildNavItem(Icons.receipt_long, 'Orders', false),
          _buildNavItem(Icons.analytics, 'Analytics', false),
          _buildNavItem(Icons.settings, 'Settings', true),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return InkWell(
      onTap: () {
        if (label == 'Menu') {
          context.go('/owner/menu');
        } else if (label == 'Settings') {
          // Already on settings page
        } else if (label == 'Dashboard') {
          context.go('/owner/dashboard');
        } else if (label == 'Orders') {
          context.go('/owner/orders');
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: isActive
            ? BoxDecoration(color: AppColors.primaryContainer, borderRadius: BorderRadius.circular(12))
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant, fill: isActive ? 1 : 0),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.05,
                color: isActive ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
