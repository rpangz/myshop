import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import 'package:flutter_complete_guide/widgets/product_item.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  bool showFavoriteOnly;

  ProductGrid(this.showFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final _loadedProduct = (showFavoriteOnly)
        ? productProvider.favoriteItems
        : productProvider.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3 / 2,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _loadedProduct.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: _loadedProduct[index],
          child: ProductItem(),
        );
      },
    );
  }
}
