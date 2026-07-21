import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/order_model.dart';
import '../providers/order_di.dart';
import '../../../../core/models/page_response.dart';
import '../../../restaurant/presentation/controllers/restaurant_controller.dart';

part 'owner_orders_controller.g.dart';

@riverpod
class OwnerOrdersController extends _$OwnerOrdersController {
  @override
  FutureOr<PageResponse<OrderModel>> build() async {
    final restaurant = await ref.watch(restaurantControllerProvider.future);
    if (restaurant == null) {
      return const PageResponse(content: []);
    }
    return _fetchRestaurantOrders(restaurant.id);
  }

  Future<PageResponse<OrderModel>> _fetchRestaurantOrders(String restaurantId, {int page = 0, int size = 50}) async {
    final result = await ref.read(orderRepositoryProvider).getRestaurantOrders(restaurantId, page: page, size: size);
    return result.fold(
      (failure) => throw failure,
      (pageData) => pageData,
    );
  }

  Future<bool> updateStatus(String orderId, String newStatus) async {
    final result = await ref.read(orderRepositoryProvider).updateOrderStatus(orderId, newStatus);
    return result.fold(
      (failure) => false,
      (order) {
        ref.invalidateSelf();
        return true;
      },
    );
  }
}
