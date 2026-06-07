class Food {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final String category;
  final bool isAvailable;

  Food({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.category,
    required this.isAvailable,
  });

  // Factory constructor for creating Food from JSON
  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool,
    );
  }

  // Convert Food to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
      'isAvailable': isAvailable,
    };
  }

  // Copy with method for creating modified copies
  Food copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    double? rating,
    int? reviewCount,
    String? category,
    bool? isAvailable,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  @override
  String toString() {
    return 'Food(id: $id, name: $name, price: $price, rating: $rating)';
  }
}
