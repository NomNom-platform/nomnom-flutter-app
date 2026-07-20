import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/page_response.dart';
import '../../data/models/notification_model.dart';
import '../providers/notification_di.dart';

part 'notification_controller.g.dart';

@riverpod
class NotificationController extends _$NotificationController {
  @override
  FutureOr<PageResponse<NotificationModel>> build() async {
    return _fetchNotifications();
  }

  Future<PageResponse<NotificationModel>> _fetchNotifications({int page = 0, int size = 10}) async {
    final result = await ref.read(notificationRepositoryProvider).getNotifications(page: page, size: size);
    return result.fold(
      (failure) => throw failure,
      (pageData) => pageData,
    );
  }

  Future<void> markAsRead(String id) async {
    final oldState = state;
    if (!oldState.hasValue) return;

    final updatedContent = oldState.value!.content.map((notif) {
      if (notif.id == id) {
        return notif.copyWith(isRead: true);
      }
      return notif;
    }).toList();

    // Optimistic UI update
    state = AsyncValue.data(oldState.value!.copyWith(content: updatedContent));

    final result = await ref.read(notificationRepositoryProvider).markAsRead(id);
    result.fold(
      (failure) {
        // Rollback state if failed
        state = oldState;
      },
      (updatedNotification) {
        // Keep updated state
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchNotifications());
  }
}
