import 'dart:convert';

import 'package:ArabDealProject/constants.dart';
import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/clear_user_service.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:ArabDealProject/services/data_services/save_user_service.dart';
import 'package:ArabDealProject/services/http_services/change_password_http_service.dart';
import 'package:ArabDealProject/services/http_services/edit_profile_http_service.dart';
import 'package:ArabDealProject/services/http_services/login_http_servic.dart';
import 'package:ArabDealProject/services/http_services/register_http_service.dart';
import 'package:ArabDealProject/services/http_services/upload_image_to_server_http_service.dart';
import 'package:ArabDealProject/ui/admin_section/admin_home_page.dart';
import 'package:ArabDealProject/ui/shared/cached__image_from_network.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/loading.dart';
import 'package:ArabDealProject/ui/user_section/user_home_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class EditAccont extends StatefulWidget {
  _EditAccontState createState() => _EditAccontState();
}

class _EditAccontState extends State<EditAccont>
    with SingleTickerProviderStateMixin {
  double widthOfScreen;
  double heightOfScreen;
  bool dataLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(
      debugLabel: "global key for register scaffold");
  final FocusNode emailFocusNode = new FocusNode();
  final FocusNode usernameFocusNode = new FocusNode();
  final FocusNode firstnameFocusNode = new FocusNode();
  final FocusNode lastnameFocusNode = new FocusNode();
  final FocusNode phoneNumberFocusNode = new FocusNode();
  bool recieveEmails;
  bool acceptConditions;
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
    user = FetchUserDataService.fetchUser();
    recieveEmails = (user.wantEmail == 1);
    acceptConditions = (user.termsOfUse == 1);
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
                                color: Colors.red, width: 30, height: 60),
                          ),
                        ),
                        top: 480,
                        left: 80),
                    Container(
                        width: widthOfScreen,
                        // height: heightOfScreen + 432,
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 50.0),
                              child: Text(
                                  ArabDealLocalization.of(context)
                                      .getTranslatedWordByKey(
                                          key:
                                              "edit_account_page_edit_account"),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Ranchers-Regular',
                                      fontSize: ScreenUtil().setSp(33),
                                      fontWeight: FontWeight.bold)),
                            ),
                            InkWell(
                              child: Container(
                                  width: 120,
                                  height: 120,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 30),
                                  color: Colors.white,
                                  child: (images.isEmpty)
                                      ? (user.imageUrl != null)
                                          ? CachedImageFromNetwork(
                                              urlImage: user.imageUrl,
                                            )
                                          : Center(
                                              child: Text('No file',
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(12))))
                                      : AssetThumb(
                                          asset: images[0],
                                          width: 100,
                                          quality: 100,
                                          height: 150,
                                        )),
                              onTap: () async {
                                await loadAssets();
                                user.imageUrl =
                                    await UploadImageToServerHttpService
                                        .uploadImage(images[0]);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    width: 300,
                                    height: 80,
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
                                    width: 300,
                                    height: 80,
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
                                    width: 300,
                                    height: 80,
                                    child: TextFormField(
                                      onSaved: (username) {
                                        user.username = username;
                                      },
                                      validator: (lastName) {
                                        return lastName.isEmpty
                                            ? ArabDealLocalization.of(context)
                                                .getTranslatedWordByKey(
                                                    key:
                                                        'all_pages_field_cant_be_empty')
                                            : null;
                                      },
                                      initialValue: user.username,
                                      focusNode: usernameFocusNode,
                                      decoration: _getDecorationOfTextField(
                                        hintText:
                                            ArabDealLocalization.of(context)
                                                .getTranslatedWordByKey(
                                                    key: "all_pages_username"),
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
                                    width: 300,
                                    height: 80,
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
                                    width: 300,
                                    height: 80,
                                    child: TextFormField(
                                      onSaved: (phoneNumber) {
                                        user.phoneNumber = phoneNumber;
                                      },
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
                            FlatButton.icon(
                              icon: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.white),
                                  SizedBox(width: 5),
                                  Icon(Icons.lock, color: Colors.white)
                                ],
                              ),
                              color: Theme.of(context).primaryColor,
                              label: Text(
                                  ArabDealLocalization.of(context)
                                      .getTranslatedWordByKey(
                                          key: 'register_page_change_password'),
                                  style: TextStyle(color: Colors.white)),
                              onPressed: () {
                                _showChangePasswordDialog(context);
                              },
                            ),
                            SizedBox(height: 30),
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
                                            horizontal: 10),
                                        child: Text(
                                          ArabDealLocalization.of(context)
                                              .getTranslatedWordByKey(
                                                  key:
                                                      "register_page_recieve_emails"),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: ScreenUtil().setSp(17)),
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
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(17)),
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
                                                Theme.of(context).primaryColor,
                                            fontSize: ScreenUtil().setSp(17),
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
                                          setState(() {
                                            dataLoading = false;
                                          });
                                          String userAsResultOfEditing =
                                              await EditProfileHttpService
                                                  .editProfile(user);

                                          if (userAsResultOfEditing != null) {
                                            //everything is okey
                                            bool resultOfClearing =
                                                await ClearUserDataService
                                                    .clearUser();
                                            if (resultOfClearing) {
                                              bool resultOfStoring =
                                                  await SaveUserDataService
                                                      .saveUser(
                                                          userAsResultOfEditing);

                                              if (resultOfStoring) {
                                                User user = FetchUserDataService
                                                    .fetchUser();
                                                if (user != null) {
                                                  String userType =
                                                      user.userType;
                                                  if (userType == "0") {
                                                    // that's means it'a an admin
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
                                                    Navigator.of(context)
                                                        .popUntil((route) =>
                                                            route.isFirst);
                                                  }
                                                }
                                                //here we checked the role whether user or admin and then make a desicion where to go from here
                                              } else {
                                                print('something went wrong');
                                              }
                                            } else {
                                              print('something went wrong');
                                            }
                                          } else {
                                            print('something went wrong nigga');
                                          }
                                        }
                                      }
                                    },
                                    increaseHeightBy: 26,
                                    increaseWidthBy: 80,
                                    child: Text(
                                        ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key: "all_pages_edit"),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: ScreenUtil().setSp(17))),
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

  Future<void> _showChangePasswordDialog(BuildContext context) {
    FocusNode oldPasswordNode = FocusNode();
    FocusNode newPasswordNode = FocusNode();
    final formKey = GlobalKey<FormState>();
    String oldPassword, newPassword;
    bool somethingWentWrong = false;
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Form(
              key: formKey,
              child: AlertDialog(
                actions: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  )
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
                  height: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        somethingWentWrong
                            ? Text( ArabDealLocalization.of(context).getTranslatedWordByKey(
                            key: 'all_pages_something_went_wrong'),
                                style: TextStyle(color: Colors.red))
                            : SizedBox.shrink(),
                        SizedBox(height: 30),
                        Container(
                          width: 250,
                          height: 60,
                          child: TextFormField(
                              focusNode: oldPasswordNode,
                              onSaved: (String enteredOldPassword) {
                                oldPassword = enteredOldPassword;
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
                                          key: 'register_page_old_password'),
                                  focusNode: oldPasswordNode)),
                        ),
                        SizedBox(height: 20),
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
                                          key: 'register_page_new_password'),
                                  focusNode: newPasswordNode)),
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
                                  bool changePasswordResult =
                                      await ChangePasswordHttpService
                                          .changePassword(
                                              oldPassword, newPassword);
                                  if (changePasswordResult) {
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
                                        desc:
                                            ArabDealLocalization.of(context)
                                                    .getTranslatedWordByKey(
                                                        key: 'all_pages_the_password_was_changed_successfully'),
                                        isDense: true,
                                        btnOkOnPress: () {
                                          Navigator.of(context).pop();
                                        }).show();
                                  } else {
                                    print('oh no something went wrong');
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
                                } else {
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
                              }
                            },
                            child: Text('Ok',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
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
        });
  }

  InputDecoration _getDecorationOfTextField(
      {@required String hintText, FocusNode focusNode}) {
    return InputDecoration(
        hintText: hintText,
        fillColor: Colors.white,
        hintStyle: TextStyle(
            color: focusNode.hasFocus ? Color(0xffde1515) : Colors.grey[400],
            fontSize: ScreenUtil().setSp(16)),
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
