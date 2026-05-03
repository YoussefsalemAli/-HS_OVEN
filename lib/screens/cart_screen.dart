import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../utils/app_theme.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _discountController = TextEditingController();
  String? _discountError;
  String? _discountSuccess;

  @override
  void dispose() {
    _discountController.dispose();
    super.dispose();
  }

  void _applyDiscount(BuildContext context) {
    final code = _discountController.text.trim();
    if (code.isEmpty) return;
    final productsProvider = context.read<ProductsProvider>();
    final cartProvider = context.read<CartProvider>();
    final discount = productsProvider.validateCode(code);
    if (discount != null) {
      cartProvider.applyDiscount(discount);
      setState(() {
        _discountError = null;
        _discountSuccess = 'تم تطبيق خصم ${discount.percentage.toStringAsFixed(0)}%! 🎉';
      });
    } else {
      setState(() {
        _discountSuccess = null;
        _discountError = 'كود الخصم غير صحيح أو منتهي الصلاحية';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = context.watch<ProductsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('سلة التسوق', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.warmBrown,
        foregroundColor: Colors.white,
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: () => cart.clear(),
              child: const Text('مسح الكل', style: TextStyle(color: AppTheme.gold, fontFamily: 'Cairo')),
            ),
        ],
      ),
      backgroundColor: AppTheme.lightCream,
      body: cart.items.isEmpty
          ? _EmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Cart items
                      ...cart.items.map((item) => Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.border.withOpacity(0.5)),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.warmBrown.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(item.product.emoji, style: const TextStyle(fontSize: 40)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.darkBrown,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    item.size.label,
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      color: AppTheme.textMid,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '${item.size.price.toStringAsFixed(0)} جنيه × ${item.quantity}',
                                    style: const TextStyle(
                                      fontFamily: 'Cairo',
                                      color: AppTheme.caramel,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '${item.total.toStringAsFixed(0)} ج',
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.warmBrown,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _QtyButton(
                                      icon: Icons.remove,
                                      onTap: () => cart.decrementItem(item.id),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        '${item.quantity}',
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    _QtyButton(
                                      icon: Icons.add,
                                      onTap: () => cart.incrementItem(item.id),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),

                      const SizedBox(height: 8),

                      // Discount code
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.border.withOpacity(0.5)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.local_offer, color: AppTheme.caramel, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  'كود الخصم',
                                  style: TextStyle(
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkBrown,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (cart.appliedDiscount != null)
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: Colors.green, size: 18),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'خصم ${cart.appliedDiscount!.percentage.toStringAsFixed(0)}% مطبّق ✅',
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 18, color: Colors.red),
                                      onPressed: () {
                                        cart.removeDiscount();
                                        setState(() {
                                          _discountSuccess = null;
                                          _discountController.clear();
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            else
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _discountController,
                                      decoration: InputDecoration(
                                        hintText: 'أدخل كود الخصم',
                                        errorText: _discountError,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                      ),
                                      style: const TextStyle(fontFamily: 'Cairo'),
                                      textCapitalization: TextCapitalization.characters,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () => _applyDiscount(context),
                                    child: const Text('تطبيق'),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.cardBg,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.border.withOpacity(0.5)),
                        ),
                        child: Column(
                          children: [
                            _SummaryRow('المجموع', '${cart.subtotal.toStringAsFixed(0)} جنيه'),
                            if (cart.discountAmount > 0)
                              _SummaryRow(
                                'خصم (${cart.appliedDiscount!.percentage.toStringAsFixed(0)}%)',
                                '-${cart.discountAmount.toStringAsFixed(0)} جنيه',
                                valueColor: Colors.green,
                              ),
                            const Divider(height: 20),
                            _SummaryRow(
                              'الإجمالي (بدون توصيل)',
                              '${(cart.subtotal - cart.discountAmount).toStringAsFixed(0)} جنيه',
                              isBold: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Checkout button
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.warmBrown.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                      ),
                      icon: const Icon(Icons.arrow_back_ios, size: 16),
                      label: const Text('متابعة الطلب', style: TextStyle(fontSize: 18, fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 16, color: AppTheme.warmBrown),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;
  const _SummaryRow(this.label, this.value, {this.isBold = false, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Cairo', fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: isBold ? 16 : 14)),
          Text(value, style: TextStyle(fontFamily: 'Cairo', fontWeight: isBold ? FontWeight.bold : FontWeight.w600, color: valueColor ?? AppTheme.warmBrown, fontSize: isBold ? 16 : 14)),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🧺', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 16),
          const Text(
            'السلة فارغة',
            style: TextStyle(fontFamily: 'Cairo', fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.darkBrown),
          ),
          const SizedBox(height: 8),
          const Text(
            'أضف منتجات لتبدأ الطلب',
            style: TextStyle(fontFamily: 'Cairo', color: AppTheme.textMid, fontSize: 15),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.storefront),
            label: const Text('تسوق الآن'),
          ),
        ],
      ),
    );
  }
}
