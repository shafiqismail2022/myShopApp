import 'package:flutter/material.dart';
import 'package:myshop/widgets/drawer.dart';
import '../widgets/order_item.dart';
import '../Providers/orders.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/order-page";

  @override
  // State<OrderScreen> createState() => _OrderScreenState();
// }

// class _OrderScreenState extends State<OrderScreen> {
  // var _isLoading = false;
  //Alternative ways of setting futures and Loaders in flutter
  // @override
  // void initState() {
  //   //can't use modelRoute with Listen = false
  //   Future.delayed(Duration.zero).then((_) async {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     await Provider.of<Order>(context).fetchandSetOrders();
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Order>(context); cause Build method is called often this will execute the future builder again and again
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Order"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Order>(context).fetchandSetOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.error != null) {
            return Center(child: Text('An Error Occured'));
          } else {
            return Consumer<Order>(
              builder: (context, orderData, child) => ListView.builder(
                itemCount: orderData.orderedProducts.length,
                itemBuilder: (context, index) => OrderItem(
                  orderData.orderedProducts[index],
                ),
              ),
            );
          }
        },
      ),
    );
  }
  //When There are Multiple States Changes in This page
  // Convert the Class to Stateless widget
  // add the code below
//   Future _orderFuture;
//   Future _ObtainOrderFuture() {
//     return Provider.of<Order>(context, listen: false).fetchandSetOrders();
//   }
//   initState({
// _orderFuture = _ObtainOrderFuture();
//   });
  //Then we call the _orderFuture in the FutureBuilder in the argument future
}
