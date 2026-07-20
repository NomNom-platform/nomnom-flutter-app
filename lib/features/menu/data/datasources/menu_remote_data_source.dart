import 'package:dio/dio.dart';
import '../models/menu_item_model.dart';
import '../models/menu_page_model.dart';

/// Talks to menu-service (:8084). Throws [DioException] on failure.
abstract class MenuRemoteDataSource {
  Future<MenuPageModel> listByRestaurant(
    String restaurantId, {
    String? category,
    int page,
    int size,
  });

  Future<MenuItemModel> create(String restaurantId, Map<String, dynamic> payload);

  Future<MenuItemModel> update(String itemId, Map<String, dynamic> payload);

  Future<void> remove(String itemId);
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final Dio _dio;

  const MenuRemoteDataSourceImpl(this._dio);

  @override
  Future<MenuPageModel> listByRestaurant(
    String restaurantId, {
    String? category,
    int page = 0,
    int size = 50,
  }) async {
    final response = await _dio.get(
      '/api/restaurants/$restaurantId/items',
      queryParameters: {
        if (category != null) 'category': category,
        'page': page,
        'size': size,
      },
    );
    return MenuPageModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MenuItemModel> create(String restaurantId, Map<String, dynamic> payload) async {
    final response = await _dio.post('/api/restaurants/$restaurantId/items', data: payload);
    return MenuItemModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<MenuItemModel> update(String itemId, Map<String, dynamic> payload) async {
    final response = await _dio.put('/api/items/$itemId', data: payload);
    return MenuItemModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> remove(String itemId) async {
    await _dio.delete('/api/items/$itemId');
  }
}
