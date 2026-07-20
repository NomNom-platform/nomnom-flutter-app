import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/recommendation_history_page.dart';
import 'recommendation_log_model.dart';

part 'recommendation_history_page_model.freezed.dart';
part 'recommendation_history_page_model.g.dart';

/// Mirrors Spring Data's default `Page<T>` JSON shape returned as-is by
/// `GET /api/recommendations/history` (note the field is `number`, not
/// `page` — Spring's convention, kept faithful to the wire format here).
@freezed
class RecommendationHistoryPageModel with _$RecommendationHistoryPageModel {
  const RecommendationHistoryPageModel._();

  const factory RecommendationHistoryPageModel({
    required List<RecommendationLogModel> content,
    @JsonKey(name: 'number') required int number,
    required int size,
    required int totalElements,
    required int totalPages,
    required bool last,
  }) = _RecommendationHistoryPageModel;

  factory RecommendationHistoryPageModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationHistoryPageModelFromJson(json);

  RecommendationHistoryPage toEntity() => RecommendationHistoryPage(
        content: content.map((e) => e.toEntity()).toList(),
        page: number,
        size: size,
        totalElements: totalElements,
        totalPages: totalPages,
        last: last,
      );
}
