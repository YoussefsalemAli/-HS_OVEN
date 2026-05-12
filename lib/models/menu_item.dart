class MenuItem {
  final int id;
  String name;
  String description;
  String weight;
  int price;
  int? originalPrice;
  String emoji;
  bool isActive;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.weight,
    required this.price,
    this.originalPrice,
    required this.emoji,
    this.isActive = true,
  });

  int get grams {
    if (weight == '1kg') return 1000;
    return int.tryParse(weight.replaceAll('g', '')) ?? 0;
  }

  // Cost based on 800g = 230 EGP
  int get costPrice => ((grams / 800) * 230).round();
  int get margin => price - costPrice;

  MenuItem copyWith({
    String? name,
    String? description,
    String? weight,
    int? price,
    int? originalPrice,
    String? emoji,
    bool? isActive,
    bool clearOriginalPrice = false,
  }) {
    return MenuItem(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      weight: weight ?? this.weight,
      price: price ?? this.price,
      originalPrice:
          clearOriginalPrice ? null : (originalPrice ?? this.originalPrice),
      emoji: emoji ?? this.emoji,
      isActive: isActive ?? this.isActive,
    );
  }
}

class Voucher {
  String code;
  double discount;
  String type; // 'percent' or 'fixed'
  bool isActive;

  Voucher({
    required this.code,
    required this.discount,
    required this.type,
    this.isActive = true,
  });

  String get label => type == 'percent'
      ? '${discount.toInt()}% off'
      : '${discount.toInt()} EGP off';

  String get displayDiscount => label;
}

class OrderRecord {
  final String id;
  final String name;
  final int total;
  final int cost;
  final List<String> items;
  final String date;
  final String payment;

  OrderRecord({
    required this.id,
    required this.name,
    required this.total,
    required this.cost,
    required this.items,
    required this.date,
    required this.payment,
  });

  int get profit => total - cost;
}
