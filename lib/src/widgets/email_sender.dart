import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:feeling_cars_now/src/utils/utils.dart' as utils;

class EmailSender extends StatefulWidget {
  final String title, recipent, subject, body;

  EmailSender({@required this.title, this.recipent, this.subject, this.body});

  @override
  _EmailSenderState createState() => _EmailSenderState();
}

class _EmailSenderState extends State<EmailSender> {
  List<String> attachments = [];

  final _recipientController = TextEditingController();

  final _subjectController = TextEditingController();

  final _bodyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _recipientController.text = widget.recipent ?? '';
    _subjectController.text = widget.subject ?? '';
    _bodyController.text = widget.body ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                controller: _recipientController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Destinatario',
                ),
              ),
            ),
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
                      labelText: 'Mensaje', border: OutlineInputBorder()),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  for (var i = 0; i < attachments.length; i++)
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            attachments[i],
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_circle),
                          onPressed: () => {_removeAttachment(i)},
                        )
                      ],
                    ),
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
    );

    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'Mensaje envíado correctamente';
    } catch (error) {
      platformResponse = 'Ups, hubo un error...';
      print(error.toString());
    }

    if (!mounted) return;

    utils.showSnackBar(context, platformResponse);
    Navigator.pop(context);
  }

  /// Abre la galería del dispositivo para seleccionar una imagen, la añade a la lista de adjuntos.
  /// Actualiza el estado.
  void _openImagePicker() async {
    File pick = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (pick != null) {
      setState(() {
        attachments.add(pick.path);
      });
    }
  }

  /// Elimina una imagen en la lista de adjuntos. Actualiza el estado.
  void _removeAttachment(int index) {
    setState(() {
      attachments.removeAt(index);
    });
  }
}
