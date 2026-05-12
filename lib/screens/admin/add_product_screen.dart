// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:uuid/uuid.dart';
// import '../../models/product.dart';
// import '../../providers/products_provider.dart';
// import '../../utils/app_theme.dart';

// class AddProductScreen extends StatefulWidget {
//   const AddProductScreen({super.key});

//   @override
//   State<AddProductScreen> createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   final _nameCtrl = TextEditingController();
//   final _descCtrl = TextEditingController();
//   final _emojiCtrl = TextEditingController(text: '🍪');
//   final _price100Ctrl = TextEditingController();
//   final _price150Ctrl = TextEditingController();
//   String _category = 'cookies';

//   @override
//   void dispose() {
//     _nameCtrl.dispose(); _descCtrl.dispose(); _emojiCtrl.dispose();
//     _price100Ctrl.dispose(); _price150Ctrl.dispose();
//     super.dispose();
//   }

//   void _save() {
//     if (_nameCtrl.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('الرجاء إدخال اسم المنتج', style: TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.red),
//       );
//       return;
//     }
//     final p100 = double.tryParse(_price100Ctrl.text) ?? 65;
//     final p150 = double.tryParse(_price150Ctrl.text) ?? 90;

//     final product = Product(
//       id: const Uuid().v4(),
//       name: _nameCtrl.text.trim(),
//       description: _descCtrl.text.trim().isEmpty ? 'منتج لذيذ من H Oven' : _descCtrl.text.trim(),
//       emoji: _emojiCtrl.text.trim().isEmpty ? '🍪' : _emojiCtrl.text.trim(),
//       category: _category,
//       sizes: [
//         ProductSize(label: '100 جم', weight: 100, price: p100, boxCost: 7),
//         ProductSize(label: '150 جم', weight: 150, price: p150, boxCost: 8),
//       ],
//     );

//     context.read<ProductsProvider>().addProduct(product);
//     Navigator.pop(context);
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('تم إضافة المنتج ✅', style: TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.green),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.lightCream,
//       appBar: AppBar(
//         title: const Text('منتج جديد', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
//         backgroundColor: AppTheme.warmBrown,
//         foregroundColor: Colors.white,
//         actions: [
//           TextButton(
//             onPressed: _save,
//             child: const Text('إضافة', style: TextStyle(color: AppTheme.gold, fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16)),
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Category
//           const Text('الفئة', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: AppTheme.darkBrown)),
//           const SizedBox(height: 8),
//           Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => setState(() => _category = 'cinnabon'),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     decoration: BoxDecoration(
//                       color: _category == 'cinnabon' ? AppTheme.warmBrown : AppTheme.cardBg,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: _category == 'cinnabon' ? AppTheme.warmBrown : AppTheme.border),
//                     ),
//                     child: Column(
//                       children: [
//                         const Text('🌀', style: TextStyle(fontSize: 28)),
//                         Text('سينابون', style: TextStyle(fontFamily: 'Cairo', color: _category == 'cinnabon' ? Colors.white : AppTheme.textMid, fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => setState(() => _category = 'cookies'),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     decoration: BoxDecoration(
//                       color: _category == 'cookies' ? AppTheme.warmBrown : AppTheme.cardBg,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: _category == 'cookies' ? AppTheme.warmBrown : AppTheme.border),
//                     ),
//                     child: Column(
//                       children: [
//                         const Text('🍪', style: TextStyle(fontSize: 28)),
//                         Text('كوكيز', style: TextStyle(fontFamily: 'Cairo', color: _category == 'cookies' ? Colors.white : AppTheme.textMid, fontWeight: FontWeight.bold)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),
//           TextField(controller: _emojiCtrl, decoration: const InputDecoration(labelText: 'الإيموجي'), style: const TextStyle(fontFamily: 'Cairo', fontSize: 20)),
//           const SizedBox(height: 12),
//           TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'اسم المنتج *'), style: const TextStyle(fontFamily: 'Cairo')),
//           const SizedBox(height: 12),
//           TextField(controller: _descCtrl, decoration: const InputDecoration(labelText: 'الوصف'), style: const TextStyle(fontFamily: 'Cairo'), maxLines: 2),
//           const SizedBox(height: 20),
//           const Text('الأسعار', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.darkBrown)),
//           const SizedBox(height: 12),
//           TextField(controller: _price100Ctrl, decoration: const InputDecoration(labelText: 'سعر 100 جم (جنيه)', hintText: '65'), style: const TextStyle(fontFamily: 'Cairo'), keyboardType: TextInputType.number),
//           const SizedBox(height: 12),
//           TextField(controller: _price150Ctrl, decoration: const InputDecoration(labelText: 'سعر 150 جم (جنيه)', hintText: '90'), style: const TextStyle(fontFamily: 'Cairo'), keyboardType: TextInputType.number),
//           const SizedBox(height: 28),
//           ElevatedButton.icon(
//             onPressed: _save,
//             icon: const Icon(Icons.add),
//             label: const Text('إضافة المنتج', style: TextStyle(fontFamily: 'Cairo', fontSize: 16, fontWeight: FontWeight.bold)),
//             style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
//           ),
//         ],
//       ),
//     );
//   }
// }
