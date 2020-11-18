import 'package:ArabDealProject/language/language_classes/language.dart';
import 'package:ArabDealProject/language/localization/change_locale_function.dart';
import 'package:ArabDealProject/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class CustomAppBar extends StatelessWidget {
  
  CustomAppBar({@required this.scaffoldKey});
final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    double widthOfScreen = MediaQuery.of(context).size.width;
    double heightOfScreen = MediaQuery.of(context).size.height;
    ScreenUtil.init(context,width:widthOfScreen,height:heightOfScreen);

    Locale currentLocale = Localizations.localeOf(context);
    return Container(
      width: widthOfScreen,
      height: ScreenUtil().setHeight(100),
      color: Color(0xffe4e4e4),
      child: Padding(
          padding:  EdgeInsets.only(
            top:  ScreenUtil().setHeight(20),
          ),
          child: (currentLocale.countryCode == "SY")
              ? _arabicAppBarRow(context, scaffoldKey)
              : _germanAppBarRow(context, scaffoldKey)),
    );
  }
}

Row _germanAppBarRow(
    BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
      List<Language>_languages=Language.languageList();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: ScreenUtil().setWidth(20)),
          InkWell(child: Image.asset('assets/images/ArabDealIcon.png',
           width: ScreenUtil().setWidth(50), height: ScreenUtil().setHeight(50))
           ,onTap:(){
              Navigator.of(context)
                      .popUntil((route) => route.isFirst);
           }
           ),
          SizedBox(width: ScreenUtil().setWidth(15)),
          InkWell(
                      child: Text('ArabDeal',
                style: TextStyle(
                    color: Color(0xff0074af),
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(17)))
                    ,onTap:(){
              Navigator.of(context)
                      .popUntil((route) => route.isFirst);
           }
          ),
          InkWell(
                      child: Text('.de',
                style: TextStyle(
                    color: Color(0xff0074af), fontSize: ScreenUtil().setSp(15)))
                    ,onTap:(){
              Navigator.of(context)
                      .popUntil((route) => route.isFirst);
           }
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          DropdownButton(
            items: _languages
                .map<DropdownMenuItem<Language>>((language) => DropdownMenuItem(
                    value: language, child: _germanDropDownRow(language)))
                .toList(),
            underline: SizedBox(),
            onChanged: (Language language) {
              final currentLocale = Localizations.localeOf(context);
              if ((language.languageCode == "ar" &&
                      currentLocale.countryCode == "DE") ||
                  (language.languageCode == "de" &&
                      currentLocale.countryCode == "SY")) {
                changeLocale(context, language);
                print('language');
              }
            },
            value:_languages[0] ,
        //    icon: Icon(Icons.language, size: 25),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(15)),
            child: InkWell(
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                },
                child: Icon(Icons.format_align_right, size: 25)),
          ),
        ],
      )
    ],
  );
}

Row _arabicAppBarRow(
    BuildContext context, GlobalKey<ScaffoldState> scaffoldKey) {
      List<Language>_languages=Language.languageList();
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: ScreenUtil().setWidth(5)),
            InkWell(child: Image.asset('assets/images/ArabDealIcon.png',
           width: ScreenUtil().setWidth(50), height: ScreenUtil().setHeight(50))
           ,onTap:(){
              Navigator.of(context)
                      .popUntil((route) => route.isFirst);
           }),
          SizedBox(width: ScreenUtil().setWidth(15)),
          InkWell(
                      child: Text('de.',
                style: TextStyle(
                    color: Color(0xff0074af), fontSize: ScreenUtil().setSp(15)))
                    ,onTap:(){
              Navigator.of(context)
                      .popUntil((route) => route.isFirst);
           }
          ),
          InkWell(
                      child: Text('ArabDeal',
                style: TextStyle(
                    color: Color(0xff0074af),
                    fontWeight: FontWeight.bold,
                    fontSize: ScreenUtil().setSp(17)))
                    ,onTap:(){
              Navigator.of(context)
                      .popUntil((route) => route.isFirst);
           }
          ),
        ],
      ),
      Row(
        children: [
         
          DropdownButton(
            items: _languages
                .map<DropdownMenuItem<Language>>((language) => DropdownMenuItem(
                    value: language, child: _arabicDropDownRow(language)))
                .toList(),
            underline: SizedBox(),
            onChanged: (language) {
              final currentLocale = Localizations.localeOf(context);

              if ((language.languageCode == "ar" &&
                      currentLocale.countryCode == "DE") ||
                  (language.languageCode == "de" &&
                      currentLocale.countryCode == "SY")) {
                changeLocale(context, language);
                print('language');
              }
            },
            value: _languages[1],
            //icon: Icon(Icons.language, size: 25),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal:ScreenUtil().setWidth(20)),
            child: InkWell(
                onTap: () {
                  scaffoldKey.currentState.openEndDrawer();
                },
                child: Icon(Icons.format_align_left, size: 25)),
          ),
        ],
      )
    ],
  );
}

Row _arabicDropDownRow(Language language) {
  return Row(mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(language.flag, style: TextStyle(fontSize: ScreenUtil().setSp(13))),
     SizedBox(width:  ScreenUtil().setWidth(10)),
      Text(language.name, style: TextStyle(fontSize: ScreenUtil().setSp(13)))
    ],
  );
}

Row _germanDropDownRow(Language language) {
  return Row(mainAxisAlignment: MainAxisAlignment.center,
    children: [
   Text(language.name,style: TextStyle(fontSize: ScreenUtil().setSp(13))),
     SizedBox(width: ScreenUtil().setWidth(10)),
      Text(language.flag, style: TextStyle(fontSize: ScreenUtil().setSp(13))),
    ],
  );
}
