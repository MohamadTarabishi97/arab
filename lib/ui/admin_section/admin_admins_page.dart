import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/main.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/http_services/delete_admin_http_service.dart';
import 'package:ArabDealProject/services/http_services/get_admins_http_service.dart';
import 'package:ArabDealProject/ui/admin_section/admin_add_admin.dart';
import 'package:ArabDealProject/ui/shared/cached__image_from_network.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/loading.dart';
import 'package:ArabDealProject/ui/shared/no_internet_connection.dart';
import 'package:ArabDealProject/ui/shared/custom_app_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';

class AdminAdminsPage extends StatefulWidget {
  @override
  _AdminAdminsPageState createState() => _AdminAdminsPageState();
}

class _AdminAdminsPageState extends State<AdminAdminsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool dataLoading = false;
  List<User> admins;
  double widthOfScreen;
  double heightOfScreen;
  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
   ScreenUtil.init(context,width:widthOfScreen,height:heightOfScreen);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AdminAddAdmin()));
            },
            backgroundColor: Color(0xffde1515)),
        key: _scaffoldKey,
        endDrawer: DrawerWrapper(context),
        body: Column(
          children: [
            CustomAppBar(scaffoldKey: _scaffoldKey),
            !dataLoading
                ? FutureBuilder(
                    future: checkInternetConnectivity(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.data) {
                          //connected to network
                          return FutureBuilder(
                            future: GetAdminsHttpRequest.getAdmins(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasData) {
                                  admins = snapshot.data;
                                  return _loadedWidget(
                                    parentContext: context,
                                  );
                                } else {
                                  return Container();
                                  // there are no admins
                                }
                              } else {
                                // wating to get a response from get admins request
                                return _loadingWidget();
                              }
                            },
                          );
                        } else {
                          // no internet connection
                          return _noInternetConnectionWidget();
                        }
                      } else {
                        //waiting to check the internet connection
                        return _loadingWidget();
                      }
                    },
                  )
                : _loadingWidget()
          ],
        ));
  }

  Widget _noInternetConnectionWidget() {
    return Column(
      children: [SizedBox(height: 100), NoInternetConnection()],
    );
  }

  Widget _loadingWidget() {
    return Column(
      children: [SizedBox(height: 200), Loading()],
    );
  }

  Widget _loadedWidget({
    @required BuildContext parentContext,
  }) {
    print(admins[1].imageUrl +
        'i dont want your body fdfdfdsjhfdsfhkdsjflksdjflkdsjflksdjflksdjflksdfjsdlkfjsad;fk');
    return Column(
      children: [
        SizedBox(height: 40),
        Text('All The Admin',
            style: TextStyle(
                color: Color(0xffde1515), fontSize: ScreenUtil().setSp(20))),
        Container(
            margin: EdgeInsets.only(top: 20),
            width: 50,
            height: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 2,
                  width: 10,
                  color: Colors.black,
                ),
                SizedBox(width: 3),
                Container(
                  height: 5,
                  width: 10,
                  color: Color(0xffde1515),
                ),
                SizedBox(width: 3),
                Container(
                  height: 2,
                  width: 10,
                  color: Colors.black,
                ),
              ],
            )),
        SizedBox(height: 30),
        Container(
          width: widthOfScreen,
          height: heightOfScreen - 223,
          child: ListView.separated(
              itemBuilder: (context, index) {
                String adminFullName =
                    admins[index].firstName + ' ' + admins[index].lastName;
                return Card(
                  color: Colors.grey[200],
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: InkWell(
                    splashColor: Colors.red,
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => AdminAddAdmin(
                                passedAdmin: admins[index],
                              )));
                    },
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              children: [
                                (admins[index].imageUrl != null &&
                                        admins[index].imageUrl !=
                                            'admin.imageUrl')
                                    ? Container(
                                        width: 100,
                                        height: 100,
                                        child: CachedImageFromNetwork(
                                          urlImage: admins[index].imageUrl,
                                        ))
                                    : Icon(Icons.person_pin,
                                        size: 100, color: Colors.grey[700]),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  adminFullName,
                                  style: TextStyle(
                                      color: Color(0xffde1515),
                                      fontSize: ScreenUtil().setSp(20)),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: Icon(Icons.delete,
                                      color: Colors.red, size: 30),
                                  onTap: () async {
                                    AwesomeDialog(
                                        btnOkColor: Colors.red,
                                        context: context,
                                        dialogType: DialogType.WARNING,
                                        animType: AnimType.RIGHSLIDE,
                                        headerAnimationLoop: false,
                                        title: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_admins_page_delete_admin'),
                                        dismissOnTouchOutside: false,
                                        onDissmissCallback: () {
                                          print('dismiss called');
                                        },
                                        desc:
                                            ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_admins_page_are_you_sure_you_want_to_delete_this_admin'),
                                        isDense: true,
                                        btnCancelOnPress: () {},
                                        btnOkOnPress: () async {
                                          bool resultOfDelete =
                                              await DeleteAdminHttpService
                                                  .deleteAdmin(
                                                      admins[index].id);
                                          // after getting the result
                                          if (resultOfDelete) {
                                            // if it is done

                                            // we stop loading and show a success dialog
                                            AwesomeDialog(
                                                btnOkColor: Colors.green,
                                                context: context,
                                                dialogType: DialogType.SUCCES,
                                                animType: AnimType.RIGHSLIDE,
                                                headerAnimationLoop: false,
                                                title: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_success'),
                                                dismissOnBackKeyPress: false,
                                                dismissOnTouchOutside: false,
                                                desc:
                                                    ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_admins_page_admin_deleted_successfully'),
                                                isDense: true,
                                                btnOkOnPress: () {
                                                  App.refrechAction(context);
                                                }).show();
                                          } else {
                                            // so something went wrong
                                            setState(() {
                                              dataLoading = false;
                                              AwesomeDialog(
                                                  btnOkColor: Colors.red,
                                                  context: context,
                                                  dialogType: DialogType.ERROR,
                                                  animType: AnimType.RIGHSLIDE,
                                                  headerAnimationLoop: false,
                                                  title:  ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_error'),
                                                  dismissOnBackKeyPress: true,
                                                  desc:  ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_something_went_wrong'),
                                                  isDense: true,
                                                  btnOkOnPress: () {})
                                              .show();
                                            });
                                          }
                                        }).show();

                                    print('admin deleted');
                                  },
                                ),
                              ],
                            ),
                          ),
                          bottom: 10,
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(height: 15);
              },
              itemCount: admins.length),
        )
      ],
    );
  }
}
