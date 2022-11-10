import 'package:flutter/material.dart';
import 'package:myshop/Screens/Order_screen.dart';
import '../Providers/orders.dart';
import 'package:myshop/widgets/cart_item.dart';
import 'package:provider/provider.dart';
import '../Providers/cart.dart'
    show Cart; // interested in only the Cart  and CartItem is not required
import '../widgets/cart_item.dart' as CI; //initialize as CI to avoid confusion

class CartScreen extends StatelessWidget {
  static const routeName = "/cart-path";
  Widget build(BuildContext context) {
    final Cartdata = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Cart",
        ),
      ),
      body: Column(children: [
        Card(
          margin: EdgeInsets.all(15),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      "\$${Cartdata.getTotal.toStringAsFixed(2)}",
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButtonNow(Cartdata: Cartdata)
                ]),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
            child: ListView.builder(
          itemBuilder: ((context, index) => CI.CartItem(
                id: Cartdata.items.values
                    .toList()[index]
                    .id, //accessing values in a list from maps
                title: Cartdata.items.values.toList()[index].title,
                price: Cartdata.items.values.toList()[index].price,
                quantity: Cartdata.items.values.toList()[index].quantity,
                productId: Cartdata.items.keys.toList()[index],
              )),
          itemCount: Cartdata.cartItem,
        ))
      ]),
    );
  }
}

class OrderButtonNow extends StatefulWidget {
  const OrderButtonNow({
    Key key,
    @required this.Cartdata,
  }) : super(key: key);

  final Cart Cartdata;

  @override
  State<OrderButtonNow> createState() => _OrderButtonNowState();
}

class _OrderButtonNowState extends State<OrderButtonNow> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (widget.Cartdata.getTotal <= 0 || _isLoading)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              await Provider.of<Order>(context, listen: false).addOrder(
                  widget.Cartdata.items.values.toList(),
                  widget.Cartdata.getTotal);
              setState(() {
                _isLoading = false;
              });
              widget.Cartdata
                  .clearCart(); // Navigator.of(context).pushNamed(OrderScreen.routeName);
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              "Order Now",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
    );
  }
}
