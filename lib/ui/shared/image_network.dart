import 'package:ArabDealProject/ui/shared/cached__image_from_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageFromNetwork extends StatelessWidget {
  final String url;
  ImageFromNetwork({this.url}) ;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      'https://3ard.de' +url,
      errorBuilder: (context,child,stackTrace){
         return CachedImageFromNetwork(urlImage: url,); 
      },
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) {
          print(child);
          return child;
        }
        return Container(
          child: Center(
            child: CircularProgressIndicator(
            ),
          ),
        );
      },
    );
  }
}
