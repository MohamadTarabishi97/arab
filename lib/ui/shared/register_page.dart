import 'dart:io';

import 'package:ArabDealProject/constants.dart';
import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:ArabDealProject/services/data_services/save_user_service.dart';
import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';
import 'package:ArabDealProject/services/http_services/login_http_servic.dart';
import 'package:ArabDealProject/services/http_services/register_http_service.dart';
import 'package:ArabDealProject/services/http_services/save_token_for_notification.dart';
import 'package:ArabDealProject/services/http_services/upload_image_to_server_http_service.dart';
import 'package:ArabDealProject/ui/admin_section/admin_home_page.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/loading.dart';
import 'package:ArabDealProject/ui/user_section/user_home_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  double widthOfScreen;
  double heightOfScreen;
  bool dataLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(debugLabel: "global key for register scaffold");
  final FocusNode emailFocusNode = new FocusNode();
  final FocusNode passwordFocusNode = new FocusNode();
  final FocusNode firstnameFocusNode = new FocusNode();
  final FocusNode lastnameFocusNode = new FocusNode();
  final FocusNode phoneNumberFocusNode = new FocusNode();
  final FocusNode usernameFocusNode = new FocusNode();
  bool recieveEmails = false;
  bool acceptConditions = false;
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  final formKey = GlobalKey<FormState>();
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
    ScreenUtil.init(context,width:widthOfScreen,height:heightOfScreen);
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
              key: formKey,
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
                                color: Colors.red, width: _getRealWidth(30), height: _getRealHeight(60)),
                          ),
                        ),
                        top: _getRealHeight(480),
                        left: _getRealWidth(80)),
                    Container(
                        width: widthOfScreen,
                        // height: heightOfScreen + 432,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                width: widthOfScreen,
                                height: _getRealHeight(150),
                                child: Padding(
                                  padding:  EdgeInsets.only(top: (heightOfScreen*60.0)/640,bottom:(heightOfScreen*40.0)/640),
                                  child: Stack(
                                    children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal:15.0,vertical:12),
                                              child: InkWell(
                                                  child: Icon(Icons.arrow_back,color:Colors.white),
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  }),
                                            ),
                                          ],
                                        ),
                                      Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              ArabDealLocalization.of(context)
                                                  .getTranslatedWordByKey(
                                                      key: "register_page_register"),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'ElMessiri-Bold',
                                                  fontSize:ScreenUtil().setSp(33),
                                                  fontWeight: FontWeight.bold)),
                                                  SizedBox(width:(20*widthOfScreen)/360),
                                                  SvgPicture.asset('assets/images/add.svg',width:40,height:40,color:Colors.white)
                                        ],
                                      ),
                                      
                                    ],
                                  ),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: _getRealWidth(300),
                                    height: _getRealHeight(80),
                                    child: TextFormField(
                                      onSaved: (firstName) {
                                        user.firstName = firstName;
                                      },
                                      validator: (firstName) {
                                        return (firstName.isEmpty)
                                            ? ArabDealLocalization.of(context)
                                                .getTranslatedWordByKey(
                                                    key:
                                                        'all_pages_field_cant_be_empty')
                                            : null;
                                      },
                                      initialValue: user.firstName,
                                      focusNode: firstnameFocusNode,
                                      decoration: _getDecorationOfTextField(
                                        hintText: ArabDealLocalization.of(
                                                context)
                                            .getTranslatedWordByKey(
                                                key: "register_page_firstname"),
                                        focusNode: firstnameFocusNode,
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: _getRealWidth(300),
                                    height: _getRealHeight(80),
                                    child: TextFormField(
                                      onSaved: (lastName) {
                                        user.lastName = lastName;
                                      },
                                      validator: (lastName) {
                                        return lastName.isEmpty
                                            ? ArabDealLocalization.of(context)
                                                .getTranslatedWordByKey(
                                                    key:
                                                        'all_pages_field_cant_be_empty')
                                            : null;
                                      },
                                      initialValue: user.lastName,
                                      focusNode: lastnameFocusNode,
                                      decoration: _getDecorationOfTextField(
                                        hintText: ArabDealLocalization.of(
                                                context)
                                            .getTranslatedWordByKey(
                                                key: "register_page_lastname"),
                                        focusNode: lastnameFocusNode,
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: _getRealWidth(300),
                                    height: _getRealHeight(80),
                                    child: TextFormField(
                                      onSaved: (username) {
                                        user.username = username;
                                      },
                                      validator: (username) {
                                        return username.isEmpty
                                            ? ArabDealLocalization.of(context)
                                                .getTranslatedWordByKey(
                                                    key:
                                                        'all_pages_field_cant_be_empty')
                                            : null;
                                      },
                                      initialValue: user.username,
                                      focusNode: usernameFocusNode,
                                      decoration: _getDecorationOfTextField(
                                        hintText: ArabDealLocalization.of(
                                                context)
                                            .getTranslatedWordByKey(
                                                key: "all_pages_username"),
                                        focusNode: usernameFocusNode,
                                      ),
                                    )),
                              ],
                            ),
                            
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                     width: _getRealWidth(300),
                                    height: _getRealHeight(80),
                                    child: TextFormField(
                                      onSaved: (email) {
                                        user.email = email;
                                      },
                                      validator: (email) {
                                        return email.isEmpty
                                            ? ArabDealLocalization.of(context)
                                                .getTranslatedWordByKey(
                                                    key:
                                                        'all_pages_field_cant_be_empty')
                                            : null;
                                      },
                                      initialValue: user.email,
                                      focusNode: emailFocusNode,
                                      decoration: _getDecorationOfTextField(
                                        hintText:
                                            ArabDealLocalization.of(context)
                                                .getTranslatedWordByKey(
                                                    key: 'register_page_email'),
                                        focusNode: emailFocusNode,
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: _getRealWidth(300),
                                    height: _getRealHeight(80),
                                    child: TextFormField(
                                      onSaved: (password) {
                                        user.password = password;
                                      },
                                      focusNode: passwordFocusNode,
                                      decoration: _getDecorationOfTextField(
                                        hintText: ArabDealLocalization.of(
                                                context)
                                            .getTranslatedWordByKey(
                                                key: "register_page_password"),
                                        focusNode: passwordFocusNode,
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 25),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: _getRealWidth(300),
                                    height: _getRealHeight(80),
                                    child: TextFormField(
                                      onSaved: (phoneNumber) {
                                        user.phoneNumber = phoneNumber;
                                      },
                                      keyboardType: TextInputType.number,
                                      validator: (phoneNumber) {
                                        return phoneNumber.isEmpty
                                            ? ArabDealLocalization.of(context)
                                                .getTranslatedWordByKey(
                                                    key:
                                                        'all_pages_field_cant_be_empty')
                                            : null;
                                      },
                                      focusNode: phoneNumberFocusNode,
                                      initialValue: user.phoneNumber,
                                      decoration: _getDecorationOfTextField(
                                        hintText: ArabDealLocalization.of(
                                                context)
                                            .getTranslatedWordByKey(
                                                key: "register_page_telephone"),
                                        focusNode: phoneNumberFocusNode,
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: RaisedButton.icon(
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () async {
                                      await loadAssets();
                                      user.imageUrl =
                                          await UploadImageToServerHttpService
                                              .uploadImage(images[0]);
                                      print('hello');
                                    },
                                    label: Text('Pick file',
                                        style: TextStyle(color: Colors.white,fontSize:ScreenUtil().setSp(13))),
                                    icon:
                                        Icon(Icons.filter, color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                  ),
                                ),
                                Container(
                                    width: _getRealWidth(100),
                                    height: _getRealHeight(100),
                                    margin:
                                        EdgeInsets.symmetric(horizontal:  _getRealWidth(20)),
                                    color: Colors.white,
                                    child: (images.isEmpty)
                                        ? Center(child: Text('No file',style:TextStyle(fontSize:ScreenUtil().setSp(12))))
                                        : AssetThumb(
                                            asset: images[0],
                                            width: _getRealWidth(100).toInt(),
                                            quality: 100,
                                            height: _getRealHeight(150).toInt(),
                                          ))
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                      maxWidth: widthOfScreen - 65),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: _getRealWidth(10)),
                                        child: Text(
                                          ArabDealLocalization.of(context)
                                              .getTranslatedWordByKey(
                                                  key:
                                                      "register_page_recieve_emails"),
                                          style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(17)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Positioned(
                                        child: Container(
                                            color: Colors.white,
                                            width: 18,
                                            height: 18),
                                        top: 15,
                                        left: 15),
                                    Checkbox(
                                      activeColor:
                                          Theme.of(context).primaryColor,
                                      value: recieveEmails,
                                      onChanged: (value) {
                                        setState(
                                          () {
                                            recieveEmails = value;
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: widthOfScreen),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // SizedBox(width: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Text(
                                      ArabDealLocalization.of(context)
                                          .getTranslatedWordByKey(
                                              key:
                                                  "register_page_accept_usage_conditions"),
                                      style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(17)),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Text(
                                        ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    "register_page_usage_conditions"),
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,fontSize:  ScreenUtil().setSp(17),
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                      //  SizedBox(width:10),
                                      Stack(
                                        children: [
                                          Positioned(
                                              child: Container(
                                                  color: Colors.white,
                                                  width: 18,
                                                  height: 18),
                                              top: 15,
                                              left: 15),
                                          Checkbox(
                                            activeColor:
                                                Theme.of(context).primaryColor,
                                            value: acceptConditions,
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  acceptConditions = value;
                                                },
                                              );
                                            },
                                            checkColor: Colors.white,
                                            hoverColor: Colors.white,
                                            focusColor: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      right: 8.0, left: 8.0),
                                  child: GradientButton(
                                    callback: () async {
                                      if (formKey.currentState.validate()) {
                                        user.termsOfUse =
                                            (acceptConditions) ? 1 : 0;
                                        user.wantEmail =
                                            (recieveEmails) ? 1 : 0;

                                        formKey.currentState
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
                                          //there is an internet connection
                                          // there is an internet connection
                                          String responseBody =
                                              await RegisterHttpService
                                                  .register(user);

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
                                                   SharedPreferences sharedPreferences=SharedPreferencesInstance.getSharedPreferences;
                                                  bool getNotifications=sharedPreferences.getBool('getNotifications');

                                                  if(getNotifications!=null&&getNotifications){
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
                                                   SharedPreferences sharedPreferences=SharedPreferencesInstance.getSharedPreferences;
                                                  bool getNotifications=sharedPreferences.getBool('getNotifications');

                                                  if(getNotifications!=null&&getNotifications){
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
                                                Navigator.of(context)
                                                      .popUntil((route) => route
                                                          .isFirst); 
                                                }
                                              }
                                              //here we checked the role whether user or admin and then make a desicion where to go from here
                                            }
                                          }
                                        }
                                      }
                                    },
                                    increaseHeightBy: _getRealHeight(26),
                                    increaseWidthBy: _getRealWidth(80),
                                    child: Text(
                                        ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key: "register_page_register"),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: ScreenUtil().setSp(17))),
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
                          ],
                        )),
                  ],
                ),
              ),
            ),
    );
  }

  double _getRealHeight(double value){
  return (value*heightOfScreen)/640;
  }
  double _getRealWidth(double value){
   return (value*widthOfScreen)/360;
  }

  InputDecoration _getDecorationOfTextField(
      {@required String hintText, FocusNode focusNode}) {
    return InputDecoration(
        hintText: hintText,
        
        fillColor: Colors.white,
        hintStyle: TextStyle(
            color: focusNode.hasFocus ? Color(0xffde1515) : Colors.grey[400],fontSize:ScreenUtil().setSp(16)),
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

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      print('logged in');
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }
}
