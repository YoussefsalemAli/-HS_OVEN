import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../models/order.dart';
import '../utils/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  PaymentMethod _paymentMethod = PaymentMethod.cash;
  DeliveryMethod _deliveryMethod = DeliveryMethod.pickup;

  // ← Put your WhatsApp number and Instapay number here
  static const String _whatsappNumber = '201128312692';
  static const String _instapayNumber = '201128312692';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  double get deliveryFee =>
      _deliveryMethod == DeliveryMethod.delivery
          ? context.read<ProductsProvider>().deliveryFee
          : 0;

  Future<void> _placeOrder(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    if (_deliveryMethod == DeliveryMethod.delivery && _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال عنوان التوصيل', style: TextStyle(fontFamily: 'Cairo')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final cart = context.read<CartProvider>();
    final subtotal = cart.subtotal;
    final discount = cart.discountAmount;
    final total = subtotal - discount + deliveryFee;

    final order = Order(
      id: const Uuid().v4().substring(0, 8).toUpperCase(),
      items: cart.items,
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      customerAddress: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      paymentMethod: _paymentMethod,
      deliveryMethod: _deliveryMethod,
      deliveryFee: deliveryFee,
      discount: discount,
      discountCode: cart.appliedDiscount?.code,
      subtotal: subtotal,
      total: total,
      createdAt: DateTime.now(),
    );

    if (_paymentMethod == PaymentMethod.instapay) {
      // Show Instapay instructions
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Text('💳', style: TextStyle(fontSize: 28)),
              SizedBox(width: 8),
              Text('الدفع بإنستاباي', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('يرجى تحويل المبلغ على:', style: TextStyle(fontFamily: 'Cairo')),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.cream,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.phone, color: AppTheme.warmBrown),
                    const SizedBox(width: 8),
                    Text(
                      _instapayNumber,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: AppTheme.darkBrown,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'المبلغ: ${total.toStringAsFixed(0)} جنيه',
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.warmBrown,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'بعد التحويل، أرسل الطلب على واتساب وسيتم التأكيد.',
                style: TextStyle(fontFamily: 'Cairo', color: AppTheme.textMid, fontSize: 13),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('حسناً، سأكمل الطلب', style: TextStyle(fontFamily: 'Cairo')),
            ),
          ],
        ),
      );
    }

    // Send to WhatsApp
    final message = order.toWhatsAppMessage();
    final encoded = Uri.encodeComponent(message);
    final url = 'https://wa.me/$_whatsappNumber?text=$encoded';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      cart.clear();
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال الطلب! 🎉 سنتواصل معك قريباً', style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذّر فتح واتساب. تأكد من تثبيته.', style: TextStyle(fontFamily: 'Cairo')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = context.watch<ProductsProvider>();
    final subtotal = cart.subtotal;
    final discount = cart.discountAmount;
    final total = subtotal - discount + deliveryFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('إتمام الطلب', style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.warmBrown,
        foregroundColor: Colors.white,
      ),
      backgroundColor: AppTheme.lightCream,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(icon: Icons.person, title: 'بياناتك'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'الاسم الكامل', prefixIcon: Icon(Icons.person_outline)),
                style: const TextStyle(fontFamily: 'Cairo'),
                validator: (v) => v == null || v.isEmpty ? 'الرجاء إدخال الاسم' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'رقم التليفون', prefixIcon: Icon(Icons.phone_outlined)),
                style: const TextStyle(fontFamily: 'Cairo'),
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.length < 10 ? 'رقم تليفون غير صحيح' : null,
              ),

              const SizedBox(height: 24),
              _SectionTitle(icon: Icons.delivery_dining, title: 'طريقة الاستلام'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _OptionTile(
                      title: 'استلام من المحل',
                      subtitle: 'مجاناً',
                      icon: Icons.storefront,
                      selected: _deliveryMethod == DeliveryMethod.pickup,
                      onTap: () => setState(() => _deliveryMethod = DeliveryMethod.pickup),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OptionTile(
                      title: 'توصيل',
                      subtitle: '+${products.deliveryFee.toStringAsFixed(0)} جنيه',
                      icon: Icons.delivery_dining,
                      selected: _deliveryMethod == DeliveryMethod.delivery,
                      onTap: () => setState(() => _deliveryMethod = DeliveryMethod.delivery),
                    ),
                  ),
                ],
              ),
              if (_deliveryMethod == DeliveryMethod.delivery) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    labelText: 'العنوان بالتفصيل',
                    prefixIcon: Icon(Icons.location_on_outlined),
                    hintText: 'الشارع، المنطقة، المدينة',
                  ),
                  style: const TextStyle(fontFamily: 'Cairo'),
                  maxLines: 2,
                ),
              ],

              const SizedBox(height: 24),
              _SectionTitle(icon: Icons.payment, title: 'طريقة الدفع'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _OptionTile(
                      title: 'كاش',
                      subtitle: 'عند الاستلام',
                      icon: Icons.money,
                      selected: _paymentMethod == PaymentMethod.cash,
                      onTap: () => setState(() => _paymentMethod = PaymentMethod.cash),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _OptionTile(
                      title: 'إنستاباي',
                      subtitle: 'تحويل أونلاين',
                      icon: Icons.account_balance_wallet,
                      selected: _paymentMethod == PaymentMethod.instapay,
                      onTap: () => setState(() => _paymentMethod = PaymentMethod.instapay),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              _SectionTitle(icon: Icons.receipt_long, title: 'ملخص الطلب'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border.withOpacity(0.5)),
                ),
                child: Column(
                  children: [
                    _Row('المجموع', '${subtotal.toStringAsFixed(0)} جنيه'),
                    if (discount > 0) _Row('خصم', '-${discount.toStringAsFixed(0)} جنيه', color: Colors.green),
                    if (_deliveryMethod == DeliveryMethod.delivery)
                      _Row('التوصيل', '+${deliveryFee.toStringAsFixed(0)} جنيه', color: AppTheme.caramel),
                    const Divider(height: 20),
                    _Row('الإجمالي', '${total.toStringAsFixed(0)} جنيه', bold: true, big: true),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _placeOrder(context),
                  icon: const Text('💬', style: TextStyle(fontSize: 20)),
                  label: const Text(
                    'إرسال الطلب عبر واتساب',
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color(0xFF25D366),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'سيتم إرسال الطلب لواتساب وسنتواصل معك للتأكيد',
                  style: TextStyle(fontFamily: 'Cairo', color: AppTheme.textMid, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.caramel, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppTheme.darkBrown,
          ),
        ),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _OptionTile({required this.title, required this.subtitle, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppTheme.warmBrown : AppTheme.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppTheme.warmBrown : AppTheme.border,
            width: selected ? 2 : 1,
          ),
          boxShadow: selected
              ? [BoxShadow(color: AppTheme.warmBrown.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppTheme.gold : AppTheme.caramel, size: 28),
            const SizedBox(height: 6),
            Text(title, style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: selected ? Colors.white : AppTheme.darkBrown, fontSize: 14)),
            Text(subtitle, style: TextStyle(fontFamily: 'Cairo', fontSize: 12, color: selected ? AppTheme.cream : AppTheme.textMid)),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool big;
  final Color? color;
  const _Row(this.label, this.value, {this.bold = false, this.big = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'Cairo', fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontSize: big ? 17 : 14)),
          Text(value, style: TextStyle(fontFamily: 'Cairo', fontWeight: bold ? FontWeight.bold : FontWeight.w600, fontSize: big ? 17 : 14, color: color ?? AppTheme.warmBrown)),
        ],
      ),
    );
  }
}
