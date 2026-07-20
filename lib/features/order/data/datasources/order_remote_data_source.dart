import 'package:dio/dio.dart';
import '../../../../core/models/page_response.dart';
import '../models/order_model.dart';
import '../models/order_request_model.dart';
import '../models/create_order_response_model.dart';
import '../../domain/entities/order_status.dart';

abstract class OrderRemoteDataSource {
  Future<CreateOrderResponseModel> placeOrder(OrderRequestModel request);
  Future<PageResponse<OrderModel>> getMyOrders(int page, int size);
  Future<PageResponse<OrderModel>> getRestaurantOrders(String restaurantId, int page, int size);
  Future<OrderModel> getOrderById(String id);
  Future<OrderModel> updateOrderStatus(String id, String status);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final Dio dio;

  OrderRemoteDataSourceImpl(this.dio);

  @override
  Future<CreateOrderResponseModel> placeOrder(OrderRequestModel request) async {
    final response = await dio.post('/api/orders', data: request.toJson());
    return CreateOrderResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PageResponse<OrderModel>> getMyOrders(int page, int size) async {
    final response = await dio.get('/api/orders/me', queryParameters: {
      'page': page,
      'size': size,
    });
    return PageResponse<OrderModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => OrderModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<PageResponse<OrderModel>> getRestaurantOrders(String restaurantId, int page, int size) async {
    final response = await dio.get('/api/orders/restaurant/$restaurantId', queryParameters: {
      'page': page,
      'size': size,
    });
    return PageResponse<OrderModel>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => OrderModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<OrderModel> getOrderById(String id) async {
    final response = await dio.get('/api/orders/$id');
    return OrderModel.fromJson(response.data);
  }

  @override
  Future<OrderModel> updateOrderStatus(String id, String status) async {
    final response = await dio.put('/api/orders/$id/status', data: {'status': status});
    if (response.data == null || response.data.toString().isEmpty) {
      return OrderModel(
        id: id,
        customerId: '',
        restaurantId: '',
        status: OrderStatus.values.firstWhere(
          (s) => s.name.toUpperCase() == status.replaceAll('_', '').toUpperCase(),
          orElse: () => OrderStatus.pending,
        ),
        totalAmount: 0,
        deliveryAddress: '',
      );
    }
    return OrderModel.fromJson(response.data as Map<String, dynamic>);
  }
}
