import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/order_model.dart';
import '../providers/order_di.dart';
import '../../domain/entities/order_status.dart';

part 'order_details_controller.g.dart';

@riverpod
class OrderDetailsController extends _$OrderDetailsController {
  Timer? _timer;

  @override
  FutureOr<OrderModel> build(String orderId) async {
    ref.onDispose(() {
      _timer?.cancel();
    });

    final order = await _fetchOrder();
    
    if (!_isFinalStatus(order.status)) {
      _startPolling();
    }

    return order;
  }

  Future<OrderModel> _fetchOrder() async {
    final result = await ref.read(orderRepositoryProvider).getOrderById(orderId);
    return result.fold(
      (failure) => throw failure,
      (order) => order,
    );
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        final order = await _fetchOrder();
        if (state.hasValue && state.value?.status != order.status) {
          state = AsyncValue.data(order);
        } else if (!state.hasValue) {
          state = AsyncValue.data(order);
        }
        
        if (_isFinalStatus(order.status)) {
          timer.cancel();
        }
      } catch (e) {
        // Silently ignore polling transient network errors to avoid UX disruption
      }
    });
  }

  bool _isFinalStatus(OrderStatus status) {
    return status == OrderStatus.delivered || status == OrderStatus.cancelled;
  }

  Future<bool> cancelOrder() async {
    final result = await ref.read(orderRepositoryProvider).cancelOrder(orderId);
    return result.fold(
      (failure) => false,
      (_) {
        _timer?.cancel();
        if (state.hasValue) {
          state = AsyncValue.data(state.value!.copyWith(status: OrderStatus.cancelled));
        }
        return true;
      },
    );
  }

  Future<bool> confirmDelivery() async {
    final result = await ref.read(orderRepositoryProvider).confirmDelivery(orderId);
    return result.fold(
      (failure) => false,
      (_) {
        _timer?.cancel();
        if (state.hasValue) {
          state = AsyncValue.data(state.value!.copyWith(status: OrderStatus.delivered));
        }
        return true;
      },
    );
  }
}
