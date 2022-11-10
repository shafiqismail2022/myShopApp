import 'package:flutter/material.dart';
import 'package:myshop/Screens/Order_screen.dart';
import 'package:myshop/Screens/user_product_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        AppBar(
          title: Text("Hello Friend"),
          automaticallyImplyLeading: false, //Not add any buttoms at the app bar
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text("Shoo"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed("/");
          },
        ),
        const Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text("Orders"),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
          },
        ),
        const Divider(),
        ListTile(
            leading: Icon(Icons.edit),
            title: Text("Manage Products"),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProduct.routeName);
            }),
      ]),
    );
  }
}
