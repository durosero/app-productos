import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productos/provider/imagen_provider.dart';
import 'package:productos/provider/productos_provider.dart';
import 'package:productos/utils/globlal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

class Detalle extends StatefulWidget {
  @override
  _DetalleState createState() => _DetalleState();
}

class _DetalleState extends State<Detalle> {
  dynamic producto;
  String btnMensaje = "Guardar";
  bool activar = true;
  String imagenSubida = "";

  final productosProvider = new ProductosProvider();
  TextEditingController txtCodigo = new TextEditingController();
  TextEditingController txtDescripcion = new TextEditingController();
  TextEditingController txtPrecio = new TextEditingController();
  String imageUrl = null;

  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    producto = ModalRoute.of(context).settings.arguments;
    //llenamos los campos con los valores, solo para editar
    if (producto != null) {
      txtCodigo.text = producto['codigo'];
      txtDescripcion.text = producto['descripcion'];
      print(producto['precio1']);
      txtPrecio.text = producto['precio1'];
      //si no se ha seleccionado imagen colocamos la imagen por defecto
      imageUrl = (_image == null) ? producto['imagen'] : null;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle producto"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: _camara,
          ),
          IconButton(
            icon: Icon(Icons.image),
            onPressed: _galeria,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              _mostrarFoto(),
              _crearInputs(),
              SizedBox(
                height: 10,
              ),
              _crearBotones(context)
            ],
          ),
        ),
      ),
    );
  }

  Widget _mostrarFoto() {
    if (imageUrl != null) {
      return FadeInImage(
        image: NetworkImage(imageUrl),
        placeholder: AssetImage('assets/loading.gif'),
        fit: BoxFit.cover,
      );
    } else {
      //usamos un operador ternario para cambiar de widget en caso de no seleccionar imagen
      return Image(
        image: (_image?.path == null)
            ? AssetImage('assets/no-image.png')
            : FileImage(
                _image), //AssetImage(_image?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  Widget _crearInputs() {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: "Código"),
            controller: txtCodigo,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Descripción"),
            controller: txtDescripcion,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Precio"),
            controller: txtPrecio,
          ),
        ],
      ),
    );
  }

  Widget _crearBotones(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              child: Text(btnMensaje),
              onPressed: (activar) ? () => _subirImagen(context) : null,
              color: Colors.green,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: RaisedButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          )
        ],
      ),
    );
  }

  void _guardarProducto(BuildContext context) {
    if (producto == null) {
      productosProvider
          .guardarProducto(
              txtCodigo.text, txtDescripcion.text, txtPrecio.text, imagenSubida)
          .then((data) {
        if (data['error'] == false) {
          Navigator.pushNamed(context, "lista");
        }
        muestraMensaje(data);
        print(data);
      });
    } else {
      //ACTUALIZAR EL PRODUCTO
      productosProvider
          .editarProducto(producto['id'], txtCodigo.text, txtDescripcion.text,
              txtPrecio.text, imagenSubida)
          .then((data) {
        if (data['error'] == false) {
          Navigator.pushNamed(context, "lista");
        }
        muestraMensaje(data);
      });
    }
  }

  void _subirImagen(BuildContext context) async {
    //Validamos si selecciono imagen, no es asi guardamos directamente
    if (_image == null) {
      _guardarProducto(context);
    } else {
      Response response;
      Dio dio = new Dio();
      final formData = FormData.fromMap({
        "name": "wendux",
        "age": 25,
        "file": await MultipartFile.fromFile(_image.path)
      });
      response = await dio.post(
        "https://mareliz.com/api/upload",
        data: formData,
        onSendProgress: (int sent, int total) {
          print("$sent $total");
          setState(() {
            String porcentaje = ((sent * 100) / total).toStringAsFixed(0);
            btnMensaje = "Subiendo $porcentaje%";
            activar = false;
          });
        },
      );
      if (response.statusCode == 200) {
        print(response.data);
        Map respuesta = response.data;
        imagenSubida = respuesta['data']['name'];
        print("la imagen subida al servidor es: " + imagenSubida);
        setState(() {
          btnMensaje = "Guardar";
          activar = true;
        });
        _guardarProducto(context);
      } else {
            Map info = {'message': "Servicio no disponible"};
            muestraMensaje(info);
            setState(() {
               activar = true;
            });
      }
    }
  }

//METODO QUE INICIA LA CAMARA
  Future _camara() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  //METODO QUE ABRE LA GALERIA
  Future _galeria() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }
}
