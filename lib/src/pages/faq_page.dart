import 'package:flutter/material.dart';

import 'package:feeling_cars_now/src/constants/faq_constants.dart'
    as faqConstants;
import 'package:feeling_cars_now/src/widgets/text_header.dart';
import 'package:feeling_cars_now/src/models/item_model.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  @override
  Widget build(BuildContext context) {
    // Creación de items desde los datos en las constantes
    List<Item> _faqBasicsItems =
        _getItemsContent(faqConstants.faqBasicsContent);
    List<Item> _faqCarsAndSellersItems =
        _getItemsContent(faqConstants.faqCarsAndSellersContent);
    List<Item> _faqAccountAndSecurityItems =
        _getItemsContent(faqConstants.faqAccountAndSecurityContent);

    return Scaffold(
      appBar: AppBar(
        title: Text("Preguntas frecuentes"),
      ),
      body: ListView(padding: EdgeInsets.all(10.0), children: [
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextHeader('FAQs'),
              SizedBox(height: 5.0),
              Text(
                'Estas FAQ buscan aclarar dudas básicas sobre el uso de Feeling Cars Now. Si tiene dudas específicas contacte con el desarrollador',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 15.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'General',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            ExpansionPanelList(
              animationDuration: Duration(seconds: 1),
              expansionCallback: (index, isExpanded) => setState(() {
                // TODO: no se aplica el cambio en los expansionPanel
                print(
                    'Elemento ${index} - Pre tap ${_faqBasicsItems[index].isExpanded}');
                _faqBasicsItems[index].isExpanded = !isExpanded;
                print(
                    'Elemento ${index} - Post tap ${_faqBasicsItems[index].isExpanded}');
              }),
              children: _createExpansionPanels(_faqBasicsItems),
              expandedHeaderPadding: EdgeInsets.all(5.0),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Coches y vendedores',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            ExpansionPanelList(
              animationDuration: Duration(seconds: 1),
              expansionCallback: (index, isExpanded) => setState(() {
                _faqCarsAndSellersItems[index].isExpanded = !isExpanded;
              }),
              children: _createExpansionPanels(_faqCarsAndSellersItems),
              expandedHeaderPadding: EdgeInsets.all(5.0),
            ),
          ],
        ),
        SizedBox(height: 20.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text(
                'Cuenta',
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
            ExpansionPanelList(
              animationDuration: Duration(seconds: 1),
              expansionCallback: (index, isExpanded) => setState(() {
                _faqAccountAndSecurityItems[index].isExpanded = !isExpanded;
              }),
              children: _createExpansionPanels(_faqAccountAndSecurityItems),
              expandedHeaderPadding: EdgeInsets.all(5.0),
            ),
          ],
        ),
      ]),
    );
  }

  List<Item> _getItemsContent(List<Map<String, String>> faqContent) {
    List<Item> faqItems = [];

    faqContent.forEach((item) {
      faqItems.add(Item(header: item.values.first, body: item.values.last));
    });

    return faqItems;
  }

  List<ExpansionPanel> _createExpansionPanels(List<Item> items) =>
      items.map((item) {
        return ExpansionPanel(
          headerBuilder: (context, isExpanded) => TextHeader(item.header),
          body: Text(item.body),
          isExpanded: item.isExpanded,
          canTapOnHeader: true,
        );
      }).toList();
}
