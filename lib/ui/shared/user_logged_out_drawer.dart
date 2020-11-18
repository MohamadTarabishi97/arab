import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';
import 'package:ArabDealProject/services/http_services/contact_us_http_service.dart';
import 'package:ArabDealProject/services/lunch_rul.dart';
import 'package:ArabDealProject/services/move_to_the_top_home_page.dart';
import 'package:ArabDealProject/shared_contexts.dart';
import 'package:ArabDealProject/ui/shared/dialogs/privacy_dialog.dart';
import 'package:ArabDealProject/ui/shared/login_page.dart';
import 'package:ArabDealProject/ui/user_section/user_offers_by_category.dart';
import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
//import 'package:ArabDealProject/ui/user_section/animation_test.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoggedOutDrawer extends StatefulWidget {
  UserLoggedOutDrawer({
    this.currentContetxt,
  });

  final BuildContext currentContetxt;

  _UserLoggedOutDrawerState createState() => _UserLoggedOutDrawerState();
}

class _UserLoggedOutDrawerState extends State<UserLoggedOutDrawer> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _messageFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  String name, email, message;
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    sharedPreferences = SharedPreferencesInstance.getSharedPreferences;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: "Hello",
      child: Form(
        key: formKey,
        child: Container(
          color: Color(0xffffecff),
          child: ListView(
            children: [
              DrawerHeader(
                  child: Container(
                      child:
                          (Localizations.localeOf(context).countryCode == "SY")
                              ? _arabicDrawerHeaderRow()
                              : _germanDrawerHeaderRow())),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  MoveToTheTopHomePage.moveToTheTopHomePageAction();
                  Navigator.of(widget.currentContetxt)
                      .popUntil((route) => route.isFirst);
                  print('hello');
                  //TODO POP UNTIL HOME PAGE
                },
                title: Text(
                  ArabDealLocalization.of(context)
                      .getTranslatedWordByKey(key: 'drawer_page_home'),
                ),
                leading: Icon(Icons.home, color: Colors.grey[700]),
              ),
              
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  MoveToTheTopHomePage.moveToTheTopHomePageAction();
                  Navigator.of(widget.currentContetxt)
                      .popUntil((route) => route.isFirst);
                  Navigator.of(SharedContexts.homeContext).push(
                      MaterialPageRoute(
                          builder: (_) => OffersByCategoryPage()));

                  //TODO POP UNTIL HOME PAGE AND THEN GO TO CATEGORIES PAGE
                },
                title: Text(
                  ArabDealLocalization.of(context)
                      .getTranslatedWordByKey(key: 'drawer_page_categories'),
                ),
                leading: Icon(Icons.list, color: Colors.grey[700]),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pop();
                  MoveToTheTopHomePage.moveToTheTopHomePageAction();
                  Navigator.of(widget.currentContetxt)
                      .popUntil((route) => route.isFirst);
                  Navigator.of(SharedContexts.homeContext)
                      .push(MaterialPageRoute(builder: (_) => LoginPage()));
                  //TODO POP UNTIL HOME PAGE AND THEN GO TO ADMIN HOME PAGE
                },
                title: Text(
                  ArabDealLocalization.of(context).getTranslatedWordByKey(
                      key: 'user_logged_out_drawer_login'),
                ),
                leading: Icon(Icons.arrow_forward, color: Colors.grey[700]),
              ),
              Container(
                  height: 715,
                  margin: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          children: [
                            Text(
                                ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'drawer_page_contact_us'),
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(18),
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 20),
                            SvgPicture.asset('assets/images/support.svg',
                                width: 60, height: 60)
                          ],
                          mainAxisAlignment: MainAxisAlignment.center,
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                          width: 220,
                          height: 60,
                          child: TextFormField(
                            focusNode: _nameFocusNode,
                            onSaved: (nameText) {
                              name = nameText;
                            },
                            validator: (name) {
                              return name.isEmpty
                                  ? ArabDealLocalization.of(context)
                                      .getTranslatedWordByKey(
                                          key: 'all_pages_field_cant_be_empty')
                                  : null;
                            },
                            decoration: _getDecorationOfTextField(
                                hintText: ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'drawer_page_name'),
                                focusNode: _nameFocusNode),
                          )),
                      SizedBox(height: 40),
                      Container(
                          width: 220,
                          height: 60,
                          child: TextFormField(
                            focusNode: _emailFocusNode,
                            onSaved: (emailText) {
                              email = emailText;
                            },
                            validator: (email) {
                              return email.isEmpty
                                  ? ArabDealLocalization.of(context)
                                      .getTranslatedWordByKey(
                                          key: 'all_pages_field_cant_be_empty')
                                  : null;
                            },
                            decoration: _getDecorationOfTextField(
                                hintText: ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'drawer_page_email'),
                                focusNode: _emailFocusNode),
                          )),
                      SizedBox(height: 40),
                      Container(
                          width: 220,
                          height: 120,
                          child: TextFormField(
                            focusNode: _messageFocusNode,
                            onSaved: (messageText) {
                              message = messageText;
                            },
                            validator: (message) {
                              return message.isEmpty
                                  ? ArabDealLocalization.of(context)
                                      .getTranslatedWordByKey(
                                          key: 'all_pages_field_cant_be_empty')
                                  : null;
                            },
                            maxLines: 10,
                            textInputAction: TextInputAction.done,
                            decoration: _getDecorationOfTextField(
                                hintText: ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'drawer_page_message'),
                                focusNode: _messageFocusNode),
                          )),
                      SizedBox(height: 40),
                      Container(
                          width: 150,
                          height: 50,
                          child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              onPressed: () async {
                                bool isConnected =
                                    await checkInternetConnectivity();
                                if (isConnected) {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    bool result =
                                        await ContactUsHttpService.contactUs(
                                            email: email,
                                            message: message,
                                            name: name);
                                    if (result) {
                                      // contacted successfully
                                      AwesomeDialog(
                                              btnOkColor: Colors.green,
                                              context: context,
                                              dialogType: DialogType.SUCCES,
                                              animType: AnimType.RIGHSLIDE,
                                              headerAnimationLoop: false,
                                              title: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key: 'all_pages_success'),
                                              dismissOnBackKeyPress: false,
                                              dismissOnTouchOutside: false,
                                              desc: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'drawer_page_message_sent_successfully'),
                                              isDense: true,
                                              btnOkOnPress: () {})
                                          .show();
                                      print('done bro');
                                    } else {
                                      //something went wrong
                                      AwesomeDialog(
                                              btnOkColor: Colors.red,
                                              context: context,
                                              dialogType: DialogType.ERROR,
                                              animType: AnimType.RIGHSLIDE,
                                              headerAnimationLoop: false,
                                              title: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key: 'all_pages_error'),
                                              dismissOnBackKeyPress: true,
                                              desc: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'all_pages_something_went_wrong'),
                                              isDense: true,
                                              btnOkOnPress: () {})
                                          .show();
                                      print('something went wrong');
                                    }
                                  }
                                } else {
                                  //show not connected
                                  AwesomeDialog(
                                          btnOkColor: Colors.red,
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.RIGHSLIDE,
                                          headerAnimationLoop: false,
                                          title:
                                              ArabDealLocalization.of(context)
                                                  .getTranslatedWordByKey(
                                                      key: 'all_pages_error'),
                                          dismissOnBackKeyPress: true,
                                          desc: ArabDealLocalization.of(context)
                                              .getTranslatedWordByKey(
                                                  key:
                                                      'all_pages_no_internet_connection'),
                                          isDense: true,
                                          btnOkOnPress: () {})
                                      .show();
                                }
                              },
                              color: Color(0xff3c4859),
                              child: Text(
                                  ArabDealLocalization.of(context)
                                      .getTranslatedWordByKey(
                                          key: 'drawer_page_send'),
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(15),
                                      color: Colors.white)))),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          InkWell(
                            child: Text('Impressum',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    color: Color(0xffde1515))),
                            onTap: () async {
                              if (sharedPreferences.getBool('openBrowser')) {
                                bool isConnected =
                                    await checkInternetConnectivity();
                                if (isConnected) {
                                  await LaunchUrl.launchURL(
                                      'https://arabdeals.de/impressum');
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(ArabDealLocalization.of(
                                              context)
                                          .getTranslatedWordByKey(
                                              key:
                                                  'all_pages_no_internet_connection'))));
                                }
                              } else {
                                _showOpenBorwserPermissionDialog(
                                    context, 'https://arabdeals.de/impressum');
                              }
                            },
                          ),
                          SizedBox(width: 10),
                          Text('-',
                              style: TextStyle(
                                  color: Color(0xff3c4859),
                                  fontSize: ScreenUtil().setSp(15))),
                          SizedBox(width: 10),
                          InkWell(
                            child: Text('Datenschutz',
                                style: TextStyle(
                                    fontSize: ScreenUtil().setSp(15),
                                    color: Color(0xffde1515))),
                            onTap: () async {
                              if (sharedPreferences.getBool('openBrowser')) {
                                bool isConnected =
                                    await checkInternetConnectivity();
                                if (isConnected) {
                                  await LaunchUrl.launchURL(
                                      'https://arabdeals.de/terms');
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(ArabDealLocalization.of(
                                              context)
                                          .getTranslatedWordByKey(
                                              key:
                                                  'all_pages_no_internet_connection'))));
                                }
                              } else {
                                _showOpenBorwserPermissionDialog(
                                    context, 'https://arabdeals.de/terms');
                              }
                            },
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text('2020 © All rights reserved by ArabDeal.de',
                              style: TextStyle(
                                  color: Color(0xff3c4859),
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(13)))
                        ],
                        mainAxisAlignment: MainAxisAlignment.center,
                      ),
                      // SizedBox(height: 30),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     InkWell(
                      //       child: Text('Privacy Policy',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.normal,
                      //               fontSize: ScreenUtil().setSp(13))),
                      //       onTap: () {
                      //         showDialog(
                      //             context: context,
                      //             builder: (context) {
                      //               return PrivacyDialog(
                      //                 mdFileName: 'privacy_policy.md',
                      //                 radius: 10,
                      //               );
                      //             });
                      //       },
                      //     ),
                      //     Text(' - ',
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: ScreenUtil().setSp(13))),
                      //     InkWell(
                      //       child: Text('Terms and conditions',
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.normal,
                      //               fontSize: ScreenUtil().setSp(13))),
                      //       onTap: () {
                      //         showDialog(
                      //             context: context,
                      //             builder: (context) {
                      //               return PrivacyDialog(
                      //                 mdFileName: 'terms_and_conditions.md',
                      //                 radius: 10,
                      //               );
                      //             });
                      //       },
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              child: SvgPicture.asset(
                                  'assets/images/facebook.svg',
                                  width: 25,
                                  height: 25),
                              onTap: () async {
                                if (sharedPreferences.getBool('openBrowser')) {
                                  bool isConnected =
                                      await checkInternetConnectivity();
                                  if (isConnected) {
                                    await LaunchUrl.launchURL(
                                        'https://www.facebook.com/ArabDeal.de');
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(ArabDealLocalization.of(
                                                context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'all_pages_no_internet_connection'))));
                                  }
                                } else {
                                  _showOpenBorwserPermissionDialog(context,
                                      'https://www.facebook.com/ArabDeal.de');
                                }
                              },
                            ),
                            SizedBox(width: 15),
                            InkWell(
                              child: SvgPicture.asset('assets/images/world.svg',
                                  width: 25, height: 25),
                              onTap: () async {
                                if (sharedPreferences.getBool('openBrowser')) {
                                  bool isConnected =
                                      await checkInternetConnectivity();
                                  if (isConnected) {
                                    await LaunchUrl.launchURL(
                                        'https://arabdeals.de/');
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text(ArabDealLocalization.of(
                                                context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'all_pages_no_internet_connection'))));
                                  }
                                } else {
                                  _showOpenBorwserPermissionDialog(
                                      context, 'https://arabdeals.de/');
                                }
                              },
                            )
                          ])
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }

  _showOpenBorwserPermissionDialog(BuildContext context, String url) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              insetPadding: EdgeInsets.all(10),
              backgroundColor: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                overflow: Overflow.visible,
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    height: 150,
                    child: Column(children: [
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.open_in_browser,
                              color: Color(0xff008f80), size: 35),
                          SizedBox(width: 15),
                          ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: MediaQuery.of(context).size.width-90,),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Allow ArabDeal.de to open your browser?',
                                    style: TextStyle(fontSize: 19),
                                    textAlign: TextAlign.left),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(children: [
                        InkWell(
                            onTap: () {
                              sharedPreferences.setBool('openBrowser', false);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                                width: 50,
                                height: 30,
                                child: Text('Deny',
                                    style: TextStyle(
                                      color: Color(0xff008f80),
                                      fontSize: 15,
                                    )))),
                        SizedBox(width: 20),
                        InkWell(
                            onTap: () async {
                              sharedPreferences.setBool('openBrowser', true);
                              Navigator.of(context).pop();
                              await LaunchUrl.launchURL(url);
                            },
                            child: Container(
                                width: 50,
                                height: 30,
                                child: Text('Allow',
                                    style: TextStyle(
                                      color: Color(0xff008f80),
                                      fontSize: 15,
                                    )))),
                        SizedBox(width: 20)
                      ], mainAxisAlignment: MainAxisAlignment.end)
                    ]),
                  ),
                ],
              ));
        });
  }

  InputDecoration _getDecorationOfTextField(
      {@required String hintText, FocusNode focusNode}) {
    return InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
            color: focusNode.hasFocus ? Color(0xffde1515) : Colors.grey[700],
            fontSize: ScreenUtil().setSp(17)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[700]),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffde1515)),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ));
  }
}

Row _germanDrawerHeaderRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(width: 20),
      Image.asset('assets/images/ArabDealIcon.png', width: 75, height: 75),
      SizedBox(width: 15),
      Text('ArabDeal',
          style: TextStyle(
              color: Color(0xff0074af),
              fontWeight: FontWeight.bold,
              fontSize: 17)),
      Text('.de', style: TextStyle(color: Color(0xff0074af), fontSize: 15))
    ],
  );
}

Row _arabicDrawerHeaderRow() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SizedBox(width: 20),
      Image.asset('assets/images/ArabDealIcon.png', width: 75, height: 75),
      SizedBox(width: 15),
      Text('de.', style: TextStyle(color: Color(0xff0074af), fontSize: 15)),
      Text('ArabDeal',
          style: TextStyle(
              color: Color(0xff0074af),
              fontWeight: FontWeight.bold,
              fontSize: 17)),
    ],
  );
}
