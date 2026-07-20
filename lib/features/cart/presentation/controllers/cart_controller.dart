import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_controller.g.dart';

@riverpod
class CartController extends _$CartController {
  @override
  List<CartItem> build() {
    return [];
  }

  String? get restaurantId {
    if (state.isEmpty) return null;
    return state.first.restaurantId;
  }

  double get subtotal {
    return state.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get deliveryFee {
    if (state.isEmpty) return 0.0;
    return 3.99; // Cố định hoặc tính động
  }

  double get tax {
    return subtotal * 0.08; // 8% thuế
  }

  double get total {
    if (state.isEmpty) return 0.0;
    return subtotal + deliveryFee + tax;
  }

  int get totalCalories {
    return state.fold(0, (sum, item) => sum + (item.calories * item.quantity));
  }

  void addItem(CartItem item) {
    // Nếu giỏ hàng có sản phẩm từ nhà hàng khác, xóa hết giỏ hàng trước khi thêm
    if (state.isNotEmpty && state.first.restaurantId != item.restaurantId) {
      state = [item];
      return;
    }

    final index = state.indexWhere((element) => element.menuItemId == item.menuItemId);
    if (index != -1) {
      final existingItem = state[index];
      final updatedList = List<CartItem>.from(state);
      updatedList[index] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
      state = updatedList;
    } else {
      state = [...state, item];
    }
  }

  void updateQuantity(String menuItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(menuItemId);
      return;
    }
    state = state.map((item) {
      if (item.menuItemId == menuItemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
  }

  void removeItem(String menuItemId) {
    state = state.where((item) => item.menuItemId != menuItemId).toList();
  }

  void clearCart() {
    state = [];
  }
}
