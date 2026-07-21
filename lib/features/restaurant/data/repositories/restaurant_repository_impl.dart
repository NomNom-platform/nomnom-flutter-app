import 'package:dio/dio.dart';
import '../../../../core/error/dio_error_mapper.dart';
import '../../../../core/models/page_response.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/entities/restaurant_input.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_data_source.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource _remote;

  const RestaurantRepositoryImpl(this._remote);

  @override
  Future<Result<Restaurant?>> getMyRestaurant() async {
    try {
      final model = await _remote.getMyRestaurant();
      return Result.success(model?.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<Restaurant>> create(RestaurantInput input) async {
    try {
      final model = await _remote.create(input.toJson());
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<Restaurant>> update(String id, RestaurantInput input) async {
    try {
      final model = await _remote.update(id, input.toJson());
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      await _remote.delete(id);
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<Restaurant>> resubmit(String id) async {
    try {
      final model = await _remote.resubmit(id);
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<PageResponse<Restaurant>>> getAllRestaurants({int page = 0, int size = 10}) async {
    try {
      final modelPage = await _remote.getAllRestaurants(page: page, size: size);
      final entityList = modelPage.content.map((model) => model.toEntity()).toList();
      final entityPage = PageResponse<Restaurant>(
        content: entityList,
        page: modelPage.page,
        size: modelPage.size,
        totalElements: modelPage.totalElements,
        totalPages: modelPage.totalPages,
        last: modelPage.last,
      );
      return Result.success(entityPage);
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<Restaurant>> getRestaurantById(String id) async {
    try {
      final model = await _remote.getRestaurantById(id);
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }
}
