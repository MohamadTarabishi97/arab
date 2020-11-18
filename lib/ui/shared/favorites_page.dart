import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/language/localization/check_locale_function.dart';
import 'package:ArabDealProject/objects/category.dart';
import 'package:ArabDealProject/objects/favorite.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';
import 'package:ArabDealProject/services/http_services/add_search_history_http_serivce.dart';
import 'package:ArabDealProject/services/http_services/delete_favorite_http_service.dart';
import 'package:ArabDealProject/services/http_services/get_categories_http_service.dart';
import 'package:ArabDealProject/services/http_services/get_favorites_http_service.dart';
import 'package:ArabDealProject/ui/shared/custom_app_bar.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/loading.dart';
import 'package:ArabDealProject/ui/shared/no_internet_connection.dart';
import 'package:ArabDealProject/ui/shared/something_went_wrong.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:ArabDealProject/objects/user.dart';

class FavoritesPage extends StatefulWidget {
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  GlobalKey<ScaffoldState> scaffoldKey;
  double widthOfScreen;
  double heightOfScreen;
  Future<List<Favorite>> futuredFavorites;
  List<Favorite> favorites;
  bool favoritesLoaded;
  User user;
  @override
  void initState() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    user = FetchUserDataService.fetchUser();
    futuredFavorites = GetFavoritesHttpService.getFavorites(user.id);
    favoritesLoaded = false;
    favorites = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    ScreenUtil.init(context, width: widthOfScreen, height: heightOfScreen);
    return Scaffold(
      key: scaffoldKey,
      endDrawer: DrawerWrapper(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomAppBar(scaffoldKey: scaffoldKey),
            FutureBuilder(
                future: checkInternetConnectivity(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data) {
                      return FutureBuilder(
                          future: futuredFavorites,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              favorites = snapshot.data;
                              return Container(
                                width: widthOfScreen,
                                height: heightOfScreen - 100,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Container(
                                        width: widthOfScreen,
                                        height: ScreenUtil().setHeight(80),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                                ArabDealLocalization.of(context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'choose_categories_page_favorite_categories'),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        ScreenUtil().setSp(20)))
                                          ],
                                        )),
                                    Container(
                                      width: widthOfScreen,
                                      height: heightOfScreen - 180,
                                      child: Container(
                                        width: widthOfScreen,
                                        height: heightOfScreen - 400,
                                        child: Column(
                                          children: [
                                          SizedBox(height: 20),
                                    ConstrainedBox(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border(
                                                top: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                left: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                right: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                bottom: BorderSide(
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5))),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                ConstrainedBox(
                                                  child: Text(
                                                    ArabDealLocalization.of(
                                                            context)
                                                        .getTranslatedWordByKey(
                                                            key:
                                                                'favorites_page_you_will_recieve_notifications'),
                                                                textAlign: TextAlign.center,
                                                              style:TextStyle(fontWeight:FontWeight.bold,),
                                                  ),
                                                   constraints: BoxConstraints(
                                            maxWidth: widthOfScreen - 100),
                                                ),
                                                SizedBox(width: 5),
                                                Icon(Icons.info_outline,
                                                    color: Theme.of(context)
                                                        .primaryColor)
                                              ],
                                            ),
                                          ),
                                        ),
                                        constraints: BoxConstraints(
                                            maxWidth: widthOfScreen - 50)),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 8.0),
                                                child: Flex(
                                                  direction: Axis.vertical,
                                                  children: [
                                                    Expanded(
                                                      child: ListView.separated(
                                                        itemBuilder:
                                                            (context, index) {
                                                          if (index ==
                                                              favorites
                                                                  .length) {
                                                            return Card(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              color: Colors
                                                                  .grey[200],
                                                              child: InkWell(
                                                                splashColor: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                onTap: () {
                                                                  _showAddFavoriteDialog(
                                                                      context);
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          80.0,
                                                                      vertical:
                                                                          40),
                                                                  child: Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .add,
                                                                        color: Theme.of(context)
                                                                            .primaryColor),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          } else
                                                            return Card(
                                                              color: Colors
                                                                  .grey[200],
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              child: InkWell(
                                                                child: Stack(
                                                                  children: [
                                                                    Positioned(
                                                                        bottom:
                                                                            10,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 8.0),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              InkWell(
                                                                                  child: Icon(Icons.delete, size: 30, color: Theme.of(context).primaryColor),
                                                                                  onTap: () async {
                                                                                    bool resultOfCheckingInternetConnectivity = await checkInternetConnectivity();
                                                                                    if (resultOfCheckingInternetConnectivity) {
                                                                                      bool resultOfDeleting = await DeleteFavoriteHttpService.deleteFavorite(favorites[index].id);
                                                                                      if (resultOfDeleting) {
                                                                                        setState(() {
                                                                                          favorites.removeAt(index);
                                                                                        });
                                                                                        print('word deleted');
                                                                                      } else {
                                                                                        print('something went wrong');
                                                                                      }
                                                                                    } else {
                                                                                      print('check your internet connectivity');
                                                                                    }
                                                                                  }),
                                                                            ],
                                                                          ),
                                                                        )),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          horizontal:
                                                                              80.0,
                                                                          vertical:
                                                                              40.0),
                                                                      child: Center(
                                                                          child: Text(
                                                                        favorites[index]
                                                                            .word,
                                                                        style: TextStyle(
                                                                            color:
                                                                                Color(0xffde1515),
                                                                            fontSize: ScreenUtil().setSp(20)),
                                                                      )),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                        },
                                                        itemCount:
                                                            favorites.length +
                                                                1,
                                                        separatorBuilder:
                                                            (context, index) {
                                                          return SizedBox(
                                                              height:
                                                                  ScreenUtil()
                                                                      .setHeight(
                                                                          10),
                                                              width:
                                                                  widthOfScreen);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Column(
                                children: [
                                  SizedBox(height: 100),
                                  SomethingWentWrong(),
                                ],
                              );
                            } else {
                              print('internet connectivity loading 2');
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 200),
                                  Loading(),
                                ],
                              );
                            }
                          });
                    } else {
                      return Column(
                        children: [
                          SizedBox(height: 130),
                          NoInternetConnection(),
                        ],
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Column(
                      children: [
                        SizedBox(height: 100),
                        SomethingWentWrong(),
                      ],
                    );
                  } else {
                    print('internet connectivity loading 2');
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 200),
                        Loading(),
                      ],
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  void _addFavoriteAtFirst() {
    user = FetchUserDataService.fetchUser();
    setState(() {
      futuredFavorites = GetFavoritesHttpService.getFavorites(user.id);
    });
  }

  Future<void> _showAddFavoriteDialog(BuildContext context) {
    Favorite favorite = Favorite();
    final formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: formKey,
            child: AlertDialog(
              title: Text(
                  ArabDealLocalization.of(context).getTranslatedWordByKey(
                      key: 'favorites_page_add_your_favorite'),
                  style: TextStyle(fontSize: ScreenUtil().setSp(16))),
              content: Container(
                width: 200,
                height: 200,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      Container(
                        width: 250,
                        height: 60,
                        child: TextFormField(
                            onSaved: (String word) {
                              favorite.word = word;
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
                                      key: 'favorites_page_type_your_favorite'),
                            )),
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
                                bool result = await AddSearchHistoryHttpService
                                    .addSearchHistroy(favorite.word);
                                if (result) {
                                  print('word added');
                                  _addFavoriteAtFirst();
                                  Navigator.of(context).pop();
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

  InputDecoration _getDecorationOfTextField({@required String hintText}) {
    return InputDecoration(
        hintText: hintText,
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
}
