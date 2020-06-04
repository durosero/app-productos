import 'dart:convert';

import 'package:http/http.dart' as http;

class ProductosProvider {
  final String _url = "https://mareliz.com/api";

  Future getProductos(String pagina) async {
     final url = _url+"/listar/${pagina}";
     print(url);
    var response = await http.get(url);
   // print(response.body);
    final decodeData = json.decode(response.body);
    return decodeData;
    //print(response.body);
  }

   Future guardarProducto(String codigo, String descripcion, String precio, String imagen) async {
     final url = _url+"/guardar";
    Map<String, String> params = {
      'codigo' : codigo,
      'descripcion' : descripcion,
      'precio1' : precio,
      'imagen' : imagen
    }; 

    final response = await http.post(
      url,
      body: params,
      headers: {
        'Accept' : 'application/json',
        'Content-Type' : 'application/x-www-form-urlencoded'
      }
      );
    final decodeData = json.decode(response.body);
    return decodeData;
  }

  Future editarProducto(String id, String codigo, String descripcion, String precio, String imagen) async {
     final url = _url+"/actualizar/$id";
    Map<String, String> params = {
      'codigo' : codigo,
      'descripcion' : descripcion,
      'precio1' : precio,
      'imagen' : imagen
    }; 
    print(params);
    print(url);

    final response = await http.post(
      url,
      body: params,
      headers: {
        'Accept' : 'application/json',
        'Content-Type' : 'application/x-www-form-urlencoded'
      }
      );
    final decodeData = json.decode(response.body);
    return decodeData;
  }

  Future eliminarProductos(String codigo) async{
     final url = _url+"/eliminar/$codigo";
     print(url);
    var response = await http.delete(url);
   // print(response.body);
    final decodeData = json.decode(response.body);
    return decodeData;
  }

  


}
