import 'package:freezed_annotation/freezed_annotation.dart';
import 'menu_item_model.dart';

part 'menu_page_model.freezed.dart';
part 'menu_page_model.g.dart';

/// Wire format for the shared `PageResponse<MenuItemResponse>` wrapper.
@freezed
class MenuPageModel with _$MenuPageModel {
  const MenuPageModel._();

  const factory MenuPageModel({
    @Default(<MenuItemModel>[]) List<MenuItemModel> content,
    @Default(0) int page,
    @Default(0) int size,
    @Default(0) int totalElements,
    @Default(0) int totalPages,
    @Default(true) bool last,
  }) = _MenuPageModel;

  factory MenuPageModel.fromJson(Map<String, dynamic> json) =>
      _$MenuPageModelFromJson(json);
}
