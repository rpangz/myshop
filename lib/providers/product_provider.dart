import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _items = [];
  // List<Product> _items = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

  // var _showFavoriteOnly = false;

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }
  final String authtoken;
  final String userId;
  ProductProvider(this.authtoken, this.userId, this._items);

  List<Product> get items {
    // if (_showFavoriteOnly) {
    //   return _items.where((element) => element.isFavorite == true).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  // INI FUTURE TIDAK MENGGUNAKAN ASYNC AWAIT
  // Future<void> addProducts(Product value) {
  //   const url = 'https://myshop-3900e-default-rtdb.firebaseio.com/products';

  //   return http
  //       .post(
  //     url,
  //     body: json.encode({
  //       'id': value.id,
  //       'title': value.title,
  //       'price': value.price,
  //       'imageUrl': value.imageUrl,
  //       'description': value.description,
  //       'isFavorite': value.isFavorite,
  //     }),
  //   )
  //       .then((response) {
  //     inspect(response);
  //     _items.add(Product(
  //       id: json.decode(response.body)['name'],
  //       title: value.title,
  //       price: value.price,
  //       imageUrl: value.imageUrl,
  //       description: value.description,
  //     ));
  //     notifyListeners();
  //   }).catchError((error) {
  //     print(error);
  //     throw error;
  //   });
  // }

  Future<void> fetchAndSetProduct([bool isFilter = false]) async {
    final filterString =
        isFilter ? '&orderBy="creatorid"&equalTo="$userId"' : '';
    var url =
        'https://myshop-3900e-default-rtdb.firebaseio.com/products.json?auth=$authtoken$filterString';

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      final extractData = json.decode(response.body) as Map<String, dynamic>;

      // get favorite
      url =
          'https://myshop-3900e-default-rtdb.firebaseio.com/userFavorites/$userId.json?auth=$authtoken';
      final favResponse = await http.get(url);
      final favResponseData = json.decode(favResponse.body);
      // =========================================

      List<Product> _loadedProduct = [];
      extractData.forEach((key, value) {
        _loadedProduct.add(Product(
            id: key,
            description: value['description'],
            imageUrl: value['imageUrl'],
            isFavorite:
                favResponseData == null ? false : favResponseData[key] ?? false,
            price: value['price'],
            title: value['title']));
      });
      _items = _loadedProduct;
      notifyListeners();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<void> addProducts(Product value) async {
    final url =
        'https://myshop-3900e-default-rtdb.firebaseio.com/products.json?auth=$authtoken';

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': value.id,
          'title': value.title,
          'price': value.price,
          'imageUrl': value.imageUrl,
          'description': value.description,
          'creatorid': userId
        }),
      );

      _items.add(Product(
        id: json.decode(response.body)['name'],
        title: value.title,
        price: value.price,
        imageUrl: value.imageUrl,
        description: value.description,
      ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }

    // .catchError((error) {
    //   print(error);
    //   throw error;
    // });
  }

  Future<void> editProdcut(String productId, Product value) async {
    final productIndex =
        _items.indexWhere((element) => element.id == productId);

    if (productIndex > 0) {
      final url =
          'https://myshop-3900e-default-rtdb.firebaseio.com/products/$productId.json?auth=$authtoken';

      try {
        await http.patch(
          url,
          body: json.encode({
            'title': value.title,
            'price': value.price,
            'imageUrl': value.imageUrl,
            'description': value.description,
          }),
        );
        _items[productIndex] = value;
        notifyListeners();
      } catch (e) {
        throw e;
      }
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url =
        'https://myshop-3900e-default-rtdb.firebaseio.com/products/$productId.json?auth=$authtoken';

    final existingIndex =
        _items.indexWhere((element) => element.id == productId);
    var _existingItems = _items[existingIndex];
    _items.removeAt(existingIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingIndex, _existingItems);
      notifyListeners();
      throw HttpException('Error deleting product');
    }
    _existingItems = null;
  }
}
