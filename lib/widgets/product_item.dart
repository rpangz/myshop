import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageurl;

  // ProductItem(this.id, this.title, this.imageurl);

  @override
  Widget build(BuildContext context) {
    final productDetail = Provider.of<Product>(context, listen: false);
    final cartProvider = Provider.of<Cart>(context, listen: false);
    final authProvider = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            // Navigator.of(context).push(
            // MaterialPageRoute(builder: (ctx) => ProductDetailScreen()),
            // );
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: productDetail.id,
            );
          },
          child: Hero(
            tag: productDetail.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(productDetail.imageUrl),
            ),
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavorite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () => product.toogleFavorite(
                  authProvider.token, authProvider.userId),
              color: Theme.of(context).accentColor,
            ),
          ),
          title: Text(
            productDetail.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cartProvider.addItem(
                productDetail.id,
                productDetail.price,
                productDetail.title,
              );
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added item to cart!!'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cartProvider.removeSingelItem(productDetail.id);
                    },
                  ),
                ),
              );
            },
            color: Theme.of(context).accentColor,
          ),
          backgroundColor: Colors.black87,
        ),
      ),
    );
  }
}
