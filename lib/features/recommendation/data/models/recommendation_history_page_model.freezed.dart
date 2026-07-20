// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_history_page_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecommendationHistoryPageModel _$RecommendationHistoryPageModelFromJson(
    Map<String, dynamic> json) {
  return _RecommendationHistoryPageModel.fromJson(json);
}

/// @nodoc
mixin _$RecommendationHistoryPageModel {
  List<RecommendationLogModel> get content =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'number')
  int get number => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get last => throw _privateConstructorUsedError;

  /// Serializes this RecommendationHistoryPageModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationHistoryPageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationHistoryPageModelCopyWith<RecommendationHistoryPageModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationHistoryPageModelCopyWith<$Res> {
  factory $RecommendationHistoryPageModelCopyWith(
          RecommendationHistoryPageModel value,
          $Res Function(RecommendationHistoryPageModel) then) =
      _$RecommendationHistoryPageModelCopyWithImpl<$Res,
          RecommendationHistoryPageModel>;
  @useResult
  $Res call(
      {List<RecommendationLogModel> content,
      @JsonKey(name: 'number') int number,
      int size,
      int totalElements,
      int totalPages,
      bool last});
}

/// @nodoc
class _$RecommendationHistoryPageModelCopyWithImpl<$Res,
        $Val extends RecommendationHistoryPageModel>
    implements $RecommendationHistoryPageModelCopyWith<$Res> {
  _$RecommendationHistoryPageModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationHistoryPageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? number = null,
    Object? size = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? last = null,
  }) {
    return _then(_value.copyWith(
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as List<RecommendationLogModel>,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
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
abstract class _$$RecommendationHistoryPageModelImplCopyWith<$Res>
    implements $RecommendationHistoryPageModelCopyWith<$Res> {
  factory _$$RecommendationHistoryPageModelImplCopyWith(
          _$RecommendationHistoryPageModelImpl value,
          $Res Function(_$RecommendationHistoryPageModelImpl) then) =
      __$$RecommendationHistoryPageModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<RecommendationLogModel> content,
      @JsonKey(name: 'number') int number,
      int size,
      int totalElements,
      int totalPages,
      bool last});
}

/// @nodoc
class __$$RecommendationHistoryPageModelImplCopyWithImpl<$Res>
    extends _$RecommendationHistoryPageModelCopyWithImpl<$Res,
        _$RecommendationHistoryPageModelImpl>
    implements _$$RecommendationHistoryPageModelImplCopyWith<$Res> {
  __$$RecommendationHistoryPageModelImplCopyWithImpl(
      _$RecommendationHistoryPageModelImpl _value,
      $Res Function(_$RecommendationHistoryPageModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationHistoryPageModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? content = null,
    Object? number = null,
    Object? size = null,
    Object? totalElements = null,
    Object? totalPages = null,
    Object? last = null,
  }) {
    return _then(_$RecommendationHistoryPageModelImpl(
      content: null == content
          ? _value._content
          : content // ignore: cast_nullable_to_non_nullable
              as List<RecommendationLogModel>,
      number: null == number
          ? _value.number
          : number // ignore: cast_nullable_to_non_nullable
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
class _$RecommendationHistoryPageModelImpl
    extends _RecommendationHistoryPageModel {
  const _$RecommendationHistoryPageModelImpl(
      {required final List<RecommendationLogModel> content,
      @JsonKey(name: 'number') required this.number,
      required this.size,
      required this.totalElements,
      required this.totalPages,
      required this.last})
      : _content = content,
        super._();

  factory _$RecommendationHistoryPageModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$RecommendationHistoryPageModelImplFromJson(json);

  final List<RecommendationLogModel> _content;
  @override
  List<RecommendationLogModel> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  @override
  @JsonKey(name: 'number')
  final int number;
  @override
  final int size;
  @override
  final int totalElements;
  @override
  final int totalPages;
  @override
  final bool last;

  @override
  String toString() {
    return 'RecommendationHistoryPageModel(content: $content, number: $number, size: $size, totalElements: $totalElements, totalPages: $totalPages, last: $last)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationHistoryPageModelImpl &&
            const DeepCollectionEquality().equals(other._content, _content) &&
            (identical(other.number, number) || other.number == number) &&
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
      number,
      size,
      totalElements,
      totalPages,
      last);

  /// Create a copy of RecommendationHistoryPageModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationHistoryPageModelImplCopyWith<
          _$RecommendationHistoryPageModelImpl>
      get copyWith => __$$RecommendationHistoryPageModelImplCopyWithImpl<
          _$RecommendationHistoryPageModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecommendationHistoryPageModelImplToJson(
      this,
    );
  }
}

abstract class _RecommendationHistoryPageModel
    extends RecommendationHistoryPageModel {
  const factory _RecommendationHistoryPageModel(
      {required final List<RecommendationLogModel> content,
      @JsonKey(name: 'number') required final int number,
      required final int size,
      required final int totalElements,
      required final int totalPages,
      required final bool last}) = _$RecommendationHistoryPageModelImpl;
  const _RecommendationHistoryPageModel._() : super._();

  factory _RecommendationHistoryPageModel.fromJson(Map<String, dynamic> json) =
      _$RecommendationHistoryPageModelImpl.fromJson;

  @override
  List<RecommendationLogModel> get content;
  @override
  @JsonKey(name: 'number')
  int get number;
  @override
  int get size;
  @override
  int get totalElements;
  @override
  int get totalPages;
  @override
  bool get last;

  /// Create a copy of RecommendationHistoryPageModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationHistoryPageModelImplCopyWith<
          _$RecommendationHistoryPageModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
