import 'package:freezed_annotation/freezed_annotation.dart';

enum OrderStatus {
  @JsonValue('PENDING') pending,
  @JsonValue('CONFIRMED') confirmed,
  @JsonValue('ACCEPTED') accepted,
  @JsonValue('PREPARING') preparing,
  @JsonValue('READY_FOR_PICKUP') readyForPickup,
  @JsonValue('READY') ready,
  @JsonValue('OUT_FOR_DELIVERY') outForDelivery,
  @JsonValue('DELIVERING') delivering,
  @JsonValue('DELIVERED') delivered,
  @JsonValue('CANCELLED') cancelled,
}
