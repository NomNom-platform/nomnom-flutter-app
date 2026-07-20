import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/restaurant.dart';
import '../providers/restaurant_di.dart';

part 'customer_restaurant_controller.g.dart';

@riverpod
class CustomerRestaurants extends _$CustomerRestaurants {
  @override
  Future<List<Restaurant>> build() async {
    final result = await ref.read(restaurantRepositoryProvider).getAllRestaurants(page: 0, size: 50);
    return result.fold(
      (failure) => throw failure,
      (page) => page.content,
    );
  }
}

@riverpod
class RestaurantDetail extends _$RestaurantDetail {
  @override
  Future<Restaurant> build(String restaurantId) async {
    final result = await ref.read(restaurantRepositoryProvider).getRestaurantById(restaurantId);
    return result.fold(
      (failure) => throw failure,
      (restaurant) => restaurant,
    );
  }
}
