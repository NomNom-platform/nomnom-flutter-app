import '../../../../core/utils/result.dart';
import '../entities/restaurant.dart';
import '../entities/restaurant_input.dart';

abstract class RestaurantRepository {
  /// Success value is `null` when the owner has not created a restaurant yet.
  Future<Result<Restaurant?>> getMyRestaurant();

  Future<Result<Restaurant>> create(RestaurantInput input);

  Future<Result<Restaurant>> update(String id, RestaurantInput input);

  Future<Result<void>> delete(String id);

  Future<Result<Restaurant>> resubmit(String id);
}
