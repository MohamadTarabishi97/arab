import 'dart:io';

import 'package:ArabDealProject/main.dart';
import 'package:ArabDealProject/services/data_services/clear_user_service.dart';
import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';
import 'package:ArabDealProject/services/floating_action_button_wrapper.dart';
import 'package:ArabDealProject/ui/admin_section/admin_admins_page.dart';
import 'package:ArabDealProject/ui/admin_section/admin_categories_page.dart';
import 'package:ArabDealProject/ui/admin_section/admin_offers_page.dart';
import 'package:ArabDealProject/ui/shared/login_page.dart';
//import 'package:ArabDealProject/ui/user_section/animation_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatelessWidget {
 double widthOfScreen;
  double heightOfScreen;
  
 double _getRealHeight(double value){
  return (value*heightOfScreen)/640;
  }
  double _getRealWidth(double value){
   return (value*widthOfScreen)/360;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    Locale currentLocale = Localizations.localeOf(context);
     widthOfScreen=MediaQuery.of(context).size.width;
     heightOfScreen=MediaQuery.of(context).size.height;
   ScreenUtil.init(context,width:widthOfScreen,height:heightOfScreen);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: (currentLocale.countryCode == "SY")
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  SizedBox(height: (heightOfScreen*40)/640),
                 
                  // SizedBox(
                  //   height: 40,
                  // ),
                  Container(
                    child: Row(
                      mainAxisAlignment: (currentLocale.countryCode == "SY")
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Text('Welcome to ',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: ScreenUtil().setSp(33),
                            )),
                      ],
                    ),
                  ),
                  Container(
                      child: (currentLocale.countryCode == "SY")
                          ? _arabicArabDealRow()
                          : _germanArabDealRow()),
                  Container(
                    child: Row(
                      mainAxisAlignment: (currentLocale.countryCode == "SY")
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        (Localizations.localeOf(context).countryCode == "SY")
                            ? Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text('Panel',
                                    style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontSize: ScreenUtil().setSp(33),
                                    )),
                              )
                            : Text('Panel',
                                style: TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize:ScreenUtil().setSp(33),
                                )),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: (currentLocale.countryCode == "SY")
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GradientButton(
                          callback: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  child: AdminOffersPage(),
                              
                                  create: (context)=>FloatingAcitonButtonWrapper(),
                                  )));
                          },
                          increaseHeightBy: _getRealHeight(26),
                          increaseWidthBy: _getRealWidth(80),
                          child: Text('Offers',
                              style: TextStyle(
                                  color: Colors.black, fontSize: ScreenUtil().setSp(17),fontFamily: 'SecularOne-Regular')),
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.yellow],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: (currentLocale.countryCode == "SY")
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GradientButton(
                          callback: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AdminCategoriesPage()));
                          },
                          increaseHeightBy: _getRealHeight(26),
                          increaseWidthBy: _getRealWidth(80),
                          child: Text('Categories',
                              style: TextStyle(
                                  color: Colors.black, fontSize: ScreenUtil().setSp(17),fontFamily: 'SecularOne-Regular')),
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.yellow],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: (currentLocale.countryCode == "SY")
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: GradientButton(
                          callback: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => AdminAdminsPage()));
                          },
                          increaseHeightBy: _getRealHeight(26),
                          increaseWidthBy: _getRealWidth(80),
                          child: Text('Admins',
                              style: TextStyle(
                                
                                  color: Colors.black, fontSize: ScreenUtil().setSp(17),fontFamily: 'SecularOne-Regular')),
                          gradient: LinearGradient(
                            colors: [Colors.red, Colors.yellow],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Text('2020 © All rights reserved by ArabDeal.de',
                      style: TextStyle(
                        color: Color(0xff3c4859),
                        fontSize: ScreenUtil().setSp(15),
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Row _arabicArabDealRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text('Admin',
            style: TextStyle(
              color: Colors.orangeAccent,
              fontSize: ScreenUtil().setSp(35),
            )),
      ),
      Text('ArabDeal.de ',
          style: TextStyle(
            color: Colors.black,
            fontSize: ScreenUtil().setSp(35),
          )),
    ],
  );
}

Row _germanArabDealRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Text('ArabDeal.de ',
          style: TextStyle(
            color: Colors.black,
            fontSize: ScreenUtil().setSp(35),
          )),
      Text('Admin',
          style: TextStyle(
            color: Colors.orangeAccent,
            fontSize: ScreenUtil().setSp(35),
          )),
    ],
  );
}
