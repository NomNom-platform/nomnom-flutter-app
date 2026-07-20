enum MealType {
  breakfast,
  lunch,
  dinner,
  snack;

  String get apiValue => switch (this) {
        MealType.breakfast => 'BREAKFAST',
        MealType.lunch => 'LUNCH',
        MealType.dinner => 'DINNER',
        MealType.snack => 'SNACK',
      };

  String get label => switch (this) {
        MealType.breakfast => 'Breakfast',
        MealType.lunch => 'Lunch',
        MealType.dinner => 'Dinner',
        MealType.snack => 'Snack',
      };

  static MealType fromApiValue(String value) => switch (value) {
        'BREAKFAST' => MealType.breakfast,
        'DINNER' => MealType.dinner,
        'SNACK' => MealType.snack,
        _ => MealType.lunch,
      };
}
