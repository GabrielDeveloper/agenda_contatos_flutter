import 'dart:io';
 
import 'package:agenda_contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
 
class ContactPage extends StatefulWidget {
  final Contact contact;
 
  ContactPage({this.contact});
 
  @override
  _ContactPageState createState() => _ContactPageState();
}
 
class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameFocus = FocusNode();
  bool _userEdited;
 
  Contact _editedContact;
 
  @override
  void initState() {
    super.initState();
 
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }
 
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "Novo Contato"),
          backgroundColor: Colors.red,
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
            onPressed: () {
              if (_editedContact.name != null &&
                  _editedContact.name.isNotEmpty) {
                Navigator.pop(context, _editedContact);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            }),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _editedContact.img != null
                              ? FileImage(File(_editedContact.img))
                              : AssetImage("images/person.png"))),
                ),
                onTap: () {
                  _showImageOptions(context, _editedContact);
                  
                },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text) {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                onChanged: (text) {
                  _userEdited = true;
                  _editedContact.phone = text;
                },
                keyboardType: TextInputType.phone,
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showImageOptions(BuildContext context, Contact index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Selecione"),
          content: Text("Pegar imagem da galeria ou da camera"),
          actions: <Widget>[
            FlatButton.icon(
              onPressed: (){
                ImagePicker.pickImage(source: ImageSource.camera).then((file){
                  if (file == null) return;
                  setState(() {
                    _editedContact.img = file.path;  
                  });
                });
                Navigator.pop(context);
              },
              icon: Icon(Icons.camera_alt),
              label: Text("Camera"),
            ),
            FlatButton.icon(
              onPressed: (){
                ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                  if (file == null) return;
                  setState(() {
                    _editedContact.img = file.path;  
                  });
                });
                Navigator.pop(context);
              },
              icon: Icon(Icons.image),
              label: Text("Galery"),
            )
          ],
        );
      }
    );
  }
 
  Future<bool> _requestPop() {
    if (_userEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
/*
ImagePicker.pickImage(source: ImageSource.gallery).then((file){
                    if (file == null) return;
                    setState(() {
                      _editedContact.img = file.path;  
                    });
                  });
                  */