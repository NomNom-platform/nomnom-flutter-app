/// Fields the owner can edit on a restaurant profile. Matches the
/// `RestaurantPayload` shape used by the `fe` frontend (no operating hours).
class RestaurantInput {
  final String name;
  final String description;
  final String address;
  final String phone;
  final String cuisineType;
  final String imageUrl;

  const RestaurantInput({
    required this.name,
    required this.description,
    required this.address,
    required this.phone,
    required this.cuisineType,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'address': address,
        'phone': phone,
        'cuisineType': cuisineType,
        'imageUrl': imageUrl,
      };
}
