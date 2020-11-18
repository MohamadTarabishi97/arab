import 'dart:math';

import 'package:ArabDealProject/constants.dart';
import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/main.dart';
import 'package:ArabDealProject/objects/code.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:ArabDealProject/services/data_services/save_user_service.dart';
import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';
import 'package:ArabDealProject/services/http_services/check_code_to_reset_password_http_service.dart';
import 'package:ArabDealProject/services/http_services/login_http_servic.dart';
import 'package:ArabDealProject/services/http_services/reset_password_http_service.dart';
import 'package:ArabDealProject/services/http_services/save_token_for_notification.dart';
import 'package:ArabDealProject/ui/admin_section/admin_home_page.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/loading.dart';
import 'package:ArabDealProject/ui/shared/register_page.dart';
import 'package:ArabDealProject/ui/user_section/user_home_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  double widthOfScreen;
  double heightOfScreen;
  bool dataLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(
      debugLabel: "global key for login page scaffold");
  final FocusNode emailFocusNode = new FocusNode();
  final FocusNode passwordFocusNode = new FocusNode();
  final fromKey = GlobalKey<FormState>();
  User user;
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(minutes: 10));
    user = User();
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    ScreenUtil.init(context, width: widthOfScreen, height: heightOfScreen);
    return Scaffold(
      backgroundColor: Colors.black,
      endDrawer: DrawerWrapper(context),
      key: _scaffoldKey,
      body: dataLoading
          ? Container(
              child: Center(child: Loading()),
              color: Colors.white,
            )
          : Form(
              key: fromKey,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Positioned(
                        child: Container(
                          child: AnimatedBuilder(
                            animation: animationController,
                            builder: (context, child) {
                              return Transform.rotate(
                                angle: animationController.value * 2 * 180,
                                child: child,
                              );
                            },
                            child: SvgPicture.asset('assets/images/square.svg',
                                color: Colors.red,
                                width: (widthOfScreen * 30) / 360,
                                height: (heightOfScreen * 60) / 640),
                          ),
                        ),
                        top: (heightOfScreen * 480) / 640,
                        left: (widthOfScreen * 80) / 360),
                    Container(
                        width: widthOfScreen,
                        height: heightOfScreen + 40,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: widthOfScreen,
                                  height: (heightOfScreen * 130) / 640,
                                  child: Center(
                                    child: Stack(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 12),
                                              child: InkWell(
                                                  child: Icon(Icons.arrow_back,
                                                      color: Colors.white),
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  }),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                                ArabDealLocalization.of(context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'login_page_login'),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily:
                                                        'ElMessiri-Bold',
                                                    fontSize:
                                                        ScreenUtil().setSp(33),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(width: 10),
                                            SvgPicture.asset(
                                                'assets/images/enter.svg',
                                                width: 30,
                                                height: 30,
                                                color: Colors.white)
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                        ),
                                      ],
                                    ),
                                  )),
                              SizedBox(height: (heightOfScreen * 5.0) / 640),
                              Padding(
                                padding: EdgeInsets.only(
                                    right: (widthOfScreen * 30.0) / 360,
                                    left: (widthOfScreen * 20.0) / 360),
                                child: Text('Welcome to ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(37),
                                        fontFamily: 'SecularOne-Regular',
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: (widthOfScreen * 30.0) / 360,
                                        left: (widthOfScreen * 30.0) / 360),
                                    child: Text('ArabDeal',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'SecularOne-Regular',
                                            fontSize: ScreenUtil().setSp(37),
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              SizedBox(height: (heightOfScreen * 20.0) / 360),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: (widthOfScreen * 300) / 360,
                                      height: (60 * heightOfScreen) / 640,
                                      child: TextFormField(
                                        onSaved: (email) {
                                          user.email = email;
                                        },
                                        initialValue: user.email,
                                        decoration: _getDecorationOfTextField(
                                            hintText:
                                                ArabDealLocalization.of(context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'login_page_email'),
                                            focusNode: emailFocusNode),
                                      )),
                                ],
                              ),
                              SizedBox(height: (heightOfScreen * 25.0) / 640),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      width: (widthOfScreen * 300) / 360,
                                      height: (60 * heightOfScreen) / 640,
                                      child: TextFormField(
                                        onSaved: (password) {
                                          user.password = password;
                                        },
                                        initialValue: user.password,
                                        decoration: _getDecorationOfTextField(
                                            hintText: ArabDealLocalization.of(
                                                    context)
                                                .getTranslatedWordByKey(
                                                    key: 'login_page_password'),
                                            focusNode: passwordFocusNode),
                                      )),
                                ],
                              ),
                              Container(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          _showcheckCodeToResetPasswordDialog(
                                              context);
                                        },
                                        child: Text(
                                            ArabDealLocalization.of(context)
                                                .getTranslatedWordByKey(
                                                    key:
                                                        'login_page_did_you_forget_your_password'),
                                            style: TextStyle(
                                              color: Colors.white,
                                              decoration:
                                                  TextDecoration.underline,
                                            )),
                                      ),
                                    ],
                                  )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: (widthOfScreen * 8.0) / 360,
                                        left: (widthOfScreen * 25.0) / 360),
                                    child: GradientButton(
                                      callback: () async {
                                        fromKey.currentState
                                            .save(); //getting the data from fields and same them in user object
                                        setState(() {
                                          dataLoading = true; //showing dialog
                                        });
                                        bool resultOfCheckingTheConnection =
                                            await checkInternetConnectivity(); // checking the internet connection
                                        if (!resultOfCheckingTheConnection) {
                                          //so there is no internet connection
                                          setState(() {
                                            dataLoading = false;
                                          });
                                          AwesomeDialog(
                                                  context: context,
                                                  dialogType: DialogType.ERROR,
                                                  animType: AnimType.RIGHSLIDE,
                                                  headerAnimationLoop: false,
                                                  btnOkOnPress: () {
                                                    // Navigator.of(context).pop();
                                                  },
                                                  btnOkColor: Colors.red,
                                                  title: 'Error',
                                                  desc:
                                                      'Check your internet connection',
                                                  isDense: true)
                                              .show();
                                        } else {
                                          // there is an internet connection
                                          String responseBody =
                                              await LoginHttpService.login(
                                                  user);

                                          if (responseBody ==
                                              Constants.invalidCredentials) {
                                            // so invalid Credentials
                                            setState(() {
                                              dataLoading = false;
                                            });
                                            AwesomeDialog(
                                                    btnOkColor: Colors.red,
                                                    context: context,
                                                    dialogType:
                                                        DialogType.ERROR,
                                                    animType:
                                                        AnimType.RIGHSLIDE,
                                                    headerAnimationLoop: false,
                                                    title: 'Error',
                                                    dismissOnBackKeyPress: true,
                                                    desc: 'Invalid credentials',
                                                    isDense: true,
                                                    btnOkOnPress: () {})
                                                .show();
                                          } else if (responseBody ==
                                              Constants.missingCredentials) {
                                            //missing Credentials
                                            setState(() {
                                              dataLoading = false;
                                            });
                                            AwesomeDialog(
                                                    btnOkColor: Colors.red,
                                                    context: context,
                                                    dialogType:
                                                        DialogType.ERROR,
                                                    animType:
                                                        AnimType.RIGHSLIDE,
                                                    headerAnimationLoop: false,
                                                    title: 'Error',
                                                    dismissOnBackKeyPress: true,
                                                    desc:
                                                        'Complete your credentials',
                                                    isDense: true,
                                                    btnOkOnPress: () {})
                                                .show();
                                          } else if (responseBody ==
                                              Constants.somethingWentWrong) {
                                            // so something went wrong
                                            setState(() {
                                              dataLoading = false;
                                            });
                                            AwesomeDialog(
                                                    btnOkColor: Colors.red,
                                                    context: context,
                                                    dialogType:
                                                        DialogType.ERROR,
                                                    animType:
                                                        AnimType.RIGHSLIDE,
                                                    headerAnimationLoop: false,
                                                    title: 'Error',
                                                    dismissOnBackKeyPress: true,
                                                    desc:
                                                        'something went wrong',
                                                    isDense: true,
                                                    btnOkOnPress: () {})
                                                .show();
                                          } else {
                                            //everything is okey
                                            bool resultOfStoring =
                                                await SaveUserDataService
                                                    .saveUser(responseBody);

                                            if (resultOfStoring) {
                                              User user = FetchUserDataService
                                                  .fetchUser();
                                              if (user != null) {
                                                String userType = user.userType;
                                                if (userType == "0") {
                                                  // that's means it'a an admin

                                                  SharedPreferences
                                                      sharedPreferences =
                                                      SharedPreferencesInstance
                                                          .getSharedPreferences;
                                                  bool getNotifications =
                                                      sharedPreferences.getBool(
                                                          'getNotifications');

                                                  if (getNotifications !=
                                                          null &&
                                                      getNotifications) {
                                                    print('token sent');
                                                    final FirebaseMessaging
                                                        _firebaseMessaging =
                                                        FirebaseMessaging();
                                                    String deviceToken =
                                                        await _firebaseMessaging
                                                            .getToken();
                                                    await SaveTokenForNotificationHttpService
                                                        .saveTokenForNotification(
                                                            token: deviceToken,
                                                            userId: user.id);
                                                  }

                                                  App.refrechAction(context);
                                                  Navigator.of(context)
                                                      .popUntil((route) => route
                                                          .isFirst); //to pop until the home page
                                                  // and then we go to control panel
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (_) {
                                                    return AdminHomePage();
                                                  }));
                                                } else {
                                                  // that's means it's a user
                                                  SharedPreferences
                                                      sharedPreferences =
                                                      SharedPreferencesInstance
                                                          .getSharedPreferences;
                                                  bool getNotifications =
                                                      sharedPreferences.getBool(
                                                          'getNotifications');

                                                  if (getNotifications !=
                                                          null &&
                                                      getNotifications) {
                                                    final FirebaseMessaging
                                                        _firebaseMessaging =
                                                        FirebaseMessaging();
                                                    String deviceToken =
                                                        await _firebaseMessaging
                                                            .getToken();
                                                    await SaveTokenForNotificationHttpService
                                                        .saveTokenForNotification(
                                                            token: deviceToken,
                                                            userId: user.id);
                                                  }
                                                  App.refrechAction(context);
                                                  Navigator.of(context)
                                                      .popUntil((route) =>
                                                          route.isFirst);
                                                }
                                              }
                                            }
                                          }
                                        }
                                      },
                                      increaseHeightBy:
                                          (heightOfScreen * 26) / 640,
                                      increaseWidthBy:
                                          (widthOfScreen * 80) / 360,
                                      child: Text(
                                          ArabDealLocalization.of(context)
                                              .getTranslatedWordByKey(
                                                  key: 'login_page_login'),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  ScreenUtil().setSp(17))),
                                      gradient: LinearGradient(
                                        colors: [Colors.red, Colors.yellow],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: (heightOfScreen * 25.0) / 640),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: (widthOfScreen * 25.0) / 360),
                                    child: Text(
                                        ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'login_page_dont_have_an_account'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(13))),
                                  ),
                                  SizedBox(width: (widthOfScreen * 10.0) / 360),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: (widthOfScreen * 10.0) / 360,
                                    ),
                                    child: GradientButton(
                                      callback: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegisterPage()));
                                      },
                                      increaseHeightBy:
                                          (heightOfScreen * 26) / 640,
                                      increaseWidthBy:
                                          (widthOfScreen * 60) / 360,
                                      child: Text(
                                          ArabDealLocalization.of(context)
                                              .getTranslatedWordByKey(
                                                  key: 'login_page_register'),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  ScreenUtil().setSp(17))),
                                      gradient: LinearGradient(
                                        colors: [Colors.red, Colors.yellow],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
    );
  }

  InputDecoration _getDecorationOfTextField(
      {@required String hintText, FocusNode focusNode}) {
    return InputDecoration(
        hintText: hintText,
        fillColor: Colors.white,
        hintStyle: TextStyle(
            color: focusNode.hasFocus ? Color(0xffde1515) : Colors.grey[400],
            fontSize: ScreenUtil().setSp(17)),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xffde1515)),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ));
  }

  String getRandomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Future<void> _showcheckCodeToResetPasswordDialog(BuildContext context) {
    FocusNode focusNode = FocusNode();
    final formKey = GlobalKey<FormState>();
    bool somethingWentWrong=false;
    Code code = Code();
    return showDialog(
        context: context,
        
        builder: (context){
          return StatefulBuilder(builder: (context,setState) {
          return Form(
            key: formKey,
            child: AlertDialog(
              actions: [
                IconButton(onPressed: (){
                  Navigator.pop(context);
                }, icon: Icon(Icons.arrow_back),)
              ],
              title: Row(
                children: [
                  Text(
                      ArabDealLocalization.of(context).getTranslatedWordByKey(
                          key: 'login_dialog_reset_password'),
                      style: TextStyle(fontSize: ScreenUtil().setSp(16))),
                  SizedBox(width: 10),
                  Icon(Icons.lock)
                ],
              ),
              content: Container(
                width: 200,
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      somethingWentWrong?Text( ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'all_pages_something_went_wrong'),style:TextStyle(color:Colors.red)):SizedBox.shrink(),
                      SizedBox(height: 30),
                      Container(
                        width: 250,
                        height: 60,
                        child: TextFormField(
                            focusNode: focusNode,
                            onSaved: (String enteredEmail) {
                              code.email = enteredEmail;
                            },
                            validator: (String text) {
                              if (text.isEmpty)
                                return ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'all_pages_field_cant_be_empty');
                              else
                                return null;
                            },
                            decoration: _getDecorationOfTextField(
                                hintText: ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key:
                                            'reset_password_dialog_enter_your_email'),
                                focusNode: focusNode)),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: 150,
                        height: 60,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              bool checkingTheInternetConnectivity =
                                  await checkInternetConnectivity();
                              if (checkingTheInternetConnectivity) {
                                formKey.currentState.save();
                                code.code = getRandomString(5);
                                bool checkCodeResult =
                                    await CheckCodeToResetPasswordHttpService
                                        .checkCode(code);
                                if (checkCodeResult) {
                                  Navigator.of(context).pop();
                            _showResetPasswordDialog(context, code);
                                } else {
                                  setState((){
                                    somethingWentWrong=true;
                                  });
                                }
                              } else {
                                AwesomeDialog(
                                        btnOkColor: Colors.red,
                                        context: context,
                                        dialogType: DialogType.ERROR,
                                        animType: AnimType.RIGHSLIDE,
                                        headerAnimationLoop: false,
                                        title: ArabDealLocalization.of(context)
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
                            }
                          },
                          child: Text('Ok',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          color: Color(0xffde1515),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
        }
        );
  }

  Future<void> _showResetPasswordDialog(BuildContext context, Code code) {
    FocusNode codeNode = FocusNode();
    FocusNode newPasswordNode = FocusNode();
    FocusNode confirmNewPasswordNode = FocusNode();
    final formKey = GlobalKey<FormState>();
    bool showInitialText=true;
    bool theCodeIsNotCorrect=false;
    bool passwordsMostMatched=false;
    String codeText, newPassword, confirmNewPassword;
    User userToResetPassword = User();
    userToResetPassword.email = code.email;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context,setState){
            return Form(
            key: formKey,
            child: AlertDialog(
              title: Row(
                children: [
                  Text(
                      ArabDealLocalization.of(context).getTranslatedWordByKey(
                          key: 'login_dialog_reset_password'),
                      style: TextStyle(fontSize: ScreenUtil().setSp(16))),
                  SizedBox(width: 10),
                  Icon(Icons.lock)
                ],
              ),
              content: Container(
                width: 200,
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      showInitialText?ConstrainedBox(
                        child: Text(
                           ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'login_dialog_we_sent_the_code_to_your_account')
                           ,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[600])),
                        constraints: BoxConstraints(maxWidth: 190),
                      ):SizedBox.shrink(),
                      theCodeIsNotCorrect?ConstrainedBox(
                        child: Text(
                             ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'login_dialog_the_code_was_not_correct'),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.red)),
                        constraints: BoxConstraints(maxWidth: 190),
                      ):SizedBox.shrink(),
                      passwordsMostMatched?ConstrainedBox(
                        child: Text(
                             ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'login_dialog_the_passwords_most_matched'),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.red)),
                        constraints: BoxConstraints(maxWidth: 190),
                      ):SizedBox.shrink(),
                      SizedBox(height: 30),
                      Container(
                        width: 250,
                        height: 60,
                        child: TextFormField(
                            focusNode: codeNode,
                            onSaved: (String enteredCode) {
                              codeText = enteredCode;
                            },
                            validator: (String text) {
                              if (text.isEmpty)
                                return ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'all_pages_field_cant_be_empty');
                              else
                                return null;
                            },
                            decoration: _getDecorationOfTextField(
                                hintText: ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key:
                                            'login_dialog_enter_the_code_you_recieved'),
                                focusNode: codeNode)),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: 250,
                        height: 60,
                        child: TextFormField(
                            focusNode: newPasswordNode,
                            onSaved: (String enteredNewPassword) {
                              newPassword = enteredNewPassword;
                            },
                            validator: (String text) {
                              if (text.isEmpty)
                                return ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'all_pages_field_cant_be_empty');
                              else
                                return null;
                            },
                            decoration: _getDecorationOfTextField(
                                hintText: ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'login_dialog_new_password'),
                                focusNode: newPasswordNode)),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: 250,
                        height: 60,
                        child: TextFormField(
                            focusNode: confirmNewPasswordNode,
                            onSaved: (String enteredConfirmNewPassword) {
                              confirmNewPassword = enteredConfirmNewPassword;
                            },
                            validator: (String text) {
                              if (text.isEmpty)
                                return ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key: 'all_pages_field_cant_be_empty');
                              else
                                return null;
                            },
                            decoration: _getDecorationOfTextField(
                                hintText: ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key:
                                            'login_dialog_confirm_new_password'),
                                focusNode: confirmNewPasswordNode)),
                      ),
                      SizedBox(height: 30),
                      Container(
                        width: 150,
                        height: 60,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              bool checkingTheInternetConnectivity =
                                  await checkInternetConnectivity();
                              if (checkingTheInternetConnectivity) {
                                if (codeText == code.code) {
                                    setState((){
                                    theCodeIsNotCorrect=false;
                                  });
                                  if (newPassword == confirmNewPassword) {
                                      setState((){
                                    passwordsMostMatched=false;
                                  });
                                    userToResetPassword.password = newPassword;
                                    bool resetPasswordResult =
                                        await ResetPasswordHttpService
                                            .resetPassword(userToResetPassword);
                                    if (resetPasswordResult) {
                                      print('the password has been changed');
                                      
                                      AwesomeDialog(
                                        btnOkColor: Colors.green,
                                        context: context,
                                        dialogType: DialogType.SUCCES,
                                        animType: AnimType.RIGHSLIDE,
                                        headerAnimationLoop: false,
                                        title: ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key: 'all_pages_success'),
                                        dismissOnBackKeyPress: true,
                                        desc: ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key: 'all_pages_the_password_was_changed_successfully'),
                                        isDense: true,
                                        btnOkOnPress: () {
                                          Navigator.of(context).pop();
                                        })
                                    .show();
                                      //show a snackbar and tell the user the password has changed
                                    } else {
                                       
                                        AwesomeDialog(
                                        btnOkColor: Colors.red,
                                        context: context,
                                        dialogType: DialogType.ERROR,
                                        animType: AnimType.RIGHSLIDE,
                                        headerAnimationLoop: false,
                                        title: ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key: 'all_pages_error'),
                                        dismissOnBackKeyPress: true,
                                        desc: ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'all_pages_something_went_wrong'),
                                        isDense: true,
                                        btnOkOnPress: () {})
                                    .show();
                                      print('something went wrong');
                                    }
                                  } else {
                                    print(
                                        'check whether the passwords are matched');
                                          setState((){
                                    showInitialText=false;
                                    passwordsMostMatched=true;
                                  });
                                  }
                                } else {
                                  print('your code is not correct');
                                  setState((){
                                    showInitialText=false;
                                    theCodeIsNotCorrect=true;
                                  });
                                  
                                }
                              } else {
                                AwesomeDialog(
                                        btnOkColor: Colors.red,
                                        context: context,
                                        dialogType: DialogType.ERROR,
                                        animType: AnimType.RIGHSLIDE,
                                        headerAnimationLoop: false,
                                        title: ArabDealLocalization.of(context)
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
                            }
                          },
                          child: Text('Ok',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18)),
                          color: Color(0xffde1515),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
          });
        }
        );
  }
}
