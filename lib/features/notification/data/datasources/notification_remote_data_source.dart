import 'package:dio/dio.dart';
import '../../../../core/models/page_response.dart';
import '../models/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<PageResponse<NotificationModel>> getNotifications(int page, int size);
  Future<NotificationModel> markAsRead(String id);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio dio;

  NotificationRemoteDataSourceImpl(this.dio);

  @override
  Future<PageResponse<NotificationModel>> getNotifications(int page, int size) async {
    final response = await dio.get('/api/notifications', queryParameters: {
      'page': page,
      'size': size,
    });
    return PageResponse.fromJson(
      response.data,
      (json) => NotificationModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<NotificationModel> markAsRead(String id) async {
    final response = await dio.put('/api/notifications/$id/read');
    return NotificationModel.fromJson(response.data);
  }
}
