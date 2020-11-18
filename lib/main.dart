import 'dart:async';

import 'package:ArabDealProject/notifications/notification_widget.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';
import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/services/floating_action_button_wrapper.dart';
import 'package:ArabDealProject/services/http_services/save_token_for_notification.dart';
//import 'package:ArabDealProject/ui/user_section/animation_test.dart';
import 'package:ArabDealProject/ui/user_section/user_home_page.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:catcher/catcher.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:permission_handler/permission_handler.dart' as PermissionHander;
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

Function _setAppStateForSplash;
void main() async {
  //WidgetsFlutterBinding.ensureInitialized();
  ErrorWidget.builder = (FlutterErrorDetails details) => Scaffold(
      body: Container(child: Center(child: Text(details.exceptionAsString()))));

  runApp(App());
  //runApp(DevicePreview(builder: (context) => App(),));
}

class App extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _AppState state = context.findAncestorStateOfType<_AppState>();
    state.setLocale(locale);
  }

  static void refrechAction(BuildContext context) {
    _AppState state = context.findAncestorStateOfType<_AppState>();
    state.refresh();
  }

  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  Locale _locale;
  bool splashIsLoaded = false;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void refresh() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('really build called');

    return MaterialApp(
      //   builder: DevicePreview.appBuilder,
      // builder: (context, widget) =>ResponsiveWrapper.builder(
      //   widget,
      //     maxWidth: 1200,
      //     minWidth: 480,
      //     defaultScale: true,
      //     breakpoints: [
      //        ResponsiveBreakpoint.resize(480, name: MOBILE),
      //   ResponsiveBreakpoint.autoScale(800, name: TABLET),
      //   ResponsiveBreakpoint.resize(1000, name: DESKTOP),
      //   ResponsiveBreakpoint.autoScale(2460, name: '4K'),
      //     ],
      //     background: Container(color: Color(0xFFF5F5F5))
      //     ),
      //     initialRoute: '/',
      theme: ThemeData(
          primaryColor: Color(0xffde1515), accentColor: Color(0xffde1515)),
      home: HomePageWrapper(),
      navigatorKey: Catcher.navigatorKey,
      locale: _locale,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        ArabDealLocalization.delegate
      ],
      supportedLocales: [Locale('ar', 'SY'), Locale('de', 'DE')],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode &&
              locale.countryCode == deviceLocale.countryCode) return locale;
        }
        return supportedLocales.last;
      },
    );
  }

  // void _initializeFirebaseMessaging() {
  //   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("onMessage: $message");
  //     },
  //     //  onBackgroundMessage: myBackgroundMessageHandler,
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //       // _navigateToItemDetail(message);
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //       // _navigateToItemDetail(message);
  //     },
  //   );
  //   _firebaseMessaging.requestNotificationPermissions(
  //     const IosNotificationSettings(
  //         sound: true, badge: true, alert: true, provisional: false),
  //   );
  // }
}

class HomePageWrapper extends StatefulWidget {
  _HomePageWrapperState createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper> {
  bool splashShowed;
  bool appLaunchedFirstTime;
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    splashShowed = false;
    _setAppStateForSplash = _splashShowed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!splashShowed) {
      SharedPreferencesInstance.createInstance().then((value) {
        sharedPreferences = SharedPreferencesInstance.getSharedPreferences;
        Timer(Duration(seconds: 2), () {
          _splashShowed();
        });
      });

      return MySplash();
    } else {
      if (sharedPreferences.getBool('appFirstTimeLaunched') != null) {
        return ChangeNotifierProvider(
            child: HomePage(),
            create: (context) => FloatingAcitonButtonWrapper());
      } else
        return FirstSplash();
    }
  }

  void _splashShowed() {
    setState(() {
      splashShowed = true;
    });
  }
}

class MySplash extends StatelessWidget {
  const MySplash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //  SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);

    return Scaffold(
      backgroundColor: Color(0xffffecff),
      body: Center(child: Builder(builder: (context) {
        double widthOfScreen = MediaQuery.of(context).size.width;
        double heightOfScreen = MediaQuery.of(context).size.height;
        ScreenUtil.init(context, width: widthOfScreen, height: heightOfScreen);
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: Image.asset('assets/images/ArabDealIcon.png'),
                  width: 280,
                  height: 260),
              SizedBox(height: 10),
              Text(
                  '.أهلا بكم بعرب ديل أفضل تطبيق تسوّق إلكتروني \n \n Willkommen bei Arab Deal, der besten Online-Shopping-App.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(15),
                      color: Colors.grey[700],
                      fontFamily: 'ElMessiri-Bold')),
              SizedBox(height: 50),
              Container(
                  width: 35, height: 35, child: CircularProgressIndicator()),
              SizedBox(height: 10),
              Text('Loading...'),
            ],
          ),
        );
      })),
      // child: child,
    );
  }
}

class FirstSplash extends StatefulWidget {
  @override
  _FirstSplashState createState() => _FirstSplashState();
}

class _FirstSplashState extends State<FirstSplash> {
  BuildContext contextInstance;
  double widthOfScreen;
  SharedPreferences sharedPreferences;
  @override
  void initState() {
    Timer(Duration(milliseconds: 50), () {
      _showNotificationPermissionDialog(contextInstance);
    });
    super.initState();
  }

  void _checkPermissions() async {
    await PermissionHander.Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    //  SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    // ]);
    sharedPreferences = SharedPreferencesInstance.getSharedPreferences;
    widthOfScreen = MediaQuery.of(context).size.width;
    contextInstance = context;
    return Scaffold(
      backgroundColor: Color(0xffffecff),
      body: Center(child: Builder(builder: (context) {
        double widthOfScreen = MediaQuery.of(context).size.width;
        double heightOfScreen = MediaQuery.of(context).size.height;
        ScreenUtil.init(context, width: widthOfScreen, height: heightOfScreen);
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  child: Image.asset('assets/images/ArabDealIcon.png'),
                  width: 280,
                  height: 260),
              SizedBox(height: 10),
              Text(
                  '.أهلا بكم بعرب ديل أفضل تطبيق تسوّق إلكتروني \n \n Willkommen bei Arab Deal, der besten Online-Shopping-App.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(15),
                      color: Colors.grey[700],
                      fontFamily: 'ElMessiri-Bold')),
              SizedBox(height: 60),
              FlatButton(
                  onPressed: () async {
                    if (sharedPreferences.getBool('getNotifications')) {
                      bool checkingTheInternetConnectivity =
                          await checkInternetConnectivity();
                      if (checkingTheInternetConnectivity) {
                        final FirebaseMessaging _firebaseMessaging =
                            FirebaseMessaging();
                        String deviceToken =
                            await _firebaseMessaging.getToken();
                        print(deviceToken);
                        await SaveTokenForNotificationHttpService
                            .saveTokenForNotification(
                                token: deviceToken, userId: 0);
                        sharedPreferences.setBool(
                            'appFirstTimeLaunched', false);
                        _setAppStateForSplash();
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
                    } else {
                      sharedPreferences.setBool('appFirstTimeLaunched', false);
                      _setAppStateForSplash();
                    }
                  },
                  child: Text(
                      ArabDealLocalization.of(context).getTranslatedWordByKey(
                          key: 'splash_page_click_to_start'),
                      style: TextStyle(color: Colors.white)),
                  color: Theme.of(context).primaryColor)
            ],
          ),
        );
      })),
      // child: child,
    );
  }

  _showNotificationPermissionDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
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
                    height: 150,
                    width: double.infinity,
                    color: Colors.white,
                    child: Column(children: [
                      SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 10),
                          Icon(Icons.notifications,
                              color: Color(0xff008f80), size: 35),
                          SizedBox(width: 7),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: widthOfScreen - 90,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Allow ArabDeal.de to send you notifications?',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
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
                              sharedPreferences.setBool(
                                  'getNotifications', false);
                              Navigator.of(context).pop();
                              _showSharePermissionDialog(context);
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
                              sharedPreferences.setBool(
                                  'getNotifications', true);

                              Navigator.of(context).pop();
                              _showSharePermissionDialog(context);
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

  _showSharePermissionDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
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
                          Icon(Icons.share, color: Color(0xff008f80), size: 30),
                          SizedBox(width: 15),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: widthOfScreen - 90,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Allow ArabDeal.de to use share option?',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
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
                              sharedPreferences.setBool('shareOption', false);
                              Navigator.of(context).pop();
                              _showOpenBorwserPermissionDialog(context);
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
                            onTap: () {
                              sharedPreferences.setBool('shareOption', true);
                              Navigator.of(context).pop();
                              _showOpenBorwserPermissionDialog(context);
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

  _showOpenBorwserPermissionDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
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
                            constraints: BoxConstraints(
                              maxWidth: widthOfScreen - 90,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Allow ArabDeal.de to open your browser?',
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
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
                              _checkPermissions();
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
                            onTap: () {
                              sharedPreferences.setBool('openBrowser', true);
                              Navigator.of(context).pop();
                              _checkPermissions();
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
}
