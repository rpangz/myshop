import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime datetime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.datetime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String authtoken;
  final String userId;

  Order(this.authtoken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  // void addOrder(List<CartItem> cartProduct, double total) {
  //   _orders.insert(
  //     0,
  //     OrderItem(
  //         id: DateTime.now().toString(),
  //         amount: total,
  //         datetime: DateTime.now(),
  //         products: cartProduct),
  //   );
  //   notifyListeners();
  // }

  Future<void> fetchAndOrder() async {
    final url =
        'https://myshop-3900e-default-rtdb.firebaseio.com/order/$userId.json?auth=$authtoken';

    try {
      final response = await http.get(url);
      final extractData = json.decode(response.body) as Map<String, dynamic>;
      List<OrderItem> _loadedOrders = [];
      if (extractData == null) {
        return;
      }
      extractData.forEach((key, value) {
        _loadedOrders.add(OrderItem(
          id: key,
          amount: double.parse(value['amount']),
          datetime: DateTime.parse(value['datetime']),
          products: (value['products'] as List<dynamic>).map((e) {
            return CartItem(
              id: e['id'],
              title: e['title'],
              qty: e['qty'],
              price: e['price'],
            );
          }).toList(),
        ));
      });
      _orders = _loadedOrders;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://myshop-3900e-default-rtdb.firebaseio.com/order/$userId.json?auth=$authtoken';

    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total.toString(),
            'datetime': DateTime.now().toIso8601String(),
            'products': cartProduct.map((trx) {
              return {
                'id': trx.id,
                'title': trx.title,
                'qty': trx.qty,
                'price': trx.price
              };
            }).toList()
          }));

      _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            datetime: DateTime.now(),
            products: cartProduct),
      );
      notifyListeners();

      inspect(response);
    } catch (e) {
      print(e);
    }
  }
}
