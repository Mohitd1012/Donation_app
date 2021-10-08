import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';

class DonateItem {
  final String id;
  final List<Product> products;
  final DateTime dateTime;

  DonateItem({this.id, this.dateTime, this.products});
}

class Donate with ChangeNotifier {
  List<DonateItem> _donate = [];
  final String authToken;
  final String userId;

  Donate(this.userId, this.authToken, this._donate);

  List<DonateItem> get donate {
    return [..._donate];
  }

  Future<void> fetchAndSetDonations() async {
    final url = Uri.parse(
        'https://umeed-9748c-default-rtdb.firebaseio.com/donate/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final List<DonateItem> donatedProducts = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((donateId, donateData) {
      donatedProducts.add(
        DonateItem(
          id: donateId,
          dateTime: DateTime.parse(donateData['dateTime']),
          products: (donateData['products'] as List<dynamic>)
              .map(
                (item) => Product(
                  cid: item['id'],
                  quantity: item['quantity'],
                  item: item['item'],
                  // imageUrl: item['imageUrl'],
                  location: item['Location'],
                ),
              )
              .toList(),
        ),
      );
    });
    _donate = donatedProducts.reversed.toList();
    notifyListeners();
  }

  Future<void> addDonation(List<Product> donation) async {
    final url = Uri.parse(
        'https://umeed-9748c-default-rtdb.firebaseio.com/donate/$userId.json?auth=$authToken');
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'dateTime': timestamp.toIso8601String(),
        'products': donation
            .map((cp) => {
                  'id': cp.cid,
                  'item': cp.item,
                  'quantity': cp.quantity,
                  'Location': cp.location,
                  // 'imageUrl': cp.imageUrl,
                })
            .toList(),
      }),
    );
    _donate.insert(
      0,
      DonateItem(
        id: json.decode(response.body)['name'],
        dateTime: timestamp,
        products: donation,
      ),
    );
    notifyListeners();
  }
}
