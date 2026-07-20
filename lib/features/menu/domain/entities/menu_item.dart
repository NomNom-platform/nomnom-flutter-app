import 'package:freezed_annotation/freezed_annotation.dart';

part 'menu_item.freezed.dart';

/// A menu item belonging to a restaurant. Mirrors `MenuItemResponse` from
/// menu-service (:8084).
@freezed
class MenuItem with _$MenuItem {
  const factory MenuItem({
    required String id,
    required String restaurantId,
    required String name,
    required String description,
    required double price,
    required int calories,
    required double proteinG,
    required double carbG,
    required double fatG,
    required String category,
    String? imageUrl,
    required bool isAvailable,
  }) = _MenuItem;
}
