import 'package:freezed_annotation/freezed_annotation.dart';

enum OrderStatus {
  @JsonValue('PENDING') pending,
  @JsonValue('ACCEPTED') accepted,
  @JsonValue('PREPARING') preparing,
  @JsonValue('READY_FOR_PICKUP') readyForPickup,
  @JsonValue('OUT_FOR_DELIVERY') outForDelivery,
  @JsonValue('DELIVERED') delivered,
  @JsonValue('CANCELLED') cancelled,
}
