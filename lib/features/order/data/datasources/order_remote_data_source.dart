import 'package:dio/dio.dart';
import '../../../../core/models/page_response.dart';
import '../models/order_model.dart';
import '../models/order_request_model.dart';
import '../models/create_order_response_model.dart';

abstract class OrderRemoteDataSource {
  Future<CreateOrderResponseModel> placeOrder(OrderRequestModel request);
  Future<PageResponse<OrderModel>> getMyOrders(int page, int size);
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
    final response = await dio.get('/api/orders/my-orders', queryParameters: {
      'page': page,
      'size': size,
    });
    return PageResponse.fromJson(
      response.data,
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
    final response = await dio.patch('/api/orders/$id/status', queryParameters: {'status': status});
    return OrderModel.fromJson(response.data);
  }
}
