import 'package:dio/dio.dart';
import '../../../../core/error/dio_error_mapper.dart';
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
}
