import 'package:flutter/material.dart';
import 'package:myshop/Screens/edit_product_screen.dart';
import 'package:myshop/widgets/drawer.dart';
import 'package:myshop/widgets/user_product.dart';
import 'package:provider/provider.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../Providers/product_provider.dart';

class UserProduct extends StatelessWidget {
  static const routeName = '/user-Product-Screen';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productInfo = Provider.of<Products>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(title: Text("Your Products"), actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProduct.routeName);
            }),
      ]),
      body: RefreshIndicator(
        //for refreshing a page when pulled down
        onRefresh: (() => _refreshProducts(
            context)), //if a function is passing context as an argument then wrap it in an anonymous function
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemBuilder: (ctx, index) => Column(
              children: [
                UserProductItem(
                    productInfo.items[index].title,
                    productInfo.items[index].imageUrl,
                    productInfo.items[index].id),
                Divider(),
              ],
            ),
            itemCount: productInfo.items.length,
          ),
        ),
      ),
    );
  }
}
