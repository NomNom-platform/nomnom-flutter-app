import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/restaurant_input.dart';
import '../providers/restaurant_di.dart';

part 'restaurant_controller.g.dart';

/// Owns the current owner's restaurant profile. `null` data means the owner
/// has not created a restaurant yet — callers should offer the create flow.
@riverpod
class RestaurantController extends _$RestaurantController {
  @override
  Future<Restaurant?> build() async {
    final result = await ref.read(restaurantRepositoryProvider).getMyRestaurant();
    return result.fold((failure) => throw failure, (restaurant) => restaurant);
  }

  /// Creates the restaurant when none exists yet, otherwise updates it.
  /// Returns the saved [Restaurant] on success, or throws the failure.
  Future<Restaurant> save(RestaurantInput input) async {
    final repo = ref.read(restaurantRepositoryProvider);
    final existing = state.valueOrNull;
    final result = existing == null
        ? await repo.create(input)
        : await repo.update(existing.id, input);
    final saved = result.fold((failure) => throw failure, (r) => r);
    state = AsyncData(saved);
    return saved;
  }

  Future<void> delete() async {
    final existing = state.valueOrNull;
    if (existing == null) return;
    final result = await ref.read(restaurantRepositoryProvider).delete(existing.id);
    result.fold((failure) => throw failure, (_) => null);
    state = const AsyncData(null);
  }

  Future<void> resubmit() async {
    final existing = state.valueOrNull;
    if (existing == null) return;
    final result = await ref.read(restaurantRepositoryProvider).resubmit(existing.id);
    final updated = result.fold((failure) => throw failure, (r) => r);
    state = AsyncData(updated);
  }
}
