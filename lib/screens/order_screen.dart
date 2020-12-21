import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/order.dart';
import 'package:flutter_complete_guide/widgets/app_drawer.dart';
import 'package:flutter_complete_guide/widgets/order_item.dart' as oI;
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  // var _isLoaded = true;

  // @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<Order>(context, listen: false).fetchAndOrder().then((_) {
  //       setState(() {
  //         _isLoaded = false;
  //       });
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Order>(context, listen: false).fetchAndOrder(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text('An Error Occured'),
                );
              } else {
                return Consumer<Order>(builder: (ctx, data, child) {
                  return data.orders.length == 0
                      ? Center(
                          child: Column(
                            children: [
                              Container(
                                // height: 200,
                                child: Image.asset(
                                  'assets/images/empty.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Text(
                                'Waiting your orders . . .',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: data.orders.length,
                          itemBuilder: (ctx, index) {
                            return oI.OrderItem(data.orders[index]);
                          },
                        );
                });
              }
            }
          },
        )
        // _isLoaded
        //     ? Center(
        //         child: CircularProgressIndicator(),
        //       )
        //     : ListView.builder(
        //         itemCount: orderProvider.orders.length,
        //         itemBuilder: (ctx, index) {
        //           return oI.OrderItem(orderProvider.orders[index]);
        //         },
        //       ),
        );
  }
}
