import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoInternetConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double widthOfScreen=MediaQuery.of(context).size.width;
    double heightOfScreen=MediaQuery.of(context).size.height;
    ScreenUtil.init(context,width:widthOfScreen,height:heightOfScreen);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/images/wifi.svg', width: 100, height: 150),
          SizedBox(height: 60),
          Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_no_internet_connection'),
              style: TextStyle(color: Colors.grey[700], fontSize: ScreenUtil().setSp(20),fontWeight: FontWeight.bold,fontFamily: 'ElMessiri-Bold')),
              SizedBox(height:10)
         ,Row(children: [
           Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_tap_to_refresh'),style:TextStyle(fontSize:ScreenUtil().setSp(14))),SizedBox(width:10),
           InkWell(child:Icon(Icons.refresh,),onTap:(){
             App.refrechAction(context);
           })
          
         ],mainAxisAlignment: MainAxisAlignment.center,)
        ],
      ),
    );
  }
}
