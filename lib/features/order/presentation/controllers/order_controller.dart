import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/models/page_response.dart';
import '../../data/models/order_model.dart';
import '../../data/models/order_request_model.dart';
import '../providers/order_di.dart';

part 'order_controller.g.dart';

@riverpod
class OrderController extends _$OrderController {
  @override
  FutureOr<PageResponse<OrderModel>> build() async {
    return _fetchMyOrders();
  }

  Future<PageResponse<OrderModel>> _fetchMyOrders({int page = 0, int size = 10}) async {
    final result = await ref.read(orderRepositoryProvider).getMyOrders(page: page, size: size);
    return result.fold(
      (failure) => throw failure,
      (pageData) => pageData,
    );
  }

  Future<bool> placeOrder(OrderRequestModel request) async {
    state = const AsyncValue.loading();
    final result = await ref.read(orderRepositoryProvider).placeOrder(request);
    
    return result.fold(
      (failure) {
        state = AsyncValue.error(failure, StackTrace.current);
        return false;
      },
      (order) {
        // Refresh the orders list
        ref.invalidateSelf();
        return true;
      },
    );
  }
}
