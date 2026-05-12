// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/product.dart';
// import '../providers/cart_provider.dart';
// import '../utils/app_theme.dart';

// class ProductCard extends StatefulWidget {
//   final Product product;
//   const ProductCard({super.key, required this.product});

//   @override
//   State<ProductCard> createState() => _ProductCardState();
// }

// class _ProductCardState extends State<ProductCard> with SingleTickerProviderStateMixin {
//   late AnimationController _bounceController;
//   late Animation<double> _bounceAnim;
//   int _selectedSizeIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     _bounceController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );
//     _bounceAnim = Tween<double>(begin: 1.0, end: 1.12).animate(
//       CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
//     );
//   }

//   @override
//   void dispose() {
//     _bounceController.dispose();
//     super.dispose();
//   }

//   void _addToCart() {
//     final cart = context.read<CartProvider>();
//     cart.addItem(widget.product, widget.product.sizes[_selectedSizeIndex]);
//     _bounceController.forward().then((_) => _bounceController.reverse());

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             const Icon(Icons.check_circle, color: Colors.white),
//             const SizedBox(width: 8),
//             Text(
//               'تم إضافة ${widget.product.name} للسلة! 🎉',
//               style: const TextStyle(fontFamily: 'Cairo'),
//             ),
//           ],
//         ),
//         backgroundColor: AppTheme.warmBrown,
//         duration: const Duration(seconds: 2),
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selectedSize = widget.product.sizes[_selectedSizeIndex];

//     return AnimatedBuilder(
//       animation: _bounceAnim,
//       builder: (context, child) => Transform.scale(
//         scale: _bounceAnim.value,
//         child: child,
//       ),
//       child: Card(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Product image area
//             Expanded(
//               flex: 3,
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [
//                       AppTheme.cream,
//                       AppTheme.gold.withOpacity(0.2),
//                     ],
//                   ),
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//                 ),
//                 child: Center(
//                   child: Text(
//                     widget.product.emoji,
//                     style: const TextStyle(fontSize: 72),
//                   ),
//                 ),
//               ),
//             ),

//             // Info
//             Expanded(
//               flex: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       widget.product.name,
//                       style: const TextStyle(
//                         fontFamily: 'Cairo',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                         color: AppTheme.darkBrown,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       widget.product.description,
//                       style: const TextStyle(
//                         fontFamily: 'Cairo',
//                         fontSize: 12,
//                         color: AppTheme.textMid,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 10),

//                     // Size selector
//                     Row(
//                       children: List.generate(widget.product.sizes.length, (i) {
//                         final size = widget.product.sizes[i];
//                         final isSelected = i == _selectedSizeIndex;
//                         return Expanded(
//                           child: GestureDetector(
//                             onTap: () => setState(() => _selectedSizeIndex = i),
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 200),
//                               margin: EdgeInsets.only(left: i == 0 ? 0 : 6),
//                               padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//                               decoration: BoxDecoration(
//                                 color: isSelected ? AppTheme.warmBrown : Colors.white,
//                                 borderRadius: BorderRadius.circular(8),
//                                 border: Border.all(
//                                   color: isSelected ? AppTheme.warmBrown : AppTheme.border,
//                                 ),
//                               ),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     size.label,
//                                     style: TextStyle(
//                                       fontFamily: 'Cairo',
//                                       fontSize: 11,
//                                       fontWeight: FontWeight.bold,
//                                       color: isSelected ? Colors.white : AppTheme.textMid,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                   Text(
//                                     '${size.price.toStringAsFixed(0)} ج',
//                                     style: TextStyle(
//                                       fontFamily: 'Cairo',
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.bold,
//                                       color: isSelected ? AppTheme.gold : AppTheme.caramel,
//                                     ),
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),

//                     const Spacer(),

//                     // Add to cart button
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: _addToCart,
//                         icon: const Icon(Icons.add_shopping_cart, size: 18),
//                         label: const Text('أضف للسلة'),
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 10),
//                           textStyle: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
