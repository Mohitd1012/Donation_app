import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String cid;
  final String item;
  final String location;
  final String quantity;
  // final String imageUrl;

  Product({
    @required this.cid,
    @required this.item,
    @required this.location,
    @required this.quantity,
    // @required this.imageUrl,
  });
}

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> findByLocation(String location) {
    return _items.where((prod) => prod.location == location).toList();
  }

  Product findById(String cid) {
    return _items.firstWhere((prod) => prod.cid == cid);
  }

  Future<void> fetchAndSetProducts(
      {bool filterByUser = false, String location}) async {
    final filterString = filterByUser ? 'orderBy="cid"&equalTo="$userId"' : '';
    // final location = 'Jaipur';
    var url = Uri.parse(
        'https://umeed-9748c-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      location != 'All'
          ? extractedData.forEach((prodId, prodData) {
              prodData['location'] == location
                  ? loadedProducts.add(Product(
                      cid: prodId,
                      item: prodData['item'],
                      location: prodData['location'],
                      quantity: prodData['quantity'],
                      // imageUrl: prodData['imageUrl'],
                    ))
                  // ignore: unnecessary_statements
                  : null;
            })
          : extractedData.forEach((prodId, prodData) {
              loadedProducts.add(Product(
                cid: prodId,
                item: prodData['item'],
                location: prodData['location'],
                quantity: prodData['quantity'],
              ));
            });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://umeed-9748c-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'item': product.item,
          'location': product.location,
          // 'imageUrl': product.imageUrl,
          'quantity': product.quantity,
          'cid': userId,
        }),
      );
      final newProduct = Product(
        item: product.item,
        location: product.location,
        quantity: product.quantity,
        // imageUrl: product.imageUrl,
        cid: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String cid, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.cid == cid);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://umeed-9748c-default-rtdb.firebaseio.com/products/$cid.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'item': newProduct.item,
            'location': newProduct.location,
            'quantity': newProduct.quantity
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String cid) async {
    final url = Uri.parse(
        'https://umeed-9748c-default-rtdb.firebaseio.com/products/$cid.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.cid == cid);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
