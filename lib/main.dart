import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoven_web/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/admin_screen.dart';
import 'theme.dart';
import 'widgets/common.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const HOvenApp(),
    ),
  );
}

class HOvenApp extends StatelessWidget {
  const HOvenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'H Oven',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AppShell(),
    );
  }
}

// ─── App Shell with Navbar ────────────────────────────────────────────────────
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _page = 0; // 0=home 1=cart 2=checkout 3=admin

  void _go(int page) => setState(() => _page = page);

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<AppProvider>().cartItemCount;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE8D5C0), height: 1),
        ),
        title: InkWell(
          onTap: () => _go(0),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Text('🍪', style: TextStyle(fontSize: 26)),
            const SizedBox(width: 8),
            Text('H Oven', style: GoogleFonts.playfairDisplay(fontSize: 22, color: const Color(0xFF6B2D0E), fontWeight: FontWeight.w700)),
          ]),
        ),
        actions: [
          _NavBtn(label: 'Menu',    active: _page == 0, onTap: () => _go(0)),
          _NavCartBtn(
            label: 'Cart',
            count: cart,
            active: _page == 1,
            onTap: () => _go(1),
          ),
          _NavBtn(label: 'Admin',   active: _page == 3, onTap: () => _go(3)),
          const SizedBox(width: 16),
        ],
      ),
      body: IndexedStack(
        index: _page,
        children: [
          const HomeScreen(),
          CartScreen(onCheckout: () => _go(2)),
          CheckoutScreen(onOrderPlaced: () => _go(0)),
          const AdminScreen(),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavBtn({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.lato(
          fontSize: 12,
          letterSpacing: 2,
          fontWeight: active ? FontWeight.w700 : FontWeight.w400,
          color: const Color(0xFF6B2D0E),
        ),
      ),
    );
  }
}

class _NavCartBtn extends StatelessWidget {
  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;
  const _NavCartBtn({required this.label, required this.count, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      TextButton(
        onPressed: onTap,
        child: Text(
          label.toUpperCase(),
          style: GoogleFonts.lato(
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            color: const Color(0xFF6B2D0E),
          ),
        ),
      ),
      if (count > 0)
        Positioned(
          top: 6,
          right: 2,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(color: Color(0xFF6B2D0E), shape: BoxShape.circle),
            child: Center(child: Text('$count', style: GoogleFonts.lato(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w700))),
          ),
        ),
    ]);
  }
}