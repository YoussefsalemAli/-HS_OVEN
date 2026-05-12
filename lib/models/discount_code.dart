// class DiscountCode {
//   final String code;
//   final double percentage; // 0-100
//   final bool isActive;
//   final String? description;

//   const DiscountCode({
//     required this.code,
//     required this.percentage,
//     this.isActive = true,
//     this.description,
//   });

//   Map<String, dynamic> toJson() => {
//     'code': code,
//     'percentage': percentage,
//     'isActive': isActive,
//     'description': description,
//   };

//   factory DiscountCode.fromJson(Map<String, dynamic> json) => DiscountCode(
//     code: json['code'],
//     percentage: json['percentage'].toDouble(),
//     isActive: json['isActive'] ?? true,
//     description: json['description'],
//   );
// }
