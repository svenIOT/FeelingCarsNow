import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:feeling_cars_now/src/utils/utils.dart' as utils;
import 'package:feeling_cars_now/src/user_preferences/user_preferences.dart';

class ErrorReportScreen extends StatefulWidget {
  static final String routeName = 'error';

  @override
  _ErrorReportScreenState createState() => _ErrorReportScreenState();
}

class _ErrorReportScreenState extends State<ErrorReportScreen> {
  final prefs = new UserPreferences();
  List<String> attachments = [];

  final _recipientController = TextEditingController(
    text: 'a_daniel.montanez.sepulveda@iespablopicasso.es',
  );

  final _subjectController =
      TextEditingController(text: 'Resumen del problema');

  final _bodyController = TextEditingController(
    text: 'Explicación del problema lo más detalladamente posible.',
  );

  @override
  void initState() {
    super.initState();
    prefs.lastScreen = ErrorReportScreen.routeName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reportar error'),
        actions: <Widget>[
          IconButton(
            onPressed: send,
            icon: Icon(Icons.send),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _subjectController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Asunto',
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Column(
                    children: attachments.map((attachment) {
                      final List<String> attachmentName = attachment.split("/");
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              attachmentName[attachmentName.length - 1] ??
                                  attachment,
                              softWrap: false,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () => {_removeAttachment(attachment)},
                          )
                        ],
                      );
                    }).toList(),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Adjuntar imágenes'),
                      IconButton(
                        icon: Icon(
                          Icons.attach_file,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: _openImagePicker, //_openImagePicker,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Le solicita al usuario su gestor de correo, le prepara el email
  /// con los datos ingresados ya listo para enviar.
  Future<void> send() async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: [_recipientController.text],
      attachmentPaths: attachments,
      isHTML: false,
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Gracias por tu tiempo, enviando...';
    } catch (error) {
      platformResponse = error.toString();
    }

    if (!mounted) return;

    utils.showSnackBar(context, platformResponse);
    Navigator.pop(context);
  }

  /// Abre la galería para seleccionar una imagen y añade la imagen seleccionada a la
  /// lista de archivos adjuntos. Actualiza el estado
  void _openImagePicker() async {
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (pick != null) {
      setState(() {
        attachments.add(pick.path);
      });
    }
  }

  /// Elimina un archivo adjunto. Actualiza el es estado
  void _removeAttachment(String attatchment) {
    setState(() {
      attachments.remove(attatchment);
    });
  }
}
