import 'package:ArabDealProject/ui/shared/image_network.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImageFromNetwork extends StatelessWidget {
  const CachedImageFromNetwork({this.urlImage});
  final urlImage;
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: 'https://3ard.de' + urlImage,
      errorWidget: (context, url, error) {
        return ImageFromNetwork(url: urlImage);
      },
      // placeholder: (context, url) => Container(
      //     width: 50,
      //     height: 50,
      //     child: Center(child: CircularProgressIndicator())),
      progressIndicatorBuilder: (context, url, downloadProgress) =>
          Container(child: Center(child: CircularProgressIndicator(value: downloadProgress.progress))),
    );
  }
}
