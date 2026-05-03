import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/admin_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_badge.dart';
import 'cart_screen.dart';
import 'admin/admin_login_screen.dart';
import 'admin/admin_dashboard_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openAdmin(BuildContext context) {
    final adminProvider = context.read<AdminProvider>();
    if (adminProvider.isLoggedIn) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminLoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final productsProvider = context.watch<ProductsProvider>();

    return Scaffold(
      backgroundColor: AppTheme.lightCream,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppTheme.warmBrown,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: Tooltip(
                message: 'لوحة الأدمن',
                child: InkWell(
                  onTap: () => _openAdmin(context),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.admin_panel_settings, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ),
            actions: [
              CartBadge(
                count: cartProvider.itemCount,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [AppTheme.darkBrown, AppTheme.warmBrown],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    // Logo area
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppTheme.cream,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.gold, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('🔥', style: TextStyle(fontSize: 36)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'H OVEN',
                      style: TextStyle(
                        color: AppTheme.gold,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const Text(
                      'سينابون وكوكيز أرتيزان',
                      style: TextStyle(
                        color: AppTheme.cream,
                        fontSize: 13,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.gold,
              indicatorWeight: 3,
              labelColor: AppTheme.gold,
              unselectedLabelColor: AppTheme.cream.withOpacity(0.7),
              labelStyle: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, fontSize: 15),
              tabs: const [
                Tab(text: '🌀  سينابون'),
                Tab(text: '🍪  كوكيز'),
              ],
            ),
          ),

          // Banner strip
          SliverToBoxAdapter(
            child: Container(
              color: AppTheme.gold.withOpacity(0.15),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_fire_department, color: AppTheme.caramel, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'طازج يومياً  •  توصيل سريع  •  مكونات طبيعية',
                    style: TextStyle(
                      color: AppTheme.warmBrown,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.local_fire_department, color: AppTheme.caramel, size: 18),
                ],
              ),
            ),
          ),

          // Products Grid
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ProductGrid(
                  products: productsProvider.getByCategory('cinnabon'),
                ),
                _ProductGrid(
                  products: productsProvider.getByCategory('cookies'),
                ),
              ],
            ),
          ),
        ],
      ),

      // Floating cart button when items exist
      floatingActionButton: cartProvider.itemCount > 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              ),
              backgroundColor: AppTheme.warmBrown,
              icon: const Icon(Icons.shopping_basket, color: Colors.white),
              label: Text(
                'السلة (${cartProvider.itemCount})',
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List products;
  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('😴', style: TextStyle(fontSize: 48)),
            SizedBox(height: 12),
            Text(
              'لا توجد منتجات متاحة حالياً',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppTheme.textMid,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => ProductCard(product: products[index]),
    );
  }
}
