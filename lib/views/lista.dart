import 'package:flutter/material.dart';
import 'package:productos/provider/productos_provider.dart';
import 'package:productos/utils/globlal.dart';

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  final productosProvider = new ProductosProvider();
  List<dynamic> productos = [];
  ScrollController scrollController = new ScrollController();
  int inicio = 0;
  bool loading = true;
  int cantidad = 10;

  Widget widgetAux = Container();

  @override
  void dispose() {
    print("se ejecuta el dispose");
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    cargarProductos();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("Agregamos 10 elementos...");
        cargarProductos();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                productos = [];
                inicio = 0;
              });

              cargarProductos();
            },
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: <Widget>[listaProductos(), crearLoaging()],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "detalle");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void cargarProductos() {
    String param = "$inicio,$cantidad";
    inicio = (inicio + cantidad);
    setState(() {
      loading = true;
    });
    productosProvider.getProductos(param).then((data) {
      data['data'].forEach((item) {
        productos.add(item);
      });

      setState(() {
        loading = false;
      });
      if (inicio > 10) {
        scrollController.animateTo(scrollController.position.pixels + 100,
            curve: Curves.fastOutSlowIn, duration: Duration(milliseconds: 950));
      }
    });
  }

  Widget listaProductos() {
    return ListView.builder(
      controller: scrollController,
      itemCount: productos.length,
      itemBuilder: (BuildContext contex, int index) {
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
            child: Center(
              child: Text("Eliminar"),
            ),
          ),
          child: ListTile(
            subtitle: Text(productos[index]['descripcion'],
                overflow: TextOverflow.fade, maxLines: 1, softWrap: false),
            title: Text(productos[index]['codigo']),
            trailing: Text("\$" + productos[index]['precio1']),
            onTap: () {
              Navigator.pushNamed(context, "detalle",
                  arguments: productos[index]);
            },
          ),
          onDismissed: (direccion) {
            _eliminarProducto(productos[index]['codigo']);
          },
        );
      },
    );
  }

  Widget crearLoaging() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Container();
    }
  }

  void _eliminarProducto(String codigo) {
    //usamos el settstate para evitar que el Dismissible muestre error
    setState(() {
      productosProvider.eliminarProductos(codigo).then((data) {
        muestraMensaje(data);
      });
    });
  }
}
