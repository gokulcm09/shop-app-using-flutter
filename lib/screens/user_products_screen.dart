import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../widgets/main_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refresh(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //  final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductsScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
          future: _refresh(context),
          builder: (ctx, snapShot) => snapShot.connectionState ==
                  ConnectionState.waiting
              ? Consumer<Products>(
                  builder: (ctx, productData, _) =>
                      Center(child: CircularProgressIndicator()))
              : Consumer<Products>(
                  builder: (ctx, productsData, _) => productsData.items.isEmpty
                      ? Center(
                          child: Text('No products yet! Add some!'),
                        )
                      : RefreshIndicator(
                          onRefresh: () => _refresh(context),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                                itemBuilder: (ctx, index) => UserProductItem(
                                      productsData.items[index].title,
                                      productsData.items[index].imageUrl,
                                      productsData.items[index].id,
                                    ),
                                itemCount: productsData.items.length),
                          ),
                        ),
                )),
      drawer: MainDrawer(),
    );
  }
}
