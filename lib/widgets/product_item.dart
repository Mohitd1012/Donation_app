import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/products.dart';
import '../providers/cart.dart';
// import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String item;
  // final String imageUrl;

  // ProductItem(this.id, this.item, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    // final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.cid,
            );
          },
          child:
              Image(image: AssetImage('assets/products/${product.item}.jpg')),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          // leading: Consumer<Product>(
          //   builder: (ctx, product, _) => IconButton(
          //     icon: Icon(
          //       product.isDonate ? Icons.favorite : Icons.favorite_border,
          //     ),
          //     color: Theme.of(context).accentColor,
          //     onPressed: () {
          //       product.toggleFavoriteStatus(
          //         authData.token,
          //         authData.userId,
          //       );
          //     },
          //   ),
          // ),
          title: Text(
            product.item != null ? product.item : "Item",
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(product.cid, product.quantity, product.item);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Added item to cart!',
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.cid);
                    },
                  ),
                ),
              );
              Provider.of<Products>(context, listen: false).updateProduct(
                  product.cid,
                  Product(
                    cid: product.cid,
                    item: product.item,
                    location: product.location,
                    quantity: (int.parse(product.quantity) - 1).toString(),
                  ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
