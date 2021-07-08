import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/providers/products.dart';
import 'package:shop/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final loadedProducts = showFavs
        ? Provider.of<Products>(context).favoriteItems
        : Provider.of<Products>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: loadedProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, idx) => ChangeNotifierProvider.value(
        value: loadedProducts[idx],
        child: ProductItem(),
      ),
    );
  }
}
