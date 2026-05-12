// class ProductSize {
//   final String label; // "100 جم" or "150 جم"
//   final int weight; // grams
//   final double price;
//   final double boxCost;

//   const ProductSize({
//     required this.label,
//     required this.weight,
//     required this.price,
//     required this.boxCost,
//   });

//   Map<String, dynamic> toJson() => {
//     'label': label,
//     'weight': weight,
//     'price': price,
//     'boxCost': boxCost,
//   };

//   factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
//     label: json['label'],
//     weight: json['weight'],
//     price: json['price'].toDouble(),
//     boxCost: json['boxCost'].toDouble(),
//   );
// }

// class Product {
//   final String id;
//   String name;
//   String description;
//   String emoji;
//   List<ProductSize> sizes;
//   bool isAvailable;
//   String category; // 'cinnabon' or 'cookies'

//   Product({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.emoji,
//     required this.sizes,
//     this.isAvailable = true,
//     required this.category,
//   });

//   Map<String, dynamic> toJson() => {
//     'id': id,
//     'name': name,
//     'description': description,
//     'emoji': emoji,
//     'sizes': sizes.map((s) => s.toJson()).toList(),
//     'isAvailable': isAvailable,
//     'category': category,
//   };

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//     id: json['id'],
//     name: json['name'],
//     description: json['description'],
//     emoji: json['emoji'],
//     sizes: (json['sizes'] as List).map((s) => ProductSize.fromJson(s)).toList(),
//     isAvailable: json['isAvailable'] ?? true,
//     category: json['category'],
//   );
// }
