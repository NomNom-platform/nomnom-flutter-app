import '../../../../core/utils/result.dart';
import '../../../../core/models/page_response.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_request_model.dart';
import '../../data/models/create_order_response_model.dart';

abstract class OrderRepository {
  Future<Result<CreateOrderResponseModel>> placeOrder(OrderRequestModel request);
  Future<Result<PageResponse<OrderModel>>> getMyOrders({int page = 0, int size = 10});
  Future<Result<PageResponse<OrderModel>>> getRestaurantOrders(String restaurantId, {int page = 0, int size = 10});
  Future<Result<OrderModel>> getOrderById(String id);
  Future<Result<OrderModel>> updateOrderStatus(String id, String status);
}
