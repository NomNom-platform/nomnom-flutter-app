import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/menu_item_input.dart';
import '../providers/menu_di.dart';

part 'menu_controller.g.dart';

/// Loads and mutates the menu items for a single restaurant. Keyed by
/// [restaurantId] so each restaurant has its own cached list.
@riverpod
class MenuController extends _$MenuController {
  @override
  Future<List<MenuItem>> build(String restaurantId) async {
    return _load();
  }

  Future<List<MenuItem>> _load() async {
    final result = await ref.read(menuRepositoryProvider).listByRestaurant(restaurantId);
    return result.fold((failure) => throw failure, (items) => items);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_load);
  }

  Future<void> create(MenuItemInput input) async {
    final result = await ref.read(menuRepositoryProvider).create(restaurantId, input);
    result.fold((failure) => throw failure, (_) => null);
    await refresh();
  }

  Future<void> edit(String itemId, MenuItemInput input) async {
    final result = await ref.read(menuRepositoryProvider).update(itemId, input);
    result.fold((failure) => throw failure, (_) => null);
    await refresh();
  }

  /// Flips availability by re-sending the full item with the toggled flag,
  /// mirroring how the `fe` frontend toggles via the update endpoint.
  Future<void> toggleAvailability(MenuItem item) async {
    final input = MenuItemInput(
      name: item.name,
      description: item.description,
      price: item.price,
      calories: item.calories,
      proteinG: item.proteinG,
      carbG: item.carbG,
      fatG: item.fatG,
      category: item.category,
      imageUrl: item.imageUrl ?? '',
      isAvailable: !item.isAvailable,
    );
    await edit(item.id, input);
  }

  Future<void> remove(String itemId) async {
    final result = await ref.read(menuRepositoryProvider).remove(itemId);
    result.fold((failure) => throw failure, (_) => null);
    await refresh();
  }
}
