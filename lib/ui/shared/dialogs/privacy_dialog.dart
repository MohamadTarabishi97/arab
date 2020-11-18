import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/lunch_rul.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PrivacyDialog extends StatelessWidget {
  final double radius;
  final String mdFileName;

  const PrivacyDialog({Key key, this.radius, this.mdFileName})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
        child: Column(
          children: [
            Expanded(
                child: FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 150))
                        .then((value) {
                      return rootBundle.loadString('assets/$mdFileName');
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Markdown(
                          data: snapshot.data,
                          onTapLink: (link) async {
                            bool isConnected =
                                await checkInternetConnectivity();
                            if (isConnected) {
                              await LaunchUrl.launchURL(link);
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(ArabDealLocalization.of(context)
                                      .getTranslatedWordByKey(
                                          key:
                                              'all_pages_no_internet_connection'))));
                            }
                          },
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    })),
            FlatButton(
                padding: EdgeInsets.all(8),
                color: Colors.grey[300],
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(radius),
                          bottomRight: Radius.circular(radius))),
                  alignment: Alignment.center,
                  height: 50,
                  width: double.infinity,
                  child: Text('Close',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ))
          ],
        ));
  }
}
