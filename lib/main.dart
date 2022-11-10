import 'package:flutter/material.dart';
import 'package:myshop/Screens/Order_screen.dart';
import '../Screens/user_product_screen.dart';
import '../Providers/orders.dart';
import 'package:myshop/Screens/Cart_screen.dart';
import 'package:myshop/Screens/Product_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:myshop/Screens/productoverview.dart';
import './Providers/product_provider.dart';
import './Providers/cart.dart';
import './Screens/edit_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application yhyhb6.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      //multiple providers
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Order(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        home: ProductOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProduct.routeName: (ctx) => UserProduct(),
          EditProduct.routeName: (ctx) => EditProduct(),
        },
      ),
    );
  }
}
