import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     double widthOfScreen=MediaQuery.of(context).size.width;
    double heightOfScreen=MediaQuery.of(context).size.height;
    ScreenUtil.init(context,width:widthOfScreen,height:heightOfScreen);
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            child: SpinKitCubeGrid(
          duration: Duration(seconds: 1),
          size: 75,
          color:   Color(0xffde1515),
        )),
        SizedBox(height:30),
        Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_loading'),style:TextStyle( color: Colors.grey[700],fontSize:ScreenUtil().setSp(25),fontFamily: 'ElMessiri-Bold'))
      ],
    );
  }
}
