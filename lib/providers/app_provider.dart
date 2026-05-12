// lib/providers/app_provider.dart

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:hoven_web/models/menu_item.dart';

class AppProvider extends ChangeNotifier {
  List<MenuItem> _items = [
    MenuItem(
        id: 1,
        name: 'Mini Box',
        description: 'Perfect for a quick sweet bite',
        weight: '100g',
        price: 80,
        emoji: '🍪'),
    MenuItem(
        id: 2,
        name: 'Classic Box',
        description: 'Our signature soft & gooey cookies',
        weight: '150g',
        price: 120,
        emoji: '🍫'),
    MenuItem(
        id: 3,
        name: 'Signature Box',
        description: 'Made for real chocolate lovers',
        weight: '300g',
        price: 230,
        originalPrice: 249,
        emoji: '👑'),
    MenuItem(
        id: 4,
        name: 'Sharing Box',
        description: 'Perfect for sharing... or not',
        weight: '500g',
        price: 379,
        emoji: '🎉'),
    MenuItem(
        id: 5,
        name: 'Party Box',
        description: 'The ultimate H Oven experience',
        weight: '1kg',
        price: 699,
        emoji: '🏆'),
  ];

  List<MenuItem> get items => _items;
  List<MenuItem> get activeItems => _items.where((i) => i.isActive).toList();

  void updateItem(MenuItem updated) {
    final idx = _items.indexWhere((i) => i.id == updated.id);
    if (idx != -1) {
      _items[idx] = updated;
      notifyListeners();
    }
  }

  void addItem(MenuItem item) {
    _items.add(item);
    notifyListeners();
  }

  void toggleItemActive(int id) {
    final idx = _items.indexWhere((i) => i.id == id);
    if (idx != -1) {
      _items[idx] = _items[idx].copyWith(isActive: !_items[idx].isActive);
      notifyListeners();
    }
  }

  void toggleItem(int id) => toggleItemActive(id);

  bool _adminAuth = false;
  bool get adminAuth => _adminAuth;

  bool login(String password) {
    if (password == 'hoven2025') {
      _adminAuth = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _adminAuth = false;
    notifyListeners();
  }

  int get nextItemId =>
      _items.isEmpty ? 1 : _items.map((item) => item.id).reduce(max) + 1;

  final Map<int, int> _cart = {};
  Map<int, int> get cart => Map.unmodifiable(_cart);
  int cartQty(int itemId) => _cart[itemId] ?? 0;
  int get cartItemCount => _cart.values.fold(0, (a, b) => a + b);
  List<MenuItem> get cartItems =>
      _items.where((i) => (_cart[i.id] ?? 0) > 0).toList();
  double get cartSubtotal =>
      cartItems.fold(0.0, (sum, i) => sum + i.price * (_cart[i.id] ?? 0));

  void addToCart(int itemId) {
    _cart[itemId] = (_cart[itemId] ?? 0) + 1;
    notifyListeners();
  }

  void removeFromCart(int itemId) {
    if (_cart[itemId] != null) {
      if (_cart[itemId]! <= 1) {
        _cart.remove(itemId);
      } else {
        _cart[itemId] = _cart[itemId]! - 1;
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  List<Voucher> _vouchers = [
    Voucher(code: 'WELCOME10', discount: 10, type: 'percent'),
    Voucher(code: 'HOVEN20', discount: 20, type: 'fixed'),
  ];

  List<Voucher> get vouchers => _vouchers;
  Voucher? _appliedVoucher;
  Voucher? get appliedVoucher => _appliedVoucher;

  double get discountAmount {
    if (_appliedVoucher == null) return 0;
    if (_appliedVoucher!.type == 'percent')
      return cartSubtotal * _appliedVoucher!.discount / 100;
    return _appliedVoucher!.discount.clamp(0, cartSubtotal);
  }

  double get cartTotal => cartSubtotal - discountAmount;

  String? applyVoucher(String code) {
    Voucher? matched;
    for (final voucher in _vouchers) {
      if (voucher.code.toLowerCase() == code.trim().toLowerCase() &&
          voucher.isActive) {
        matched = voucher;
        break;
      }
    }
    if (matched == null) return 'Invalid or expired voucher code';
    _appliedVoucher = matched;
    notifyListeners();
    return null;
  }

  void clearVoucher() {
    _appliedVoucher = null;
    notifyListeners();
  }

  void addVoucher(Voucher v) {
    _vouchers.add(v);
    notifyListeners();
  }

  void toggleVoucher(String code) {
    final idx = _vouchers.indexWhere((v) => v.code == code);
    if (idx != -1) {
      _vouchers[idx].isActive = !_vouchers[idx].isActive;
      notifyListeners();
    }
  }

  void deleteVoucher(String code) {
    _vouchers.removeWhere((v) => v.code == code);
    notifyListeners();
  }

  final List<OrderRecord> _orders = [
    OrderRecord(
        id: 'ORD-001',
        name: 'Ahmed Mohamed',
        total: 379,
        cost: 144,
        items: ['Sharing Box x1'],
        date: DateTime(2025, 5, 10).toIso8601String().substring(0, 10),
        payment: 'Cash on Delivery'),
    OrderRecord(
        id: 'ORD-002',
        name: 'Sara Ali',
        total: 230,
        cost: 86,
        items: ['Signature Box x1'],
        date: DateTime(2025, 5, 11).toIso8601String().substring(0, 10),
        payment: 'InstaPay'),
    OrderRecord(
        id: 'ORD-003',
        name: 'Mohamed Hassan',
        total: 699,
        cost: 259,
        items: ['Party Box x1'],
        date: DateTime(2025, 5, 11).toIso8601String().substring(0, 10),
        payment: 'Cash on Delivery'),
  ];

  List<OrderRecord> get orders => List.unmodifiable(_orders);
  double get totalRevenue => _orders.fold(0, (s, o) => s + o.total);
  double get totalCost => _orders.fold(0, (s, o) => s + o.cost);
  double get totalProfit => totalRevenue - totalCost;

  void addOrder(OrderRecord order) {
    _orders.add(order);
    _orderCounter++;
    notifyListeners();
  }

  int _orderCounter = 4;
  String get nextOrderId => 'ORD-${_orderCounter.toString().padLeft(3, '0')}';
  void incrementOrderCounter() {
    _orderCounter++;
  }
}
