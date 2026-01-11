class Category {
  final String id;
  final String categoryId;
  final String name;
  final String? description;
  final String? color;
  final String? icon;

  Category({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.color,
    required this.icon,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['_id'] as String,
        categoryId: json['categoryId'] ?? '',
        name: json['name'] as String,
        description: json['description'] as String?,
        color: json['color'] as String?,
        icon: json['icon'] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'description': description,
      'color': color,
      'icon': icon,
    };
  }
}
