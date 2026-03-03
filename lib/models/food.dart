class Food {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final double? price;

  Food({
    required this.id,
    required this.name,
    required this.description,
    this.imageUrl,
    this.price,
  });

  factory Food.fromMap(Map<String, dynamic> map, String id) {
    return Food(
      id: id,
      name: (map['name'] ?? '') as String,
      description: (map['description'] ?? '') as String,
      imageUrl: map['imageUrl'] as String?,
      price: map['price'] != null ? (map['price'] as num).toDouble() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }
}
