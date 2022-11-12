import 'package:flutter/material.dart';
import 'package:myshop/widgets/drawer.dart';
import '../Providers/product.dart';
import './Cart_screen.dart';
import 'package:myshop/widgets/icon_badge.dart.dart';
// import '../widgets/Product_Grid.dart';
import '../widgets/product_grid.dart';
import 'package:provider/provider.dart';
import '../Providers/product_provider.dart';
import '../Providers/cart.dart';

enum FilterOption {
  //enums
  favorites,
  showall,
}

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = '.product-overview';
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavourites = false;
  var _isInit = true;
  var _isloading = false;
  @override
  void initState() {
    // Provider.of<Products>(context).fetchAndSetProduct(); context can not be used here as the  build is not initialized yet
    // Future.delayed(Duration.zero).then((value) {
    //   //helper constructor to build a new future
    //   Provider.of<Products>(context).fetchAndSetProduct();
    // });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    //runs after the widget are done initializing but has the tendency of running multiple times
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isloading = true;
      });

      Provider.of<Products>(context, listen: false)
          .fetchAndSetProduct()
          .then((value) {
        setState(() {
          _isloading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsdata = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            //item builder must return a popupMenuItem and should be at first
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Favorites"),
                value: FilterOption.favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOption.showall,
              ),
            ],
            icon: const Icon(Icons.more_vert),
            onSelected: (FilterOption select) {
              setState(
                () {
                  if (select == FilterOption.favorites) {
                    _showOnlyFavourites = true;
                    // productsdata.productShowFavourite();
                  } else {
                    _showOnlyFavourites = false;
                    // productsdata.productShowAll();
                  }
                },
              );
            },
          ),
          // Consumer<Cart>(
          //   builder: (ctx, cartData, _) => Badge(
          //     child: IconButton(
          //       icon: Icon(Icons.shopping_cart),
          //    onPressed: (){
          //     //...
          //    }, ),
          //     value: cartData.cartItem.toString(),
          //   ),
          // ), Alternatively the third parameter og the builder requires a widget
          Consumer<Cart>(
            builder: (ctx, cartData, ch) => Badge(
              child: ch,
              value: cartData.cartItem.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ))
          : ProductGrid(_showOnlyFavourites),
    );
  }
}
