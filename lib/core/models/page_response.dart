import 'package:freezed_annotation/freezed_annotation.dart';

part 'page_response.freezed.dart';
part 'page_response.g.dart';

@Freezed(genericArgumentFactories: true)
class PageResponse<T> with _$PageResponse<T> {
  const factory PageResponse({
    @Default([]) List<T> content,
    @Default(0) int page,
    @Default(0) int size,
    @Default(0) int totalElements,
    @Default(0) int totalPages,
    @Default(false) bool last,
  }) = _PageResponse;

  factory PageResponse.fromJson(
          Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$PageResponseFromJson(json, fromJsonT);
}
