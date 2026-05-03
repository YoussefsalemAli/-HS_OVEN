import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../models/discount_code.dart';
import 'package:uuid/uuid.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  DiscountCode? _appliedDiscount;

  List<CartItem> get items => _items;
  DiscountCode? get appliedDiscount => _appliedDiscount;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);

  double get discountAmount {
    if (_appliedDiscount == null) return 0;
    return subtotal * (_appliedDiscount!.percentage / 100);
  }

  double totalWithDelivery(double deliveryFee) {
    return subtotal - discountAmount + deliveryFee;
  }

  void addItem(Product product, ProductSize size) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id && item.size.label == size.label,
    );
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItem(
        id: const Uuid().v4(),
        product: product,
        size: size,
        quantity: 1,
      ));
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void incrementItem(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementItem(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void applyDiscount(DiscountCode code) {
    _appliedDiscount = code;
    notifyListeners();
  }

  void removeDiscount() {
    _appliedDiscount = null;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _appliedDiscount = null;
    notifyListeners();
  }
}
