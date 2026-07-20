import '../../../../core/utils/result.dart';
import '../../../../core/models/page_response.dart';
import '../../data/models/notification_model.dart';

abstract class NotificationRepository {
  Future<Result<PageResponse<NotificationModel>>> getNotifications({int page = 0, int size = 10});
  Future<Result<NotificationModel>> markAsRead(String id);
}
