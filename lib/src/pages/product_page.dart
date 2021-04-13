import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/bloc/products_bloc.dart';
import 'package:form_validation/src/models/product_model.dart';
import 'package:form_validation/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductsBloc productsBloc;
  ProductModel product = new ProductModel();
  bool _isSaving = false;
  File photo;

  @override
  Widget build(BuildContext context) {
    productsBloc = Provider.productsBloc(context);
    final ProductModel argumentProduct =
        ModalRoute.of(context).settings.arguments;
    if (argumentProduct != null) product = argumentProduct;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectGaleryImage,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _shootPhoto,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _showImage(),
                _productName(),
                _productPrice(),
                _createSaveButton(),
                _productAvailable()
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _createFloatingActionButton(context),
    );
  }

  Widget _createFloatingActionButton(BuildContext context) =>
      FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () => Navigator.pushNamed(context, 'product'),
      );

  Widget _productName() {
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: (value) => product.title = value,
      validator: (value) =>
          value.length < 3 ? 'Ingrese el nombre del producto' : null,
    );
  }

  Widget _productPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => product.value = double.parse(value),
      validator: (value) =>
          utils.isNumber(value) ? null : 'Ingrese solo números para el precio',
    );
  }

  Widget _productAvailable() {
    return SwitchListTile(
      value: product.available,
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: (value) => setState(() {
        product.available = value;
      }),
    );
  }

  Widget _createSaveButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.deepPurple,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      label: Text('Guardar'),
      onPressed: (_isSaving) ? null : _submit,
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() => _isSaving = true);

    // Si la foto es != null es que tengo que subir la foto
    if (photo != null) product.photoUrl = await productsBloc.uploadImage(photo);

    // Si el producto no tiene ID lo crea
    product.id == null
        ? productsBloc.addProduct(product)
        : productsBloc.editProduct(product);

    setState(() => _isSaving = false);
    showSnackBar('Registro guardado correctamente');
    Navigator.pop(context);
  }

  void showSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration(milliseconds: 1750),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  _showImage() => product.photoUrl != null
      ? FadeInImage(
          image: NetworkImage(product.photoUrl),
          placeholder: AssetImage('assets/jar-loading.gif'),
          height: 300.0,
          fit: BoxFit.cover,
        )
      : Image(
          // Si la foto.path es null escoje la imagen de assets
          image: AssetImage(photo?.path ?? 'assets/no-image.png'),
          height: 300.0,
          fit: BoxFit.cover,
        );

  _selectGaleryImage() async {
    setState(() {
      _processImage(ImageSource.gallery);
    });
  }

  _shootPhoto() async {
    setState(() {
      _processImage(ImageSource.camera);
    });
  }

  _processImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(
      source: source,
    );

    photo = File(pickedFile.path);

    if (photo != null) return product.photoUrl == null;
  }
}
