import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/order.dart';
import 'package:flutter_complete_guide/widgets/cart_item.dart';
import 'package:flutter_complete_guide/screens/order_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$ ${cartProvider.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.title.color),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    OrderButton(cartProvider: cartProvider)
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: cartProvider.itemsCount,
                  itemBuilder: (ctx, index) {
                    final cartItemList = cartProvider.items.values.toList();
                    final cartItemkey = cartProvider.items.keys
                        .toList(); //convert map into list
                    return CartItemWidget(
                      cartItemList[index].id,
                      cartItemkey[index],
                      cartItemList[index].title,
                      cartItemList[index].price,
                      cartItemList[index].qty,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cartProvider,
  }) : super(key: key);

  final Cart cartProvider;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: widget.cartProvider.totalAmount <= 0
          ? null
          : () {
              setState(() {
                _isLoading = true;
              });
              Provider.of<Order>(context, listen: false)
                  .addOrder(
                widget.cartProvider.items.values.toList(),
                widget.cartProvider.totalAmount,
              )
                  .then((e) {
                setState(() {
                  _isLoading = false;
                });

                widget.cartProvider.clearCart();
                // Navigator.of(context).pushNamed(OrderScreen.routeName);
              });
            },
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      textColor: Theme.of(context).primaryColor,
    );
  }
}
