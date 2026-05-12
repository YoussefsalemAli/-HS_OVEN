import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback onCheckout;
  const CartScreen({super.key, required this.onCheckout});
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _voucherCtrl = TextEditingController();
  String? _voucherError;

  @override
  void dispose() {
    _voucherCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final items = provider.cartItems;

    if (items.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text('🛒', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          Text('Your cart is empty',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 28, color: Color(0xFF6B2D0E))),
          const SizedBox(height: 12),
          Text('Looks like you haven\'t added anything yet.',
              style: GoogleFonts.lato(color: Color(0xFF8B5E3C))),
        ]),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Cart',
                  style: GoogleFonts.playfairDisplay(
                      fontSize: 32,
                      color: Color(0xFF6B2D0E),
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 24),
              // Items
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE8D5C0))),
                child: Column(
                  children: items.asMap().entries.map((entry) {
                    final i = entry.key;
                    final item = entry.value;
                    return Column(
                      children: [
                        if (i > 0)
                          const Divider(color: Color(0xFFE8D5C0), height: 1),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Text(item.emoji,
                                  style: const TextStyle(fontSize: 36)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name,
                                        style: GoogleFonts.playfairDisplay(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF2C1810))),
                                    Text(
                                        '${item.weight} · ${item.price.toInt()} EGP each',
                                        style: GoogleFonts.lato(
                                            fontSize: 13,
                                            color: Color(0xFF8B5E3C))),
                                  ],
                                ),
                              ),
                              // Qty controls
                              Row(
                                children: [
                                  _QtyBtn(
                                      icon: '−',
                                      onTap: () => context
                                          .read<AppProvider>()
                                          .removeFromCart(item.id)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Text('${provider.cartQty(item.id)}',
                                        style: GoogleFonts.lato(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                  _QtyBtn(
                                      icon: '+',
                                      onTap: () => context
                                          .read<AppProvider>()
                                          .addToCart(item.id)),
                                ],
                              ),
                              const SizedBox(width: 16),
                              SizedBox(
                                width: 90,
                                child: Text(
                                    '${(item.price * provider.cartQty(item.id)).toInt()} EGP',
                                    textAlign: TextAlign.right,
                                    style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF6B2D0E))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Voucher
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE8D5C0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('VOUCHER CODE',
                        style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Color(0xFF8B5E3C),
                            letterSpacing: 1)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _voucherCtrl,
                            decoration: InputDecoration(
                              hintText: 'Enter code...',
                              hintStyle:
                                  GoogleFonts.lato(color: Color(0xFFB0957A)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFD4A882))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFD4A882))),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                            style: GoogleFonts.lato(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {
                            final err = context
                                .read<AppProvider>()
                                .applyVoucher(_voucherCtrl.text);
                            setState(() => _voucherError = err);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6B2D0E),
                            side: const BorderSide(
                                color: Color(0xFF6B2D0E), width: 2),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                          ),
                          child: Text('APPLY',
                              style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1,
                                  fontSize: 13)),
                        ),
                      ],
                    ),
                    if (_voucherError != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(_voucherError!,
                            style: GoogleFonts.lato(
                                color: Color(0xFFC0392B), fontSize: 13)),
                      ),
                    if (provider.appliedVoucher != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                            '✓ ${provider.appliedVoucher!.code} — ${provider.appliedVoucher!.label}',
                            style: GoogleFonts.lato(
                                color: Color(0xFF2C7A4B), fontSize: 13)),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Summary
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE8D5C0))),
                child: Column(
                  children: [
                    _SummaryRow(
                        'Subtotal', '${provider.cartSubtotal.toInt()} EGP'),
                    if (provider.discountAmount > 0)
                      _SummaryRow(
                          'Discount', '−${provider.discountAmount.toInt()} EGP',
                          isGreen: true),
                    _SummaryRow('Delivery', 'FREE (first order)',
                        isGreen: true),
                    const Divider(color: Color(0xFFE8D5C0), height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 20, color: Color(0xFF2C1810))),
                        Text('${provider.cartTotal.toInt()} EGP',
                            style: GoogleFonts.playfairDisplay(
                                fontSize: 24,
                                color: Color(0xFF6B2D0E),
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.onCheckout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B2D0E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: Text('PROCEED TO CHECKOUT →',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
            color: const Color(0xFFF5E6D8),
            borderRadius: BorderRadius.circular(4)),
        child: Center(
            child: Text(icon,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B2D0E)))),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool isGreen;
  const _SummaryRow(this.label, this.value, {this.isGreen = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.lato(
                  color: isGreen ? Color(0xFF2C7A4B) : Color(0xFF8B5E3C),
                  fontSize: 14)),
          Text(value,
              style: GoogleFonts.lato(
                  fontWeight: FontWeight.w700,
                  color: isGreen ? Color(0xFF2C7A4B) : Color(0xFF2C1810),
                  fontSize: 14)),
        ],
      ),
    );
  }
}
