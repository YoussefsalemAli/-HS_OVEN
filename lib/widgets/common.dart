import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme.dart';

// ─── Section Title ────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const SectionTitle({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(title, style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.w700, color: AppColors.brown)),
      if (subtitle != null) ...[
        const SizedBox(height: 6),
        Text(subtitle!, style: GoogleFonts.lato(fontSize: 13, color: AppColors.lightBrown, letterSpacing: 1.5)),
      ],
      const SizedBox(height: 14),
      Container(width: 56, height: 3, color: AppColors.gold),
    ]);
  }
}

// ─── Sale Badge ───────────────────────────────────────────────────────────────
class SaleBadge extends StatelessWidget {
  const SaleBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: AppColors.red, borderRadius: BorderRadius.circular(3)),
      child: Text('SALE', style: GoogleFonts.lato(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
    );
  }
}

// ─── Stat Card ────────────────────────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const StatCard({super.key, required this.label, required this.value, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(children: [
        Text(label.toUpperCase(), style: GoogleFonts.lato(fontSize: 11, color: AppColors.lightBrown, letterSpacing: 1.5)),
        const SizedBox(height: 10),
        Text(value, style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w700, color: valueColor)),
      ]),
    );
  }
}

// ─── Qty Button ───────────────────────────────────────────────────────────────
class QtyButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const QtyButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.softCream,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(label, style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.brown)),
        ),
      ),
    );
  }
}

// ─── Toast helper ─────────────────────────────────────────────────────────────
void showAppToast(BuildContext context, String msg, {bool isError = false}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(msg, style: GoogleFonts.lato(color: Colors.white, fontWeight: FontWeight.w700)),
    backgroundColor: isError ? AppColors.red : AppColors.green,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    duration: const Duration(seconds: 2),
  ));
}

// ─── Admin field ─────────────────────────────────────────────────────────────
class AdminField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final TextInputType? keyboardType;
  final bool obscure;

  const AdminField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.keyboardType,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(), style: GoogleFonts.lato(fontSize: 11, color: AppColors.lightBrown, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(hintText: hint),
      ),
    ]);
  }
}