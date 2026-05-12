import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoven_web/models/menu_item.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: const [
          _HeroSection(),
          _MenuSection(),
          _InfoSection(),
          _Footer(),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF3D1208), Color(0xFF6B2D0E), Color(0xFF8B4513)],
        ),
      ),
      child: Column(
        children: [
          const Text('🍪', style: TextStyle(fontSize: 72)),
          const SizedBox(height: 20),
          Text(
            'Baked with Love,',
            style: GoogleFonts.playfairDisplay(
                fontSize: 48,
                color: Color(0xFFFFF8F0),
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          Text(
            'Delivered with Joy',
            style: GoogleFonts.playfairDisplay(
                fontSize: 48,
                color: Color(0xFFF5A623),
                fontStyle: FontStyle.italic),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Text(
            'Soft, gooey, unforgettable cookies.\nHandcrafted in Cairo — only the finest ingredients, straight to your door.',
            style: GoogleFonts.lato(
                fontSize: 16, color: Color(0xFFF5D5B0), height: 1.6),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF5A623),
              foregroundColor: const Color(0xFF2C1810),
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            child: Text('ORDER NOW',
                style: GoogleFonts.lato(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    fontSize: 14)),
          ),
          const SizedBox(height: 16),
          Text('🚚  First order = FREE delivery  ·  Cairo only',
              style: GoogleFonts.lato(
                  color: Color(0xFFF5D5B0), fontSize: 13, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  const _MenuSection();
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final items = provider.activeItems;

    return Container(
      color: const Color(0xFFFFF8F0),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        children: [
          Text('Our Menu',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 36,
                  color: Color(0xFF6B2D0E),
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Choose your perfect box',
              style: GoogleFonts.lato(
                  fontSize: 14, color: Color(0xFF8B5E3C), letterSpacing: 1)),
          const SizedBox(height: 8),
          Container(width: 60, height: 3, color: const Color(0xFFF5A623)),
          const SizedBox(height: 40),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: items.map((item) => _MenuCard(item: item)).toList(),
          ),
        ],
      ),
    );
  }
}

class _MenuCard extends StatefulWidget {
  final MenuItem item;
  const _MenuCard({required this.item});
  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<AppProvider>();
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE8D5C0)),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                      color: const Color(0xFF6B2D0E).withOpacity(0.12),
                      blurRadius: 24,
                      offset: const Offset(0, 8))
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF0E6),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Center(
                      child: Text(widget.item.emoji,
                          style: const TextStyle(fontSize: 56))),
                ),
                if (widget.item.originalPrice != null)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: const Color(0xFFC0392B),
                          borderRadius: BorderRadius.circular(2)),
                      child: Text('SALE',
                          style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.item.name,
                      style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          color: Color(0xFF2C1810),
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(widget.item.description,
                      style: GoogleFonts.lato(
                          fontSize: 13, color: Color(0xFF8B5E3C), height: 1.5)),
                  const SizedBox(height: 4),
                  Text(widget.item.weight,
                      style: GoogleFonts.lato(
                          fontSize: 12,
                          color: Color(0xFF8B5E3C),
                          letterSpacing: 1)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${widget.item.price.toInt()} EGP',
                              style: GoogleFonts.lato(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF6B2D0E))),
                          if (widget.item.originalPrice != null)
                            Text('${widget.item.originalPrice!.toInt()} EGP',
                                style: GoogleFonts.lato(
                                    fontSize: 14,
                                    color: Color(0xFFB0957A),
                                    decoration: TextDecoration.lineThrough)),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          provider.addToCart(widget.item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  '${widget.item.name} added to cart!',
                                  style: GoogleFonts.lato()),
                              backgroundColor: const Color(0xFF2C7A4B),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6B2D0E),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: Text('Add',
                            style: GoogleFonts.lato(
                                fontWeight: FontWeight.w700, fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection();
  @override
  Widget build(BuildContext context) {
    final infos = [
      {
        'icon': '🚚',
        'title': 'Delivery',
        'lines': ['First order FREE', 'Near areas from 30 EGP', 'Cairo only']
      },
      {
        'icon': '💳',
        'title': 'Payment',
        'lines': ['Cash on delivery', 'InstaPay: 01128312692']
      },
      {
        'icon': '🕐',
        'title': 'Hours',
        'lines': ['Sun–Fri: 11am – 10pm', 'Orders before 8pm']
      },
    ];
    return Container(
      color: const Color(0xFFFFF8F0),
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 60),
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        alignment: WrapAlignment.center,
        children: infos
            .map((info) => Container(
                  width: 260,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE8D5C0)),
                  ),
                  child: Column(
                    children: [
                      Text(info['icon'] as String,
                          style: const TextStyle(fontSize: 32)),
                      const SizedBox(height: 10),
                      Text(info['title'] as String,
                          style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              color: Color(0xFF6B2D0E),
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      ...(info['lines'] as List<String>).map((l) => Text(l,
                          style: GoogleFonts.lato(
                              fontSize: 13,
                              color: Color(0xFF8B5E3C),
                              height: 1.8),
                          textAlign: TextAlign.center)),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2C1810),
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Text('🍪  H Oven · Made with love in Cairo · © 2025',
            style: GoogleFonts.lato(
                color: Color(0xFFD4A882), fontSize: 13, letterSpacing: 1)),
      ),
    );
  }
}
