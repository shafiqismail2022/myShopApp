import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/material.dart';
import "../Providers/product_provider.dart";
import "package:provider/provider.dart";

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-details";
  // final String title;
  // ProductDetailScreen(this.title);
  @override
  Widget build(BuildContext context) {
    final productInfo = ModalRoute.of(context).settings.arguments
        as String; // getting product info through product Id
    // final loadproduct = Provider.of<Products>(context)
    //     .items
    //     .firstWhere((prod) => prod.id == productInfo);
    //Leaner code
    final loadproduct = Provider.of<Products>(context).viewProduct(productInfo);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadproduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadproduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "\$${loadproduct.price}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: double.infinity,
              child: Text(
                loadproduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
