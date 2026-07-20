import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/menu_item.dart';

part 'menu_item_model.freezed.dart';
part 'menu_item_model.g.dart';

/// Wire format for `MenuItemResponse` from menu-service (:8084).
///
/// `price` is a BigDecimal server-side and may arrive as a JSON number or
/// string; nutrition macros are doubles and calories an int. We normalize
/// them to Dart's [double]/[int] via [num] casts in [toEntity].
@freezed
class MenuItemModel with _$MenuItemModel {
  const MenuItemModel._();

  const factory MenuItemModel({
    required String id,
    required String restaurantId,
    required String name,
    String? description,
    required num price,
    int? calories,
    double? proteinG,
    double? carbG,
    double? fatG,
    required String category,
    String? imageUrl,
    bool? isAvailable,
  }) = _MenuItemModel;

  factory MenuItemModel.fromJson(Map<String, dynamic> json) =>
      _$MenuItemModelFromJson(json);

  MenuItem toEntity() => MenuItem(
        id: id,
        restaurantId: restaurantId,
        name: name,
        description: description ?? '',
        price: price.toDouble(),
        calories: calories ?? 0,
        proteinG: proteinG ?? 0,
        carbG: carbG ?? 0,
        fatG: fatG ?? 0,
        category: category,
        imageUrl: imageUrl,
        isAvailable: isAvailable ?? true,
      );
}
