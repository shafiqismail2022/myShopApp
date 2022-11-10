import 'package:flutter/src/foundation/key.dart';
import 'package:provider/provider.dart';
import '../Providers/product.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:myshop/Screens/Product_detail_screen.dart';
import '../Providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // ProductItem(this.id, this.title, this.imageUrl);
  // @override
  Widget build(BuildContext context) {
    final productsdata = Provider.of<Product>(context,
        listen: false); //only listen when instantaited
    final CartData = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            productsdata.imageUrl,
            fit: BoxFit.cover,
            height: 250,
          ),
          // onTap: () => Navigator.of(context).push(
          //   MaterialPageRoute(builder: (ctx) => ProductDetailScreen(title)),
          onTap: () => Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: productsdata.id),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (context, value, _) => IconButton(
              //child can be used to refer to a widget which does not changes in the Consumer argument
              icon: Icon(
                productsdata.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border,
              ),
              onPressed: () => productsdata.togglefavourite(),
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            productsdata.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              CartData.addCartItem(
                  productsdata.id, productsdata.price, productsdata.title);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Added to Cart",
                    // textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: (() {
                      CartData.removeSingleItem(productsdata.id);
                    }),
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
