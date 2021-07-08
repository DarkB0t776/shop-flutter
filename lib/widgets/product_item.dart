import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/providers/product.dart';
import 'package:shop/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  // final Product product;

  // const ProductItem({Key? key, required this.product}) : super(key: key);

  void onProductPress(BuildContext context, Product product) {
    Navigator.of(context)
        .pushNamed(ProductDetailScreen.ROUTE_NAME, arguments: product);
  }

  void onPressFavoriteButton(Product product) {
    product.toggleFavoriteStatus();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () => onProductPress(context, product),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            onPressed: () => onPressFavoriteButton(product),
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).accentColor,
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
