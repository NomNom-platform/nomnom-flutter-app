import 'package:dio/dio.dart';
import '../../../../core/utils/result.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/models/page_response.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';
import '../models/notification_model.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<PageResponse<NotificationModel>>> getNotifications({int page = 0, int size = 10}) async {
    try {
      final pageResponse = await remoteDataSource.getNotifications(page, size);
      return Success(pageResponse);
    } on DioException catch (e) {
      return Fail(ServerFailure(e.response?.data?['message'] ??
          e.message ??
          'Failed to fetch notifications'));
    } catch (e) {
      return Fail(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Result<NotificationModel>> markAsRead(String id) async {
    try {
      final notification = await remoteDataSource.markAsRead(id);
      return Success(notification);
    } on DioException catch (e) {
      return Fail(ServerFailure(e.response?.data?['message'] ??
          e.message ??
          'Failed to mark notification as read'));
    } catch (e) {
      return Fail(UnknownFailure(e.toString()));
    }
  }
}
