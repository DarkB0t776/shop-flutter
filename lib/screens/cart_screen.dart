import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart' hide CartItem;
import 'package:shop/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const ROUTE_NAME = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total', style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    child: Text('ORDER NOW'),
                    style: TextButton.styleFrom(
                        primary: Theme.of(context).primaryColor),
                    onPressed: () {},
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemBuilder: (ctx, idx) {
                  return CartItem(
                    id: cart.items.values.toList()[idx].id,
                    productId: cart.items.keys.toList()[idx],
                    price: cart.items.values.toList()[idx].price,
                    quantity: cart.items.values.toList()[idx].quantity,
                    title: cart.items.values.toList()[idx].title,
                  );
                },
                itemCount: cart.itemCount),
          )
        ],
      ),
    );
  }
}
