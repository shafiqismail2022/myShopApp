import 'dart:convert';
import 'dart:io';
import "package:url_launcher/url_launcher.dart";
import 'package:flutter/cupertino.dart';
import '../models/http_exception.dart';
import "package:http/http.dart" as http;

import 'package:flutter/material.dart';
import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    //   isFavourite: false,
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    //   isFavourite: false,
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    //   isFavourite: false,
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    //   isFavourite: false,
    // ),
  ];
  // var showProductsfavourites = false;
  List<Product> get items {
    // if (showProductsfavourites) {
    //   return _items.where((elementItem) => elementItem.isFavourite).toList();
    // }
    return [..._items];
  }

  List<Product> get favouriteProduct {
    return _items
        .where((elementItem) => elementItem.isFavourite)
        .toList(); // to filter favourite items
  }

  // void productShowFavourite() {
  //   showProductsfavourites = true;
  //   notifyListeners();
  // }

  // void productShowAll() {
  //   showProductsfavourites = false;
  //   notifyListeners();
  // }

  Product viewProduct(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAndSetProduct() async {
    var url = Uri.parse(
        'https://http-request-a8942-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      // print('********${json.decode(response.body)}***********');
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        //prodId is the primary key and prodData is the value
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addProduct(Product product) async {
    //wrap the entire code in the future and automatically return a future noo need for return statement
    // http post
    try {
      var url = Uri.parse(
          'https://http-request-a8942-default-rtdb.firebaseio.com/products.json');
      final response = await http.post(url, // await is similar to then
          body: jsonEncode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavourite': product.isFavourite,
          })); //then is used to execute the code under it after the rsponse is executed successfully thus we can use the response as we need we can chain the Future of one method with another

      print(
          jsonDecode(response.body)); //print the id of the response under name
      final newProduct = Product(
        id: jsonDecode(response.body)[
            'name'], //matches the id of the frontend with the id of the backend
        title: product.title,
        description: product.description,
        imageUrl: product.description,
        price: product.price,
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct); add the product at the beginning of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error; //progress the error to the next catch error method
    } finally {
      print("Always exucute even if the try catch block fails");
    }
  }
  // Future<void> addProduct(Product product) {
  //   // http post
  //   var url = Uri.parse(
  //       'https://http-request-a8942-default-rtdb.firebaseio.com/products.json');
  //   return http
  //       .post(url,
  //           body: jsonEncode({
  //             'title': product.title,
  //             'description': product.description,
  //             'price': product.price,
  //             'imageUrl': product.imageUrl,
  //             'isFavourite': product.isFavourite,
  //           })) //then is used to execute the code under it after the rsponse is executed successfully thus we can use the response as we need we can chain the Future of one method with another
  //       .then((response) {
  //     print(
  //         jsonDecode(response.body)); //print the id of the response under name
  //     final newProduct = Product(
  //       id: jsonDecode(response.body)[
  //           'name'], //matches the id of the frontend with the id of the backend
  //       title: product.title,
  //       description: product.description,
  //       imageUrl: product.description,
  //       price: product.price,
  //     );
  //     _items.add(newProduct);
  //     //_items.insert(0, newProduct); add the product at the beginning of the list
  //     notifyListeners();
  //   }).catchError((error) {
  //     //catchError is used to catch the error of the then method (Future)
  //     print(error);
  //     throw error; //progress the error to the next catch error method
  //   });
  // }

  Product findById(String productId) {
    //It worked
    return _items.firstWhere((element) => element.id == productId);
  }

  Future<void> updateProduct(String id, Product newEdittedProduct) async {
    final productIndex = _items.indexWhere((ind) => ind.id == id);
    var url = Uri.parse(
        'https://http-request-a8942-default-rtdb.firebaseio.com/products/${id}.json');

    if (productIndex >= 0) {
      await http.patch(url, //body is added to append data to the request
          body: json.encode({
            'title': newEdittedProduct.title,
            'description': newEdittedProduct.description,
            'price': newEdittedProduct.price,
            'imageUrl': newEdittedProduct.imageUrl,
          }));
      _items[productIndex] = newEdittedProduct;
      notifyListeners();
    }
  }

  Future<void> deleteUsrProduct(String id) async {
    var url = Uri.parse(
        'https://http-request-a8942-default-rtdb.firebaseio.com/products/${id}.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(
        existingProductIndex); //removes only remove from list but on memory is still available
    final resp = await http.delete(url);
    if (resp.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null; //remove from memory
    notifyListeners();
  }
}
