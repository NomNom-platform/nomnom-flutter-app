import '../../../../core/utils/result.dart';
import '../entities/menu_item.dart';
import '../entities/menu_item_input.dart';

abstract class MenuRepository {
  Future<Result<List<MenuItem>>> listByRestaurant(
    String restaurantId, {
    String? category,
  });

  Future<Result<MenuItem>> create(String restaurantId, MenuItemInput input);

  Future<Result<MenuItem>> update(String itemId, MenuItemInput input);

  Future<Result<void>> remove(String itemId);
}
