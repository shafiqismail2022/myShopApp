import 'package:flutter/foundation.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItems {
  final String id;
  final double amount;
  final List<CartItem> productOrder;
  final DateTime dateTime;
  OrderItems({this.id, this.amount, this.productOrder, this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItems> _order = [];
  List<OrderItems> get orderedProducts {
    return [..._order];
  }

  Future<void> fetchandSetOrders() async {
    var url = Uri.parse(
        'https://http-request-a8942-default-rtdb.firebaseio.com/orders.json');
    final response = await http.get(url);
    final List<OrderItems> loadedOrders = [];
    final extractedData = json.decode(response.body)
        as Map<String, dynamic>; //maps each data to a key value pair
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, OrderData) {
      loadedOrders.add(
        OrderItems(
          id: orderId,
          amount: OrderData['amount'],
          dateTime: DateTime.parse(OrderData[
              'dateTime']), //Is used with ToIso8601String() to convert a DateTime object to a string while retrieving data from the server
          productOrder: (OrderData['productOrder'] as List<dynamic>).map(
            (item) => CartItem(
              id: item['id'],
              title: item['title'],
              quantity: item['quantity'],
              price: item['price'],
            ),
          ),
        ),
      );
    });
    _order = loadedOrders.reversed
        .toList(); //reverse the list to show the newest order first
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> orders, double amt) async {
    var timeStamp = DateTime.now(); //Time when this function is executed
    var url = Uri.parse(
        'https://http-request-a8942-default-rtdb.firebaseio.com/orders.json');
    final response = await http.post(url,
        body: json.encode({
          'amount': amt,
          'dateTime': timeStamp
              .toIso8601String(), //convert a time to a format easily readable when required back by dart
          'productOrder': orders.map((cp) {
            return {
              'id': cp.id,
              'title': cp.title,
              'quantity': cp.quantity,
              'price': cp.price,
            };
          }).toList(),
        }));
    _order.insert(
      0,
      OrderItems(
        id: json.decode(response.body)['name'],
        amount: amt,
        productOrder: orders,
        dateTime: DateTime.now(),
      ),
    ); //add items at the beginning of the queue
    notifyListeners();
  }
}
