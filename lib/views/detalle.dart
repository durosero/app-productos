import 'package:flutter/material.dart';
import 'package:productos/provider/productos_provider.dart';
import 'package:productos/utils/globlal.dart';

class Detalle extends StatelessWidget {
  dynamic producto;
  final productosProvider = new ProductosProvider();
  TextEditingController txtCodigo = new TextEditingController();
  TextEditingController txtDescripcion = new TextEditingController();
  TextEditingController txtPrecio = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    producto = ModalRoute.of(context).settings.arguments;
    //llenamos los campos con los valores
    if (producto != null) {
      txtCodigo.text = producto['codigo'];
      txtDescripcion.text = producto['descripcion'];
      txtPrecio.text = producto['precio1'];
    }
    print(producto);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Detalle producto"),
        ),
        body: Container(
          margin: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
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
              child: Text("Guardar"),
              onPressed: () {
                _guardarProducto(context);
              },
              color: Colors.green,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: RaisedButton(
              child: Text("Cancelar"),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  void _guardarProducto(BuildContext context) {
    if (producto == null) {
      productosProvider
          .guardarProducto(txtCodigo.text, txtDescripcion.text, txtPrecio.text)
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
              txtPrecio.text)
          .then((data) {
        if (data['error'] == false) {
          Navigator.pushNamed(context, "lista");
        }
        muestraMensaje(data);
      });
    }
  }
}
