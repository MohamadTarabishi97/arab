import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_absolute_path/flutter_absolute_path.dart';

class UploadImageToServerHttpService {
 


  static Future<String> uploadImage(Asset imageAsset) async {
  
   try{
      final filePath =
        await FlutterAbsolutePath.getAbsolutePath(imageAsset.identifier);
    print(filePath);
    final uploadedImage = File(filePath);
    var stream = new http.ByteStream(uploadedImage.openRead());
    stream.cast();
    var length = await uploadedImage.length();

    var uri = Uri.parse('https://3ard.de/api/file/single');
    
    var request = new http.MultipartRequest("POST", uri);
    var multipartFile = new http.MultipartFile('image_url', stream, length,
        filename: basename(uploadedImage.path));
    request.files.add(multipartFile);
    var response = await request.send();
    final responseAsString = await response.stream.bytesToString();
    final Map responseAsMap=json.decode(responseAsString);
    int statusCode=responseAsMap['code'];
    if(statusCode==200){
      print(responseAsString);
     String uploadedImageURL=responseAsMap['data'];
     print(uploadedImageURL);
     return uploadedImageURL;

    }
   }catch(e){
     print(e.toString()+'yes bro');
   }
  }
}

