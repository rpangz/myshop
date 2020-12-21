import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class CartItem {
  final String id;
  final String title;
  final int qty;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.qty,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.qty * value.price;
    });

    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingcartItem) => CartItem(
          id: DateTime.now().toString(),
          title: title,
          qty: existingcartItem.qty + 1,
          price: price,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          qty: 1,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingelItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].qty > 1) {
      _items.update(
        productId,
        (existingcartItem) => CartItem(
          id: existingcartItem.id,
          title: existingcartItem.title,
          qty: existingcartItem.qty - 1,
          price: existingcartItem.price,
        ),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
