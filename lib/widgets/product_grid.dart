import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/product_provider.dart';
import '../providers/product.dart';
import './product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;
  ProductGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final productz =
        showFavs ? productData.favouriteProduct : productData.items;
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: productz.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              //used in list or grids
              value: productz[
                  i], //alternative if it does not depend on the context
              // create: (context) {
              //   return productz[i];
              // },
              child: ProductItem(

                  // productz[i].id,
                  // productz[i].title,
                  // productz[i].imageUrl,
                  ),
            ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisExtent: 150,
        ));
  }
}
