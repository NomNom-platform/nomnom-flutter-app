import 'package:freezed_annotation/freezed_annotation.dart';
import 'recommendation_log.dart';

part 'recommendation_history_page.freezed.dart';

/// Wraps Spring's default `Page<T>` shape (content/totalElements/etc.)
/// returned as-is by `GET /api/recommendations/history`.
@freezed
class RecommendationHistoryPage with _$RecommendationHistoryPage {
  const factory RecommendationHistoryPage({
    required List<RecommendationLog> content,
    required int page,
    required int size,
    required int totalElements,
    required int totalPages,
    required bool last,
  }) = _RecommendationHistoryPage;
}
