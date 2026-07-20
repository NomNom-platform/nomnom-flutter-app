import 'package:dio/dio.dart';
import '../../../../core/error/dio_error_mapper.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/menu_item.dart';
import '../../domain/entities/menu_item_input.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_data_source.dart';

class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource _remote;

  const MenuRepositoryImpl(this._remote);

  @override
  Future<Result<List<MenuItem>>> listByRestaurant(
    String restaurantId, {
    String? category,
  }) async {
    try {
      final page = await _remote.listByRestaurant(restaurantId, category: category, size: 100);
      return Result.success(page.content.map((e) => e.toEntity()).toList());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<MenuItem>> create(String restaurantId, MenuItemInput input) async {
    try {
      final model = await _remote.create(restaurantId, input.toJson());
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<MenuItem>> update(String itemId, MenuItemInput input) async {
    try {
      final model = await _remote.update(itemId, input.toJson());
      return Result.success(model.toEntity());
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }

  @override
  Future<Result<void>> remove(String itemId) async {
    try {
      await _remote.remove(itemId);
      return const Result.success(null);
    } on DioException catch (e) {
      return Result.failure(mapDioException(e));
    }
  }
}
