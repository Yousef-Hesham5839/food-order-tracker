import '../../domain/entities/menu_item_entity.dart';

class MenuItemModel extends MenuItemEntity {
  const MenuItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.category,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json, String docId) {
    double parsePrice(dynamic val) {
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    return MenuItemModel(
      id: docId,
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: parsePrice(json['price']),
      imageUrl: json['imageUrl']?.toString() ?? '',
      category: json['category']?.toString() ?? 'General',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
    };
  }
}