import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/user_product_item.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';
  var _isLoading = false;

  Future<void> _fetchData(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productProv = Provider.of<ProductProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Product'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            )
          ],
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _fetchData(context),
          builder: (ctx, snapShop) =>
              snapShop.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _fetchData(context),
                      child: Consumer<ProductProvider>(
                        builder: (ctx, productProv, _) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              itemCount: productProv.items.length,
                              itemBuilder: (ctx, index) {
                                final itemsdata = productProv.items;
                                return Column(
                                  children: [
                                    UserProductItem(
                                      itemsdata[index].id,
                                      itemsdata[index].title,
                                      itemsdata[index].description,
                                      itemsdata[index].imageUrl,
                                    ),
                                    Divider(),
                                  ],
                                );
                              }),
                        ),
                      ),
                    ),
        ));
  }
}
