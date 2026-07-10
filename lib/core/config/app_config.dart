import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class AppConfig {
  AppConfig._();

  // Android emulator maps host loopback to 10.0.2.2; every other target
  // (desktop, web, iOS simulator) can reach the backend via localhost.
  static String get _host {
    if (!kIsWeb && Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get userServiceUrl => 'http://$_host:8081';
  static String get restaurantServiceUrl => 'http://$_host:8082';
  static String get orderServiceUrl => 'http://$_host:8083';
  static String get menuServiceUrl => 'http://$_host:8084';
  static String get paymentServiceUrl => 'http://$_host:8085';
  static String get recommendationServiceUrl => 'http://$_host:8086';
  static String get notificationServiceUrl => 'http://$_host:8087';
}
