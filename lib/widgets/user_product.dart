import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:myshop/Providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../Screens/edit_product_screen.dart';
import '../Providers/product_provider.dart';
import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  UserProductItem(this.title, this.imageUrl, this.id);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Card(
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProduct.routeName, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () async {
                  //cant access scaffold in Future
                  try {
                    await Provider.of<Products>(context, listen: false)
                        .deleteUsrProduct(id);
                  } catch (erroe) {}
                  scaffold.showSnackBar(SnackBar(
                    content: Text("Can't delete the product"),
                  ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
