import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  String id;
  String title;
  String description;
  double price;
  String imageUrl;
  bool isFavourite = false;
  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.isFavourite,
  });
  Future<void> togglefavourite() async {
    final isOldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final Url = Uri.parse(
        'https://http-request-a8942-default-rtdb.firebaseio.com/products/$id.json');
    try {
      final response = await http.patch(
          Url, //patch request does not return error  message on the server side
          body: json.encode({
            'isFavourite': isFavourite,
          }));
      if (response.statusCode >= 400) {
        isFavourite = isOldStatus;
        notifyListeners();
      }
    } catch (err) {
      isFavourite = isOldStatus;
      notifyListeners();
    }
  }
}
