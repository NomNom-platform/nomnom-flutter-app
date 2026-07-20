/// Fields for creating/updating a menu item. Matches `MenuItemPayload` in the
/// `fe` frontend. All nutrition fields are required by the backend.
class MenuItemInput {
  final String name;
  final String description;
  final double price;
  final int calories;
  final double proteinG;
  final double carbG;
  final double fatG;
  final String category;
  final String imageUrl;
  final bool isAvailable;

  const MenuItemInput({
    required this.name,
    required this.description,
    required this.price,
    required this.calories,
    required this.proteinG,
    required this.carbG,
    required this.fatG,
    required this.category,
    required this.imageUrl,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'calories': calories,
        'proteinG': proteinG,
        'carbG': carbG,
        'fatG': fatG,
        'category': category,
        'imageUrl': imageUrl,
        'isAvailable': isAvailable,
      };
}
