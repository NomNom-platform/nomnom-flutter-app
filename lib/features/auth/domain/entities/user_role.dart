enum UserRole {
  customer,
  restaurantOwner,
  admin;

  String get apiValue => switch (this) {
        UserRole.customer => 'CUSTOMER',
        UserRole.restaurantOwner => 'RESTAURANT_OWNER',
        UserRole.admin => 'ADMIN',
      };

  static UserRole fromApiValue(String value) => switch (value) {
        'RESTAURANT_OWNER' => UserRole.restaurantOwner,
        'ADMIN' => UserRole.admin,
        _ => UserRole.customer,
      };
}
