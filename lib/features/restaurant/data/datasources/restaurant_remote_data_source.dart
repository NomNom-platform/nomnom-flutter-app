import 'package:dio/dio.dart';
import '../../../../core/models/page_response.dart';
import '../models/restaurant_model.dart';

/// Talks to restaurant-service (:8082). Returns wire-format models and throws
/// [DioException] on failure — mapping to [Failure] is the repository's job.
abstract class RestaurantRemoteDataSource {
  /// `GET /api/restaurants/my` — returns `null` when the owner has no
  /// restaurant yet (service replies 204 No Content).
  Future<RestaurantModel?> getMyRestaurant();

  Future<RestaurantModel> create(Map<String, dynamic> payload);

  Future<RestaurantModel> update(String id, Map<String, dynamic> payload);

  Future<void> delete(String id);

  Future<RestaurantModel> resubmit(String id);

  Future<PageResponse<RestaurantModel>> getAllRestaurants({int page = 0, int size = 10});

  Future<RestaurantModel> getRestaurantById(String id);
}

class RestaurantRemoteDataSourceImpl implements RestaurantRemoteDataSource {
  final Dio _dio;

  const RestaurantRemoteDataSourceImpl(this._dio);

  @override
  Future<RestaurantModel?> getMyRestaurant() async {
    final response = await _dio.get('/api/restaurants/my');
    final data = response.data;
    // 204 No Content → empty body → owner hasn't created a restaurant.
    if (response.statusCode == 204 || data == null || data is! Map) {
      return null;
    }
    return RestaurantModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<RestaurantModel> create(Map<String, dynamic> payload) async {
    final response = await _dio.post('/api/restaurants', data: payload);
    return RestaurantModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<RestaurantModel> update(String id, Map<String, dynamic> payload) async {
    final response = await _dio.put('/api/restaurants/$id', data: payload);
    return RestaurantModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> delete(String id) async {
    await _dio.delete('/api/restaurants/$id');
  }

  @override
  Future<RestaurantModel> resubmit(String id) async {
    final response = await _dio.post('/api/restaurants/$id/resubmit');
    return RestaurantModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<PageResponse<RestaurantModel>> getAllRestaurants({int page = 0, int size = 10}) async {
    final response = await _dio.get('/api/restaurants', queryParameters: {
      'page': page,
      'size': size,
    });
    return PageResponse.fromJson(
      response.data as Map<String, dynamic>,
      (json) => RestaurantModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<RestaurantModel> getRestaurantById(String id) async {
    final response = await _dio.get('/api/restaurants/$id');
    return RestaurantModel.fromJson(response.data as Map<String, dynamic>);
  }
}
