import 'package:dio/dio.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/models/page_response.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/order_model.dart';
import '../models/order_request_model.dart';

import '../models/create_order_response_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<CreateOrderResponseModel>> placeOrder(OrderRequestModel request) async {
    try {
      final response = await remoteDataSource.placeOrder(request);
      return Success(response);
    } on DioException catch (e) {
      return Fail(ServerFailure(e.response?.data?['message'] ??
          e.message ??
          'Failed to place order'));
    } catch (e) {
      return Fail(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<PageResponse<OrderModel>>> getMyOrders(
      {int page = 0, int size = 10}) async {
    try {
      final pageResponse = await remoteDataSource.getMyOrders(page, size);
      return Success(pageResponse);
    } on DioException catch (e) {
      return Fail(ServerFailure(e.response?.data?['message'] ??
          e.message ??
          'Failed to fetch orders'));
    } catch (e) {
      return Fail(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<PageResponse<OrderModel>>> getRestaurantOrders(
      String restaurantId, {int page = 0, int size = 10}) async {
    try {
      final pageResponse = await remoteDataSource.getRestaurantOrders(restaurantId, page, size);
      return Success(pageResponse);
    } on DioException catch (e) {
      return Fail(ServerFailure(e.response?.data?['message'] ??
          e.message ??
          'Failed to fetch restaurant orders'));
    } catch (e) {
      return Fail(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<OrderModel>> getOrderById(String id) async {
    try {
      final order = await remoteDataSource.getOrderById(id);
      return Success(order);
    } on DioException catch (e) {
      return Fail(ServerFailure(e.response?.data?['message'] ??
          e.message ??
          'Failed to fetch order'));
    } catch (e) {
      return Fail(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<OrderModel>> updateOrderStatus(String id, String status) async {
    try {
      final order = await remoteDataSource.updateOrderStatus(id, status);
      return Success(order);
    } on DioException catch (e) {
      return Fail(ServerFailure(e.response?.data?['message'] ??
          e.message ??
          'Failed to update order status'));
    } catch (e) {
      return Fail(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> cancelOrder(String id) async {
    try {
      await remoteDataSource.cancelOrder(id);
      return const Success(null);
    } on DioException catch (e) {
      return Fail(ServerFailure(e.response?.data?['message'] ??
          e.message ??
          'Failed to cancel order'));
    } catch (e) {
      return Fail(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<void>> confirmDelivery(String id) async {
    try {
      await remoteDataSource.confirmDelivery(id);
      return const Success(null);
    } on DioException catch (e) {
      return Fail(ServerFailure(e.response?.data?['message'] ??
          e.message ??
          'Failed to confirm delivery'));
    } catch (e) {
      return Fail(UnknownFailure(e.toString()));
    }
  }
}
