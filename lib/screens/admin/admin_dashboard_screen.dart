// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/admin_provider.dart';
// import '../../providers/products_provider.dart';
// import '../../models/product.dart';
// import '../../models/discount_code.dart';
// import '../../utils/app_theme.dart';
// import 'edit_product_screen.dart';
// import 'add_product_screen.dart';

// class AdminDashboardScreen extends StatefulWidget {
//   const AdminDashboardScreen({super.key});

//   @override
//   State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
// }

// class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final admin = context.watch<AdminProvider>();
//     final products = context.watch<ProductsProvider>();

//     if (!admin.isLoggedIn) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.of(context).pop();
//       });
//       return const SizedBox();
//     }

//     return Scaffold(
//       backgroundColor: AppTheme.lightCream,
//       appBar: AppBar(
//         title: const Text('لوحة التحكم', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
//         backgroundColor: AppTheme.darkBrown,
//         foregroundColor: Colors.white,
//         actions: [
//           TextButton.icon(
//             onPressed: () async {
//               await admin.logout();
//               if (context.mounted) Navigator.of(context).pop();
//             },
//             icon: const Icon(Icons.logout, color: Colors.white70, size: 18),
//             label: const Text('خروج', style: TextStyle(color: Colors.white70, fontFamily: 'Cairo')),
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: AppTheme.gold,
//           labelColor: AppTheme.gold,
//           unselectedLabelColor: Colors.white60,
//           labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
//           tabs: const [
//             Tab(text: 'المنتجات'),
//             Tab(text: 'الأكواد'),
//             Tab(text: 'الإعدادات'),
//           ],
//         ),
//       ),
//       body: TabBarView(
//         controller: _tabController,
//         children: [
//           // === PRODUCTS TAB ===
//           _ProductsTab(products: products),

//           // === DISCOUNT CODES TAB ===
//           _DiscountCodesTab(products: products),

//           // === SETTINGS TAB ===
//           _SettingsTab(products: products),
//         ],
//       ),

//       floatingActionButton: _tabController.index == 0
//           ? FloatingActionButton.extended(
//               onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddProductScreen())),
//               backgroundColor: AppTheme.warmBrown,
//               icon: const Icon(Icons.add, color: Colors.white),
//               label: const Text('منتج جديد', style: TextStyle(fontFamily: 'Cairo', color: Colors.white)),
//             )
//           : null,
//     );
//   }
// }

// // ==================== PRODUCTS TAB ====================
// class _ProductsTab extends StatelessWidget {
//   final ProductsProvider products;
//   const _ProductsTab({required this.products});

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         ...products.allProducts.map((product) => _ProductAdminCard(product: product)),
//       ],
//     );
//   }
// }

// class _ProductAdminCard extends StatelessWidget {
//   final Product product;
//   const _ProductAdminCard({required this.product});

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.read<ProductsProvider>();
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       child: Padding(
//         padding: const EdgeInsets.all(14),
//         child: Row(
//           children: [
//             Text(product.emoji, style: const TextStyle(fontSize: 40)),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           product.name,
//                           style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.darkBrown),
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                         decoration: BoxDecoration(
//                           color: product.category == 'cinnabon' ? AppTheme.caramel.withOpacity(0.2) : AppTheme.warmBrown.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                         child: Text(
//                           product.category == 'cinnabon' ? 'سينابون' : 'كوكيز',
//                           style: TextStyle(fontFamily: 'Cairo', fontSize: 11, color: AppTheme.warmBrown),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   ...product.sizes.map((s) => Text(
//                     '${s.label}: ${s.price.toStringAsFixed(0)} جنيه',
//                     style: const TextStyle(fontFamily: 'Cairo', color: AppTheme.caramel, fontSize: 13),
//                   )),
//                 ],
//               ),
//             ),
//             Column(
//               children: [
//                 Switch(
//                   value: product.isAvailable,
//                   onChanged: (_) => provider.toggleProductAvailability(product.id),
//                   activeColor: AppTheme.warmBrown,
//                 ),
//                 Text(
//                   product.isAvailable ? 'متاح' : 'مخفي',
//                   style: TextStyle(
//                     fontFamily: 'Cairo',
//                     fontSize: 11,
//                     color: product.isAvailable ? Colors.green : Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: AppTheme.caramel),
//                   onPressed: () => Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (_) => EditProductScreen(product: product)),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ==================== DISCOUNT CODES TAB ====================
// class _DiscountCodesTab extends StatefulWidget {
//   final ProductsProvider products;
//   const _DiscountCodesTab({required this.products});

//   @override
//   State<_DiscountCodesTab> createState() => _DiscountCodesTabState();
// }

// class _DiscountCodesTabState extends State<_DiscountCodesTab> {
//   final _codeCtrl = TextEditingController();
//   final _percentCtrl = TextEditingController();
//   final _descCtrl = TextEditingController();

//   void _addCode() {
//     if (_codeCtrl.text.isEmpty || _percentCtrl.text.isEmpty) return;
//     final pct = double.tryParse(_percentCtrl.text);
//     if (pct == null || pct <= 0 || pct > 100) return;
//     widget.products.addDiscountCode(DiscountCode(
//       code: _codeCtrl.text.trim().toUpperCase(),
//       percentage: pct,
//       description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
//     ));
//     _codeCtrl.clear();
//     _percentCtrl.clear();
//     _descCtrl.clear();
//     FocusScope.of(context).unfocus();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final codes = widget.products.discountCodes;
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         // Add new code
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppTheme.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: AppTheme.border.withOpacity(0.5)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('إضافة كود خصم جديد', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15, color: AppTheme.darkBrown)),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: _codeCtrl,
//                 decoration: const InputDecoration(labelText: 'الكود (مثال: SAVE20)', prefixIcon: Icon(Icons.local_offer)),
//                 style: const TextStyle(fontFamily: 'Cairo'),
//                 textCapitalization: TextCapitalization.characters,
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: _percentCtrl,
//                 decoration: const InputDecoration(labelText: 'نسبة الخصم %', prefixIcon: Icon(Icons.percent)),
//                 style: const TextStyle(fontFamily: 'Cairo'),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 10),
//               TextField(
//                 controller: _descCtrl,
//                 decoration: const InputDecoration(labelText: 'وصف (اختياري)', prefixIcon: Icon(Icons.description)),
//                 style: const TextStyle(fontFamily: 'Cairo'),
//               ),
//               const SizedBox(height: 14),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   onPressed: _addCode,
//                   icon: const Icon(Icons.add),
//                   label: const Text('إضافة الكود', style: TextStyle(fontFamily: 'Cairo')),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         const SizedBox(height: 20),
//         const Text('الأكواد الحالية', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.darkBrown)),
//         const SizedBox(height: 12),

//         if (codes.isEmpty)
//           const Center(child: Padding(
//             padding: EdgeInsets.all(24),
//             child: Text('لا توجد أكواد', style: TextStyle(fontFamily: 'Cairo', color: AppTheme.textMid)),
//           )),

//         ...codes.map((c) => Card(
//           margin: const EdgeInsets.only(bottom: 10),
//           child: ListTile(
//             leading: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(color: AppTheme.gold.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
//               child: const Icon(Icons.local_offer, color: AppTheme.caramel),
//             ),
//             title: Text(c.code, style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: AppTheme.darkBrown)),
//             subtitle: Text('خصم ${c.percentage.toStringAsFixed(0)}%${c.description != null ? ' - ${c.description}' : ''}', style: const TextStyle(fontFamily: 'Cairo', fontSize: 13)),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () => widget.products.removeDiscountCode(c.code),
//             ),
//           ),
//         )),
//       ],
//     );
//   }
// }

// // ==================== SETTINGS TAB ====================
// class _SettingsTab extends StatefulWidget {
//   final ProductsProvider products;
//   const _SettingsTab({required this.products});

//   @override
//   State<_SettingsTab> createState() => _SettingsTabState();
// }

// class _SettingsTabState extends State<_SettingsTab> {
//   late TextEditingController _deliveryCtrl;

//   @override
//   void initState() {
//     super.initState();
//     _deliveryCtrl = TextEditingController(text: widget.products.deliveryFee.toStringAsFixed(0));
//   }

//   @override
//   void dispose() {
//     _deliveryCtrl.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: AppTheme.cardBg,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: AppTheme.border.withOpacity(0.5)),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Row(
//                 children: [
//                   Icon(Icons.delivery_dining, color: AppTheme.caramel),
//                   SizedBox(width: 8),
//                   Text('سعر التوصيل', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.darkBrown)),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: _deliveryCtrl,
//                 decoration: const InputDecoration(labelText: 'سعر التوصيل (جنيه)', suffixText: 'جنيه'),
//                 style: const TextStyle(fontFamily: 'Cairo'),
//                 keyboardType: TextInputType.number,
//               ),
//               const SizedBox(height: 12),
//               ElevatedButton(
//                 onPressed: () {
//                   final fee = double.tryParse(_deliveryCtrl.text);
//                   if (fee != null && fee >= 0) {
//                     widget.products.updateDeliveryFee(fee);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('تم حفظ سعر التوصيل ✅', style: TextStyle(fontFamily: 'Cairo')), backgroundColor: Colors.green),
//                     );
//                   }
//                 },
//                 child: const Text('حفظ', style: TextStyle(fontFamily: 'Cairo')),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
