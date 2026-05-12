import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/app_provider.dart';
import '../models/menu_item.dart';
import '../theme.dart';
import '../widgets/common.dart';

class CheckoutScreen extends StatefulWidget {
  final VoidCallback onOrderPlaced;
  const CheckoutScreen({super.key, required this.onOrderPlaced});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  final _voucherCtrl = TextEditingController();
  String _payment = 'cash';
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    _voucherCtrl.dispose();
    super.dispose();
  }

  void _applyVoucher(AppProvider p) {
    final err = p.applyVoucher(_voucherCtrl.text);
    if (err == null) {
      showAppToast(context, 'Voucher applied!');
    } else {
      showAppToast(context, err, isError: true);
    }
  }

  int _discount(int subtotal, Voucher? voucher) {
    if (voucher == null) return 0;
    if (voucher.type == 'percent') {
      return (subtotal * voucher.discount / 100).round();
    }
    return voucher.discount.toInt().clamp(0, subtotal);
  }

  Future<void> _placeOrder(AppProvider p) async {
    if (_nameCtrl.text.trim().isEmpty ||
        _phoneCtrl.text.trim().isEmpty ||
        _addressCtrl.text.trim().isEmpty) {
      showAppToast(context, 'Please fill in all required fields',
          isError: true);
      return;
    }

    setState(() => _loading = true);

    final cartItems = p.cartItems;
    if (cartItems.isEmpty) {
      showAppToast(context, 'Your cart is empty', isError: true);
      setState(() => _loading = false);
      return;
    }

    final subtotal = p.cartSubtotal.toInt();
    final discount = _discount(subtotal, p.appliedVoucher);
    final total = subtotal - discount;

    final itemLines = cartItems.map((i) {
      final qty = p.cartQty(i.id);
      return '• ${i.name} (${i.weight}) x$qty = ${i.price * qty} EGP';
    }).join('\n');

    final paymentLabel = _payment == 'cash' ? 'Cash on Delivery' : 'InstaPay';

    final lines = [
      '🍪 *New Order — H Oven*',
      '',
      '*Name:* ${_nameCtrl.text.trim()}',
      '*Phone:* ${_phoneCtrl.text.trim()}',
      '*Address:* ${_addressCtrl.text.trim()}',
      if (_notesCtrl.text.trim().isNotEmpty)
        '*Notes:* ${_notesCtrl.text.trim()}',
      '',
      '*Order:*',
      itemLines,
      '',
      if (p.appliedVoucher != null)
        '*Voucher:* ${p.appliedVoucher!.code} (−$discount EGP)',
      '*Total:* $total EGP',
      '*Payment:* $paymentLabel',
    ];

    final message = lines.join('\n');
    final url = Uri.parse(
        'https://wa.me/201128312692?text=${Uri.encodeComponent(message)}');

    // Record order
    final cost =
        cartItems.fold<int>(0, (s, i) => s + i.costPrice * p.cartQty(i.id));
    p.addOrder(OrderRecord(
      id: p.nextOrderId,
      name: _nameCtrl.text.trim(),
      total: total,
      cost: cost,
      items: cartItems.map((i) => '${i.name} x${p.cartQty(i.id)}').toList(),
      date: DateTime.now().toIso8601String().substring(0, 10),
      payment: paymentLabel,
    ));

    p.clearCart();
    p.clearVoucher();

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }

    setState(() => _loading = false);
    if (mounted) showAppToast(context, 'Order sent via WhatsApp! 🎉');
    widget.onOrderPlaced();
  }

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AppProvider>();
    final cartItems = p.cartItems;
    final subtotal = p.cartSubtotal.toInt();
    final discount = _discount(subtotal, p.appliedVoucher);
    final total = subtotal - discount;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Checkout',
                style: GoogleFonts.playfairDisplay(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.brown)),
            const SizedBox(height: 28),

            // Customer Info
            Card(
                child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DELIVERY DETAILS',
                        style: GoogleFonts.lato(
                            fontSize: 11,
                            color: AppColors.lightBrown,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 16),
                    AdminField(
                        label: 'Full Name *',
                        controller: _nameCtrl,
                        hint: 'Your name'),
                    const SizedBox(height: 14),
                    Row(children: [
                      Expanded(
                          child: AdminField(
                              label: 'Phone *',
                              controller: _phoneCtrl,
                              hint: '01xxxxxxxxx',
                              keyboardType: TextInputType.phone)),
                      const SizedBox(width: 14),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text('PAYMENT *',
                                style: GoogleFonts.lato(
                                    fontSize: 11,
                                    color: AppColors.lightBrown,
                                    letterSpacing: 1.5,
                                    fontWeight: FontWeight.w700)),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: _payment,
                              decoration: const InputDecoration(),
                              items: const [
                                DropdownMenuItem(
                                    value: 'cash',
                                    child: Text('Cash on Delivery')),
                                DropdownMenuItem(
                                    value: 'instapay', child: Text('InstaPay')),
                              ],
                              onChanged: (v) => setState(() => _payment = v!),
                            ),
                          ])),
                    ]),
                    const SizedBox(height: 14),
                    AdminField(
                        label: 'Address *',
                        controller: _addressCtrl,
                        hint: 'Full delivery address in Cairo'),
                    const SizedBox(height: 14),
                    AdminField(
                        label: 'Notes',
                        controller: _notesCtrl,
                        hint: 'Any special requests...'),
                  ]),
            )),
            const SizedBox(height: 16),

            // Voucher
            Card(
                child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('VOUCHER',
                        style: GoogleFonts.lato(
                            fontSize: 11,
                            color: AppColors.lightBrown,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Row(children: [
                      Expanded(
                        child: TextField(
                          controller: _voucherCtrl,
                          decoration:
                              const InputDecoration(hintText: 'Enter code...'),
                          textCapitalization: TextCapitalization.characters,
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton(
                          onPressed: () => _applyVoucher(p),
                          child: const Text('Apply')),
                    ]),
                    if (p.appliedVoucher != null) ...[
                      const SizedBox(height: 8),
                      Text('✓ ${p.appliedVoucher!.code} applied',
                          style: GoogleFonts.lato(
                              fontSize: 13,
                              color: AppColors.green,
                              fontWeight: FontWeight.w700)),
                    ],
                  ]),
            )),
            const SizedBox(height: 16),

            // Order Summary
            Card(
                child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ORDER SUMMARY',
                        style: GoogleFonts.lato(
                            fontSize: 11,
                            color: AppColors.lightBrown,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 14),
                    ...cartItems.map((i) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${i.emoji} ${i.name} x${p.cartQty(i.id)}',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        color: AppColors.darkBrown)),
                                Text('${i.price * p.cartQty(i.id)} EGP',
                                    style: GoogleFonts.lato(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700)),
                              ]),
                        )),
                    const Divider(color: AppColors.border, height: 24),
                    if (discount > 0)
                      _Row(
                          label: 'Discount',
                          value: '−$discount EGP',
                          color: AppColors.green),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 20, color: AppColors.darkBrown)),
                          Text('$total EGP',
                              style: GoogleFonts.playfairDisplay(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.brown)),
                        ]),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: _loading ? null : () => _placeOrder(p),
                        child: _loading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2))
                            : Text('📲 Send Order via WhatsApp',
                                style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    letterSpacing: 0.5)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        "You'll be redirected to WhatsApp to confirm your order",
                        style: GoogleFonts.lato(
                            fontSize: 12, color: AppColors.lightBrown),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
            )),
          ]),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label, value;
  final Color? color;
  const _Row({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label,
            style: GoogleFonts.lato(
                fontSize: 14, color: color ?? AppColors.lightBrown)),
        Text(value,
            style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color ?? AppColors.darkBrown)),
      ]),
    );
  }
}
