import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final prodcutsData = Provider.of<Products>(context);
    final products = showFavs ? prodcutsData.favoriteItems : prodcutsData.items;

    return GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
              value: products[idx],
              child: ProductItem(),
            ));
  }
}
