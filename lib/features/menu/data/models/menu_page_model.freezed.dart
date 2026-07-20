// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MenuPageModel _$MenuPageModelFromJson(Map<String, dynamic> json) {
  return _MenuPageModel.fromJson(json);
}

/// @nodoc
mixin _$MenuPageModel {
  List<MenuItemModel> get content => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get last => throw _privateConstructorUsedError;

  /// Serializes this MenuPageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MenuPageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MenuPageModelCopyWith<MenuPageModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenuPageModelCopyWith<$Res> {
  factory $MenuPageModelCopyWith(
          MenuPageModel value, $Res Function(MenuPageModel) then) =
      _$MenuPageModelCopyWithImpl<$Res, MenuPageModel>;
  @useResult
  $Res call(
      {List<MenuItemModel> content,
      int page,
      int size,
      int totalElements,
      int totalPages,
      bool last});
}

/// @nodoc
class _$MenuPageModelCopyWithImpl<$Res, $Val extends MenuPageModel>
    implements $MenuPageModelCopyWith<$Res> {
  _$MenuPageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MenuPageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? page = null,
    Object? size = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? last = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as List<MenuItemModel>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      last: null == last
          ? _value.last
          : last // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MenuPageModelImplCopyWith<$Res>
    implements $MenuPageModelCopyWith<$Res> {
  factory _$$MenuPageModelImplCopyWith(
          _$MenuPageModelImpl value, $Res Function(_$MenuPageModelImpl) then) =
      __$$MenuPageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<MenuItemModel> content,
      int page,
      int size,
      int totalElements,
      int totalPages,
      bool last});
}

/// @nodoc
class __$$MenuPageModelImplCopyWithImpl<$Res>
    extends _$MenuPageModelCopyWithImpl<$Res, _$MenuPageModelImpl>
    implements _$$MenuPageModelImplCopyWith<$Res> {
  __$$MenuPageModelImplCopyWithImpl(
      _$MenuPageModelImpl _value, $Res Function(_$MenuPageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of MenuPageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? page = null,
    Object? size = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? last = null,
  }) {
    return _then(_$MenuPageModelImpl(
      content: null == content
          ? _value._content
          : content // ignore: cast_nullable_to_non_nullable
              as List<MenuItemModel>,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as int,
      totalElements: null == totalElements
          ? _value.totalElements
          : totalElements // ignore: cast_nullable_to_non_nullable
              as int,
      totalPages: null == totalPages
          ? _value.totalPages
          : totalPages // ignore: cast_nullable_to_non_nullable
              as int,
      last: null == last
          ? _value.last
          : last // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MenuPageModelImpl extends _MenuPageModel {
  const _$MenuPageModelImpl(
      {final List<MenuItemModel> content = const <MenuItemModel>[],
      this.page = 0,
      this.size = 0,
      this.totalElements = 0,
      this.totalPages = 0,
      this.last = true})
      : _content = content,
        super._();

  factory _$MenuPageModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$MenuPageModelImplFromJson(json);

  final List<MenuItemModel> _content;
  @override
  @JsonKey()
  List<MenuItemModel> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  @override
  @JsonKey()
  final int page;
  @override
  @JsonKey()
  final int size;
  @override
  @JsonKey()
  final int totalElements;
  @override
  @JsonKey()
  final int totalPages;
  @override
  @JsonKey()
  final bool last;

  @override
  String toString() {
    return 'MenuPageModel(content: $content, page: $page, size: $size, totalElements: $totalElements, totalPages: $totalPages, last: $last)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenuPageModelImpl &&
            const DeepCollectionEquality().equals(other._content, _content) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.totalElements, totalElements) ||
                other.totalElements == totalElements) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.last, last) || other.last == last));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_content),
      page,
      size,
      totalElements,
      totalPages,
      last);

  /// Create a copy of MenuPageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MenuPageModelImplCopyWith<_$MenuPageModelImpl> get copyWith =>
      __$$MenuPageModelImplCopyWithImpl<_$MenuPageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MenuPageModelImplToJson(
      this,
    );
  }
}

abstract class _MenuPageModel extends MenuPageModel {
  const factory _MenuPageModel(
      {final List<MenuItemModel> content,
      final int page,
      final int size,
      final int totalElements,
      final int totalPages,
      final bool last}) = _$MenuPageModelImpl;
  const _MenuPageModel._() : super._();

  factory _MenuPageModel.fromJson(Map<String, dynamic> json) =
      _$MenuPageModelImpl.fromJson;

  @override
  List<MenuItemModel> get content;
  @override
  int get page;
  @override
  int get size;
  @override
  int get totalElements;
  @override
  int get totalPages;
  @override
  bool get last;

  /// Create a copy of MenuPageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MenuPageModelImplCopyWith<_$MenuPageModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
