import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import "package:provider/provider.dart";
import '../Providers/cart.dart';
import 'package:flutter/foundation.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  CartItem({this.id, this.productId, this.title, this.price, this.quantity});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      //swip to delete
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment
            .centerRight, //vertically center and horizontally to the right
        padding: const EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
      ),
      direction: DismissDirection
          .endToStart, //right is end and left is start just like writing.
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeCartItem(productId);

        //for more swipping functionality use switch case
      },
      confirmDismiss: (direction) {
        return showDialog(
          //returns a future of True or False
          context: context,
          builder: ((ctx) => AlertDialog(
                title: Text("Are You Sure?"),
                content: const Text(
                    "Are you sure you want to remove an item to the cart?"),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: const Text("No"),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text("Yes"),
                  ),
                ],
              )),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 15),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text("\$${price}"),
                ),
              ),
            ),
            title: Text(title),
            subtitle: Text("Total: \$${quantity}*${price}"),
            trailing: Text("x ${quantity}"),
          ),
        ),
      ),
    );
  }
}
