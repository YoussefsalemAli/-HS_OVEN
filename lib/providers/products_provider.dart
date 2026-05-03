import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/discount_code.dart';

class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<DiscountCode> _discountCodes = [];
  double _deliveryFee = 30.0;

  List<Product> get products => _products.where((p) => p.isAvailable).toList();
  List<Product> get allProducts => _products;
  List<DiscountCode> get discountCodes => _discountCodes;
  double get deliveryFee => _deliveryFee;

  ProductsProvider() {
    _initProducts();
    _loadFromStorage();
  }

  void _initProducts() {
    _products = [
      Product(
        id: 'cinnabon_classic',
        name: 'سينابون كلاسيك',
        description: 'لفائف القرفة الطازجة بالكريمة الأصلية اللذيذة',
        emoji: '🌀',
        category: 'cinnabon',
        sizes: [
          const ProductSize(label: '100 جم', weight: 100, price: 70, boxCost: 7),
          const ProductSize(label: '150 جم', weight: 150, price: 99, boxCost: 8),
        ],
      ),
      Product(
        id: 'cinnabon_caramel',
        name: 'سينابون كراميل',
        description: 'لفائف القرفة مع صوص الكراميل الدافئ',
        emoji: '🍯',
        category: 'cinnabon',
        sizes: [
          const ProductSize(label: '100 جم', weight: 100, price: 75, boxCost: 7),
          const ProductSize(label: '150 جم', weight: 150, price: 105, boxCost: 8),
        ],
      ),
      Product(
        id: 'cookies_chocolate',
        name: 'كوكيز الشوكولاتة',
        description: 'كوكيز طازج بقطع الشوكولاتة الداكنة',
        emoji: '🍪',
        category: 'cookies',
        sizes: [
          const ProductSize(label: '100 جم', weight: 100, price: 65, boxCost: 7),
          const ProductSize(label: '150 جم', weight: 150, price: 90, boxCost: 8),
        ],
      ),
      Product(
        id: 'cookies_nutella',
        name: 'كوكيز نوتيلا',
        description: 'كوكيز محشي نوتيلا بقلب سائل',
        emoji: '🤎',
        category: 'cookies',
        sizes: [
          const ProductSize(label: '100 جم', weight: 100, price: 70, boxCost: 7),
          const ProductSize(label: '150 جم', weight: 150, price: 98, boxCost: 8),
        ],
      ),
    ];

    _discountCodes = [
      const DiscountCode(
        code: 'HOVEN10',
        percentage: 10,
        description: 'خصم 10% على الطلب',
      ),
      const DiscountCode(
        code: 'WELCOME',
        percentage: 15,
        description: 'خصم ترحيب 15%',
      ),
    ];
  }

  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = prefs.getString('products');
      if (productsJson != null) {
        final List<dynamic> list = jsonDecode(productsJson);
        _products = list.map((e) => Product.fromJson(e)).toList();
      }
      final codesJson = prefs.getString('discount_codes');
      if (codesJson != null) {
        final List<dynamic> list = jsonDecode(codesJson);
        _discountCodes = list.map((e) => DiscountCode.fromJson(e)).toList();
      }
      final fee = prefs.getDouble('delivery_fee');
      if (fee != null) _deliveryFee = fee;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('products', jsonEncode(_products.map((p) => p.toJson()).toList()));
      await prefs.setString('discount_codes', jsonEncode(_discountCodes.map((c) => c.toJson()).toList()));
      await prefs.setDouble('delivery_fee', _deliveryFee);
    } catch (_) {}
  }

  void addProduct(Product product) {
    _products.add(product);
    _saveToStorage();
    notifyListeners();
  }

  void updateProduct(Product product) {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
      _saveToStorage();
      notifyListeners();
    }
  }

  void toggleProductAvailability(String id) {
    final index = _products.indexWhere((p) => p.id == id);
    if (index != -1) {
      _products[index].isAvailable = !_products[index].isAvailable;
      _saveToStorage();
      notifyListeners();
    }
  }

  void updateDeliveryFee(double fee) {
    _deliveryFee = fee;
    _saveToStorage();
    notifyListeners();
  }

  void addDiscountCode(DiscountCode code) {
    _discountCodes.add(code);
    _saveToStorage();
    notifyListeners();
  }

  void removeDiscountCode(String code) {
    _discountCodes.removeWhere((c) => c.code == code);
    _saveToStorage();
    notifyListeners();
  }

  DiscountCode? validateCode(String code) {
    try {
      return _discountCodes.firstWhere(
        (c) => c.code.toUpperCase() == code.toUpperCase() && c.isActive,
      );
    } catch (_) {
      return null;
    }
  }

  List<Product> getByCategory(String category) {
    return products.where((p) => p.category == category).toList();
  }
}
