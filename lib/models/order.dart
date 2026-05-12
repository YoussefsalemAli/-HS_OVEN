// import 'cart_item.dart';

// enum PaymentMethod { instapay, cash }
// enum DeliveryMethod { delivery, pickup }

// class Order {
//   final String id;
//   final List<CartItem> items;
//   final String customerName;
//   final String customerPhone;
//   final String? customerAddress;
//   final PaymentMethod paymentMethod;
//   final DeliveryMethod deliveryMethod;
//   final double deliveryFee;
//   final double discount;
//   final String? discountCode;
//   final double subtotal;
//   final double total;
//   final DateTime createdAt;

//   Order({
//     required this.id,
//     required this.items,
//     required this.customerName,
//     required this.customerPhone,
//     this.customerAddress,
//     required this.paymentMethod,
//     required this.deliveryMethod,
//     this.deliveryFee = 0,
//     this.discount = 0,
//     this.discountCode,
//     required this.subtotal,
//     required this.total,
//     required this.createdAt,
//   });

//   String toWhatsAppMessage() {
//     final buffer = StringBuffer();
//     buffer.writeln('🍪 *طلب جديد - H Oven*');
//     buffer.writeln('─────────────────');
//     buffer.writeln('👤 الاسم: $customerName');
//     buffer.writeln('📞 التليفون: $customerPhone');
//     if (customerAddress != null && customerAddress!.isNotEmpty) {
//       buffer.writeln('📍 العنوان: $customerAddress');
//     }
//     buffer.writeln('─────────────────');
//     buffer.writeln('🛒 *المنتجات:*');
//     for (final item in items) {
//       buffer.writeln('• ${item.product.name} (${item.size.label}) × ${item.quantity} = ${(item.total).toStringAsFixed(0)} جنيه');
//     }
//     buffer.writeln('─────────────────');
//     buffer.writeln('💰 الإجمالي: ${subtotal.toStringAsFixed(0)} جنيه');
//     if (discount > 0) {
//       buffer.writeln('🎁 خصم ($discountCode): -${discount.toStringAsFixed(0)} جنيه');
//     }
//     if (deliveryFee > 0) {
//       buffer.writeln('🚗 توصيل: ${deliveryFee.toStringAsFixed(0)} جنيه');
//     }
//     buffer.writeln('✅ *الإجمالي النهائي: ${total.toStringAsFixed(0)} جنيه*');
//     buffer.writeln('─────────────────');
//     buffer.writeln('💳 طريقة الدفع: ${paymentMethod == PaymentMethod.instapay ? "إنستاباي" : "كاش"}');
//     buffer.writeln('🚗 طريقة الاستلام: ${deliveryMethod == DeliveryMethod.delivery ? "توصيل" : "استلام من المحل"}');
//     return buffer.toString();
//   }
// }
