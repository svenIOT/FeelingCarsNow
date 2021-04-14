import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/models/product_model.dart';
import 'package:form_validation/src/widgets/drawer.dart';
import 'package:form_validation/src/widgets/search_elements.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final _height = MediaQuery.of(context).size.height;
    //final _width = MediaQuery.of(context).size.width;

    final productsBloc = Provider.productsBloc(context);
    productsBloc.loadProducts();

    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        drawer: UserDrawer(),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                // Elementos de búsqueda y filtros
                SearchElements(),
                // Lista de coches destacados
                _createFeaturedList(),
                // Lista de coches genérica
                _createList(productsBloc),
              ],
            ),
          ),
        ),
        floatingActionButton: _createFloatingActionButton(context));
  }

  Widget _createList(ProductsBloc productsBloc) {
    return StreamBuilder(
      stream: productsBloc.productsStream,
      builder: (BuildContext context,
              AsyncSnapshot<List<ProductModel>> snapshot) =>
          snapshot.hasData
              ? ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) =>
                      _createItem(context, snapshot.data[index], productsBloc))
              : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _createFloatingActionButton(BuildContext context) =>
      FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'product'),
      );

  Widget _createItem(
      BuildContext context, ProductModel product, ProductsBloc productsBloc) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red[400],
      ),
      onDismissed: (direction) => productsBloc.deleteProduct(product.id),
      child: Card(
        child: Column(
          children: <Widget>[
            (product.photoUrl == null)
                ? Image(
                    image: AssetImage('assets/no-image.png'),
                    height: 250.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : FadeInImage(
                    placeholder: AssetImage('assets/jar-loading.gif'),
                    image: NetworkImage(product.photoUrl),
                    height: 250.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
            ListTile(
              title: Text('${product.title} - ${product.value}'),
              subtitle: Text(product.id),
              onTap: () =>
                  Navigator.pushNamed(context, 'product', arguments: product),
            ),
          ],
        ),
      ),
    );
  }

  Widget _createFeaturedList() {
    return Container(
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            width: 100.0,
            color: Colors.red,
          ),
          Container(
            width: 100.0,
            color: Colors.blue,
          ),
          Container(
            width: 100.0,
            color: Colors.green,
          ),
          Container(
            width: 100.0,
            color: Colors.yellow,
          ),
          Container(
            width: 100.0,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
