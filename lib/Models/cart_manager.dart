import 'package:flutter/foundation.dart';
import '../data/merch_data.dart';

class CartItem {
  final Merchandise merch;
  int quantity;

  CartItem({required this.merch, this.quantity = 1});
}

class CartManager extends ChangeNotifier {
  final List<CartItem> _cartItems = [];
  String _promoCode = '';
  // Biaya kirim statis dalam USD
  final double _shippingFeeUsd = 5.00;

  List<CartItem> get cartItems => _cartItems;
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  // LOGIKA HARGA:

  // 1. Subtotal (total harga item sebelum diskon/kirim)
  double get subtotalUsd => _cartItems.fold(
      0.0, (sum, item) => sum + (item.merch.priceUsd * item.quantity));

  // 2. Biaya Kirim (0 jika keranjang kosong)
  double get shippingFeeUsd => _cartItems.isEmpty ? 0.0 : _shippingFeeUsd;

  // 3. Logika Diskon (Contoh: "RIOT20" memberikan diskon 20%)
  double get discountUsd {
    if (_promoCode.toUpperCase() == 'RIOT20') {
      return subtotalUsd * 0.20;
    }
    return 0.0;
  }

  // 4. Total Akhir
  double get totalPriceUsd {
    double calculatedTotal = (subtotalUsd - discountUsd) + shippingFeeUsd;
    return calculatedTotal > 0 ? calculatedTotal : 0.0;
  }

  // --- Metode Manajemen Item ---

  void addItem(Merchandise merch) {
    final existingItemIndex =
        _cartItems.indexWhere((item) => item.merch.id == merch.id);

    if (existingItemIndex >= 0) {
      _cartItems[existingItemIndex].quantity++;
    } else {
      _cartItems.add(CartItem(merch: merch, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(Merchandise merch) {
    final existingItemIndex =
        _cartItems.indexWhere((item) => item.merch.id == merch.id);

    if (existingItemIndex >= 0) {
      if (_cartItems[existingItemIndex].quantity > 1) {
        _cartItems[existingItemIndex].quantity--;
      } else {
        _cartItems.removeAt(existingItemIndex);
        if (_cartItems.isEmpty) removePromo();
      }
      notifyListeners();
    }
  }

  /// Metode untuk menerapkan kode promo
  void applyPromo(String code) {
    _promoCode = code;
    notifyListeners();
  }

  void removePromo() {
    _promoCode = '';
    notifyListeners();
  }

  /// Mengosongkan keranjang
  void clearCart() {
    _cartItems.clear();
    _promoCode = '';
    notifyListeners();
  }
}
