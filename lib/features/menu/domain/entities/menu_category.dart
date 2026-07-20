/// Fixed menu categories accepted by menu-service. Matches the `Category`
/// union in the `fe` frontend (`MAIN | SIDE | DRINK | DESSERT`).
enum MenuCategory {
  main('MAIN', 'Main'),
  side('SIDE', 'Side'),
  drink('DRINK', 'Drink'),
  dessert('DESSERT', 'Dessert');

  const MenuCategory(this.apiValue, this.label);

  /// Value sent to / received from the backend.
  final String apiValue;

  /// Human-readable label for the UI.
  final String label;

  static MenuCategory fromApi(String value) {
    return MenuCategory.values.firstWhere(
      (c) => c.apiValue == value,
      orElse: () => MenuCategory.main,
    );
  }
}
