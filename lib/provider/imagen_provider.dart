import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:path/path.dart';
import 'package:async/async.dart';

class ImagenProvider {

 Future upload(File imageFile) async {
   print("Iniciamos la carga");
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    var uri = Uri.parse("https://mareliz.com/api/upload");
    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile(
      'file',
       stream,
       length,
        filename: basename(imageFile.path)
        );
    //contentType: new MediaType('image', 'png'));
    request.files.add(multipartFile);
    var streamResponse =  await request.send();
    final resp = await http.Response.fromStream(streamResponse);
    return json.decode(resp.body);
  }




}
