// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation_history_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecommendationHistoryPage {
  List<RecommendationLog> get content => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get size => throw _privateConstructorUsedError;
  int get totalElements => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  bool get last => throw _privateConstructorUsedError;

  /// Create a copy of RecommendationHistoryPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecommendationHistoryPageCopyWith<RecommendationHistoryPage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecommendationHistoryPageCopyWith<$Res> {
  factory $RecommendationHistoryPageCopyWith(RecommendationHistoryPage value,
          $Res Function(RecommendationHistoryPage) then) =
      _$RecommendationHistoryPageCopyWithImpl<$Res, RecommendationHistoryPage>;
  @useResult
  $Res call(
      {List<RecommendationLog> content,
      int page,
      int size,
      int totalElements,
      int totalPages,
      bool last});
}

/// @nodoc
class _$RecommendationHistoryPageCopyWithImpl<$Res,
        $Val extends RecommendationHistoryPage>
    implements $RecommendationHistoryPageCopyWith<$Res> {
  _$RecommendationHistoryPageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecommendationHistoryPage
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
              as List<RecommendationLog>,
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
abstract class _$$RecommendationHistoryPageImplCopyWith<$Res>
    implements $RecommendationHistoryPageCopyWith<$Res> {
  factory _$$RecommendationHistoryPageImplCopyWith(
          _$RecommendationHistoryPageImpl value,
          $Res Function(_$RecommendationHistoryPageImpl) then) =
      __$$RecommendationHistoryPageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<RecommendationLog> content,
      int page,
      int size,
      int totalElements,
      int totalPages,
      bool last});
}

/// @nodoc
class __$$RecommendationHistoryPageImplCopyWithImpl<$Res>
    extends _$RecommendationHistoryPageCopyWithImpl<$Res,
        _$RecommendationHistoryPageImpl>
    implements _$$RecommendationHistoryPageImplCopyWith<$Res> {
  __$$RecommendationHistoryPageImplCopyWithImpl(
      _$RecommendationHistoryPageImpl _value,
      $Res Function(_$RecommendationHistoryPageImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecommendationHistoryPage
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
    return _then(_$RecommendationHistoryPageImpl(
      content: null == content
          ? _value._content
          : content // ignore: cast_nullable_to_non_nullable
              as List<RecommendationLog>,
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

class _$RecommendationHistoryPageImpl implements _RecommendationHistoryPage {
  const _$RecommendationHistoryPageImpl(
      {required final List<RecommendationLog> content,
      required this.page,
      required this.size,
      required this.totalElements,
      required this.totalPages,
      required this.last})
      : _content = content;

  final List<RecommendationLog> _content;
  @override
  List<RecommendationLog> get content {
    if (_content is EqualUnmodifiableListView) return _content;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_content);
  }

  @override
  final int page;
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
    return 'RecommendationHistoryPage(content: $content, page: $page, size: $size, totalElements: $totalElements, totalPages: $totalPages, last: $last)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecommendationHistoryPageImpl &&
            const DeepCollectionEquality().equals(other._content, _content) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.totalElements, totalElements) ||
                other.totalElements == totalElements) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.last, last) || other.last == last));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_content),
      page,
      size,
      totalElements,
      totalPages,
      last);

  /// Create a copy of RecommendationHistoryPage
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecommendationHistoryPageImplCopyWith<_$RecommendationHistoryPageImpl>
      get copyWith => __$$RecommendationHistoryPageImplCopyWithImpl<
          _$RecommendationHistoryPageImpl>(this, _$identity);
}

abstract class _RecommendationHistoryPage implements RecommendationHistoryPage {
  const factory _RecommendationHistoryPage(
      {required final List<RecommendationLog> content,
      required final int page,
      required final int size,
      required final int totalElements,
      required final int totalPages,
      required final bool last}) = _$RecommendationHistoryPageImpl;

  @override
  List<RecommendationLog> get content;
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

  /// Create a copy of RecommendationHistoryPage
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecommendationHistoryPageImplCopyWith<_$RecommendationHistoryPageImpl>
      get copyWith => throw _privateConstructorUsedError;
}
