import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/recommendation_result.dart';

part 'recommendation_state.freezed.dart';

@freezed
class RecommendationState with _$RecommendationState {
  const factory RecommendationState({
    @Default(false) bool isLoading,
    Failure? failure,
    RecommendationResult? result,
  }) = _RecommendationState;
}
