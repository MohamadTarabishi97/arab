import 'dart:math';

import 'package:ArabDealProject/main.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:ArabDealProject/services/data_services/search_offer_service.dart';
import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';
import 'package:ArabDealProject/services/floating_action_button_wrapper.dart';
import 'package:ArabDealProject/services/http_services/add_search_history_http_serivce.dart';
import 'package:ArabDealProject/services/http_services/delete_offer_by_admin_http_service.dart';
import 'package:ArabDealProject/services/http_services/get_offers_http_service.dart';
import 'package:ArabDealProject/language/localization/check_locale_function.dart';
import 'package:ArabDealProject/objects/offer.dart';
import 'package:ArabDealProject/services/http_services/like_offer_http_service.dart';
import 'package:ArabDealProject/services/lunch_rul.dart';
import 'package:ArabDealProject/ui/admin_section/admin_add_offer.dart';
import 'package:ArabDealProject/ui/shared/cached__image_from_network.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/loading.dart';
import 'package:ArabDealProject/ui/shared/no_internet_connection.dart';
import 'package:ArabDealProject/ui/shared/custom_app_bar.dart';
import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/ui/shared/something_went_wrong.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class AdminOffersPage extends StatefulWidget {
  _AdminOffersPageState createState() => _AdminOffersPageState();
}

class _AdminOffersPageState extends State<AdminOffersPage> {
  double widthOfScreen;
  double heightOfScreen;

  final searchController = TextEditingController();
  SearchOffer searchOffer;
  List<Offer> offers = [];
  List<Offer> offersFromInternet = [];
  ScrollController _scrollController;
  bool offersAreLoaded = false;
  SharedPreferences sharedPreferences;
  FloatingAcitonButtonWrapper floatingAcitonButtonWrapperProvider;
  Future futuredOffers;
  @override
  void initState() {
    _scrollController = ScrollController();
    sharedPreferences = SharedPreferencesInstance.getSharedPreferences;
  futuredOffers=GetOffersHttpService.getOffers();
    super.initState();
  }

  // void _scrollListener(BuildContext context) {
  //   print('scorllLister called');
  //   _scrollController.addListener(() {
  //     floatingAcitonButtonWrapperProvider =
  //         Provider.of<FloatingAcitonButtonWrapper>(context, listen: false);
  //     floatingAcitonButtonWrapperProvider.assignShowActionButton(true);
  //     if (_scrollController.position.userScrollDirection ==
  //         ScrollDirection.reverse) {
  //       // show add button
  //       print('reverse');
  //       if (floatingAcitonButtonWrapperProvider.showAddOfferButton) {
  //         floatingAcitonButtonWrapperProvider.assignShowActionButton(false);
  //       }
  //     } else {
  //       if (_scrollController.position.userScrollDirection ==
  //           ScrollDirection.forward) {
  //         print('forward');
  //         // show move button
  //         if (!floatingAcitonButtonWrapperProvider.showAddOfferButton) {
  //           floatingAcitonButtonWrapperProvider.assignShowActionButton(true);
  //         }
  //       }
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // _scrollListener(context);
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    ScreenUtil.init(context, width: widthOfScreen, height: heightOfScreen);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    print('build called');

    return Scaffold(
        backgroundColor: Colors.grey[200],
        endDrawer: DrawerWrapper(context),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (offersAreLoaded)
                _scrollController.animateTo(0,
                    duration: Duration(seconds: 1), curve: Curves.bounceOut);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.arrow_upward)),

        // Consumer<FloatingAcitonButtonWrapper>(
        //   builder: (context, provider, child) {
        //     if (provider.showAddOfferButton == null) {
        //       return Visibility(
        //         visible: (FetchUserDataService.fetchUser() != null),
        //         child: FloatingActionButton(
        //           onPressed: () {
        //             Navigator.of(context).push(MaterialPageRoute(
        //                 builder: (_) => AdminAddOffer(isAddOffer: true)));
        //           },
        //           backgroundColor: Theme.of(context).primaryColor,
        //           child: Icon(Icons.add),
        //         ),
        //       );
        //     } else {
        //       if (provider.showAddOfferButton)
        //         return Visibility(
        //           visible: (FetchUserDataService.fetchUser() != null),
        //           child: FloatingActionButton(
        //             onPressed: () {
        //               Navigator.of(context).push(MaterialPageRoute(
        //                   builder: (_) => AdminAddOffer(isAddOffer: true)));
        //             },
        //             backgroundColor: Theme.of(context).primaryColor,
        //             child: Icon(Icons.add),
        //           ),
        //         );
        //       else
        //         return FloatingActionButton(
        //           onPressed: () {
        //             if (offersAreLoaded)
        //               _scrollController.animateTo(0,
        //                   duration: Duration(seconds: 1),
        //                   curve: Curves.bounceOut);
        //           },
        //           backgroundColor: Theme.of(context).primaryColor,
        //           child: Icon(Icons.arrow_upward),
        //         );
        //     }
        //   },
        // ),
        key: _scaffoldKey,
        body: ChangeNotifierProvider(
          create: (context) => SearchOffer(),
          child: FutureBuilder(
              future: checkInternetConnectivity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    print('data is already loaded');
                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                            FutureBuilder(
                                future: futuredOffers,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      print('data just loaded ');
                                      offersFromInternet = snapshot.data;
                                      offers = offersFromInternet;
                                      offersAreLoaded = true;
                                      return Column(
                                        children: [
                                          CustomAppBar(
                                              scaffoldKey: _scaffoldKey),
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            width: widthOfScreen,
                                            height: heightOfScreen - 120,
                                            child: Consumer<SearchOffer>(
                                                builder:
                                                    (context, provider, child) {
                                              if (searchController
                                                      .text.isNotEmpty &&
                                                  provider.offers != null)
                                                offers = provider.offers;
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: WaterfallFlow.builder(
                                                  gridDelegate:
                                                      SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount:
                                                              _getNumberOfItems(),
                                                          crossAxisSpacing: 1,
                                                          mainAxisSpacing: 2.0),
                                                  controller: _scrollController,
                                                  key: ValueKey<
                                                      int>(Random(DateTime.now()
                                                          .millisecondsSinceEpoch)
                                                      .nextInt(4294967296)),
                                                  itemBuilder:
                                                      (context, index) {
                                                    Offer offer = offers[index];
                                                    return Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                //you have to pass the offer object to show its details
                                                                Navigator.of(
                                                                        context)
                                                                    .push(MaterialPageRoute(
                                                                        builder: (context) => AdminAddOffer(
                                                                              isAddOffer: false,
                                                                              index: index,
                                                                              passedOffer: offers[index],
                                                                              updateOffer: updateItem,
                                                                            )));
                                                              },
                                                              child:
                                                                  ConstrainedBox(
                                                                constraints:
                                                                    BoxConstraints(
                                                                        maxWidth:
                                                                            _getWidthOfItem() -
                                                                                1),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(Radius.circular(
                                                                              10)),
                                                                      color: Colors
                                                                          .white),
                                                                  child:
                                                                      Container(
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.end,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(right: 40.0, top: 10, bottom: 10, left: 40),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Container(child: (offers[index].user?.imageUrl != null) ? CachedImageFromNetwork(urlImage: offers[index].user.imageUrl) : SizedBox.shrink(), width: 30, height: 30),
                                                                                    SizedBox(width: 10),
                                                                                    (offers[index].user?.firstName != null ?? false) ? Text(offers[index].user.firstName + " " + offers[index].user.lastName, style: TextStyle(fontSize: ScreenUtil().setSp(15))) : SizedBox.shrink()
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                                                                                child: (offers[index].dateAr != null && offers[index].date != null) ? Text(checkWhetherArabicLocale(context) ? offers[index].dateAr : offers[index].date, style: TextStyle(fontSize: ScreenUtil().setSp(11))) : SizedBox.shrink(),
                                                                              ),
                                                                            ]),
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.only(top: 10),
                                                                              child: Hero(
                                                                                tag: index.toString(),
                                                                                child: ConstrainedBox(
                                                                                  constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(120), maxHeight: ScreenUtil().setWidth(100)),
                                                                                  child: Container(
                                                                                    child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 5.0, right: 5),
                                                                                        child: (offers[index].imageUrl?.isNotEmpty ?? false)
                                                                                            ? FittedBox(
                                                                                                child: CachedImageFromNetwork(urlImage: offers[index].imageUrl[0]),
                                                                                                fit: BoxFit.contain,
                                                                                              )
                                                                                            : SizedBox.shrink()),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Column(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 13.0, right: 10),
                                                                                  child: ConstrainedBox(
                                                                                      constraints: BoxConstraints(maxWidth: 150),
                                                                                      child: ((checkWhetherArabicLocale(context) && offer.offerTitleArabic != null) || (!checkWhetherArabicLocale(context) && offer.offerTitleGerman != null))
                                                                                          ? Text(
                                                                                              !checkWhetherArabicLocale(context) ? offer.offerTitleGerman : offer.offerTitleArabic,
                                                                                              style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18)),
                                                                                              textAlign: TextAlign.center,
                                                                                            )
                                                                                          : SizedBox.shrink()),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 10.0, right: 10),
                                                                                  child: Container(
                                                                                    constraints: BoxConstraints(maxWidth: 160),
                                                                                    child: ((checkWhetherArabicLocale(context) && offer.offerShortDescriptionArabic != null) || (!checkWhetherArabicLocale(context) && offer.offerShortDescriptionGerman != null)) ? Text(!checkWhetherArabicLocale(context) ? offer.offerShortDescriptionGerman : offer.offerShortDescriptionArabic, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[800], fontSize: ScreenUtil().setSp(16))) : SizedBox.shrink(),
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(top: 10.0),
                                                                                  child: Container(
                                                                                    constraints: BoxConstraints(maxWidth: 185),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(top: 4.0),
                                                                                          child: (offer.priceBefore != null) ? Text('${offer.priceBefore.toString()}\€', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[800], fontSize: ScreenUtil().setSp(14))) : SizedBox.shrink(),
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(top: 4.0),
                                                                                          child: (offer.priceAfter != null) ? Text(offer.priceAfter.toString() + '\€', style: TextStyle(color: Color(0xffde1515), fontSize: ScreenUtil().setSp(14))) : SizedBox.shrink(),
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        Padding(
                                                                                          padding: const EdgeInsets.only(top: 4.0),
                                                                                          child: (offer.percent != null) ? Text('${offer.percent.toString()}%', style: TextStyle(color: Colors.grey[800], fontSize: ScreenUtil().setSp(14))) : SizedBox.shrink(),
                                                                                        ),
                                                                                        SizedBox(width: 5),
                                                                                        Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'admin_offers_page_discount'), style: TextStyle(fontSize: ScreenUtil().setSp(11)))
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ), // )
                                                                          ],
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(
                                                                              top: 10.0,
                                                                              bottom: 5),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  bool isConnected = await checkInternetConnectivity();
                                                                                  if (isConnected) {
                                                                                    User user = FetchUserDataService.fetchUser();
                                                                                    if (user != null) {
                                                                                      int result = await LikeOfferHttpService.likeOffer(offer);
                                                                                      if (result == 1) {
                                                                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'admin_offers_page_you_liked_the_offer'))));
                                                                                      } else if (result == 0) {
                                                                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'admin_offers_page_you_disliked_the_offer'))));
                                                                                      } else {
                                                                                        Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_something_went_wrong'))));
                                                                                      }
                                                                                    } else {
                                                                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_like_offer_condition'))));
                                                                                    }
                                                                                  } else {
                                                                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_no_internet_connection'))));
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                  constraints: BoxConstraints(maxWidth: 35),
                                                                                  margin: checkWhetherArabicLocale(context) ? EdgeInsets.only(right: 18) : EdgeInsets.only(left: 18),
                                                                                  padding: EdgeInsets.all(7),
                                                                                  height: 30,
                                                                                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      SvgPicture.asset(
                                                                                        'assets/images/heart.svg',
                                                                                        width: 17,
                                                                                        height: 17,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 5),
                                                                              InkWell(
                                                                                onTap: () {},
                                                                                child: Container(
                                                                                    constraints: BoxConstraints(maxWidth: 70),
                                                                                    height: 30,
                                                                                    decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Icon(Icons.message, color: Colors.black, size: 17),
                                                                                        SizedBox(width: 4),
                                                                                        (offers[index].commentsNumber != null) ? Text(offers[index].commentsNumber.toString(), style: TextStyle(fontSize: ScreenUtil().setSp(15))) : SizedBox.shrink()
                                                                                      ],
                                                                                    )),
                                                                              ),
                                                                              SizedBox(width: 5),
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  bool isConnected = await checkInternetConnectivity();
                                                                                  if (isConnected) {
                                                                                    bool resultOfDeleting;
                                                                                    AwesomeDialog(
                                                                                        btnOkColor: Colors.red,
                                                                                        context: context,
                                                                                        dialogType: DialogType.WARNING,
                                                                                        animType: AnimType.RIGHSLIDE,
                                                                                        headerAnimationLoop: false,
                                                                                        title: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_delete_offer'),
                                                                                        dismissOnTouchOutside: false,
                                                                                        onDissmissCallback: () {
                                                                                          print('dismiss called');
                                                                                        },
                                                                                        desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_are_you_sure_you_want_to_delete_this_offer'),
                                                                                        isDense: true,
                                                                                        btnCancelOnPress: () {},
                                                                                        btnOkOnPress: () async {
                                                                                          resultOfDeleting = await DeleteOfferByAdminHttpService.deleteOfferByAdmin(offers[index].id);
                                                                                          if (resultOfDeleting) {
                                                                                            AwesomeDialog(
                                                                                                btnOkColor: Colors.green,
                                                                                                context: context,
                                                                                                dialogType: DialogType.SUCCES,
                                                                                                animType: AnimType.RIGHSLIDE,
                                                                                                headerAnimationLoop: false,
                                                                                                title: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_success'),
                                                                                                dismissOnTouchOutside: false,
                                                                                                dismissOnBackKeyPress: false,
                                                                                                desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_offer_deleted_successfully'),
                                                                                                isDense: true,
                                                                                                btnOkOnPress: () {
                                                                                                  _refreshOffers();
                                                                                                  App.refrechAction(context);
                                                                                                }).show();
                                                                                          } else
                                                                                            AwesomeDialog(btnOkColor: Colors.red, context: context, dialogType: DialogType.ERROR, animType: AnimType.RIGHSLIDE, headerAnimationLoop: false, title: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_error'), dismissOnBackKeyPress: true, desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_something_went_wrong'), isDense: true, btnOkOnPress: () {}).show();
                                                                                        }).show();
                                                                                  } else {
                                                                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_no_internet_connection'))));
                                                                                  }
                                                                                },
                                                                                child: Container(width: 25, height: 30, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)), child: Icon(Icons.delete_forever, color: Colors.black, size: 17)),
                                                                              ),
                                                                              SizedBox(width: 5),
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  if (sharedPreferences.getBool('shareOption'))
                                                                                    Share.share('https://arabdeals.de/Offer/View/${offer.id}');
                                                                                  else
                                                                                    _showSharePermissionDialog(context, offer.id);
                                                                                },
                                                                                child: Container(width: 40, height: 30, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)), child: Icon(Icons.share, color: Colors.black, size: 17)),
                                                                              ),
                                                                              SizedBox(width: 5),
                                                                              InkWell(
                                                                                onTap: () async {
                                                                                  if (sharedPreferences.getBool('openBrowser')) {
                                                                                    bool isConnected = await checkInternetConnectivity();
                                                                                    if (isConnected) {
                                                                                   if(offer.vouchersCode!=null){
                                                                                        await FlutterClipboard.copy(offer.vouchersCode);
                                                                                      AwesomeDialog(
                                                                                        context: context,
                                                                                        dialogType: DialogType.INFO,
                                                                                        animType: AnimType.SCALE,
                                                                                        headerAnimationLoop: false,
                                                                                        autoHide: Duration(seconds: 5),
                                                                                        title: 'Copy',
                                                                                       desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_the_code_has_copied'),
                                                                                        isDense: true,
                                                                                      ).show();
                                                                                      print('here we go with delay');
                                                                                      await Future.delayed(Duration(seconds: 2));
                                                                                   }
                                                                                      await LaunchUrl.launchURL(offer.offerUrl);
                                                                                    } else {
                                                                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_no_internet_connection'))));
                                                                                    }
                                                                                  } else {
                                                                                    _showOpenBorwserPermissionDialog(context, offer.offerUrl, offer.vouchersCode);
                                                                                  }
                                                                                },
                                                                                child: Container(
                                                                                    width: 80,
                                                                                    height: 30,
                                                                                    decoration: BoxDecoration(color: Color(0xffde1515), borderRadius: BorderRadius.circular(4)),
                                                                                    child: Center(
                                                                                      child: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'admin_offers_page_move_to_offer'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14))),
                                                                                    )),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Container(
                                                            width:
                                                                widthOfScreen,
                                                            height: ScreenUtil()
                                                                .setHeight(10),
                                                            color: Colors
                                                                .grey[200])
                                                      ],
                                                    );
                                                  },
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  itemCount: offers.length,
                                                ),
                                              );
                                            }),
                                          )
                                        ],
                                      );
                                    } else if (snapshot.hasError) {
                                      return Column(
                                        children: [
                                          SomethingWentWrongWidget(),
                                          SizedBox(height: 20),
                                          Text(snapshot.error)
                                        ],
                                      );
                                    } else
                                      return Column(
                                        children: [
                                          SomethingWentWrongWidget(),
                                        ],
                                      );
                                  } else
                                    return OffersLoadingWidget();
                                }),
                          Positioned(
                            top: 85,
                            left: 5,
                            right: 5,
                            child: Container(
                                margin: EdgeInsets.only(left: 8, right: 8),
                                child: TextFormField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.search),
                                      hintText: ArabDealLocalization.of(context)
                                          .getTranslatedWordByKey(
                                              key: 'all_pages_search'),
                                      filled: true,
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300],
                                              width: 2)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                          borderSide: BorderSide(
                                              color: Colors.grey[300],
                                              width: 2))),
                                  onFieldSubmitted: (currentText) async {
                                    if (currentText.isNotEmpty) {
                                      if (currentText.trim().length != 0) {
                                        searchOffer = Provider.of<SearchOffer>(
                                            context,
                                            listen: false);
                                        searchOffer.searchAndReturn(
                                            listOfOffers: offersFromInternet,
                                            currentText: currentText
                                                .trimRight()
                                                .trimLeft());

                                        bool result =
                                            await AddSearchHistoryHttpService
                                                .addSearchHistroy(currentText);
                                      }
                                    }
                                  },
                                ),
                                width: widthOfScreen,
                                height: 60),
                          ),
                        ],
                      ),
                    );
                  } else
                    return NoInternetConnectionWidget();
                } else {
                  print('connectivity loading');
                  return OffersLoadingWidget();
                }
              }),
        ));
  }

  int _getNumberOfItems() {
    return (widthOfScreen ~/ 320);
  }

  double _getWidthOfItem() {
    if ((widthOfScreen ~/ 320) == 1)
      return widthOfScreen - 30;
    else {
      return ((widthOfScreen - 30) / _getNumberOfItems());
    }
  }

  void updateItem(int index, Offer offer) {
    setState(() {
      offers[index] = offer;
    });
  }

  _showSharePermissionDialog(BuildContext context, int id) async {
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
                              sharedPreferences.setBool('shareOption', false);
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
                            onTap: () {
                              sharedPreferences.setBool('shareOption', true);
                              Navigator.of(context).pop();
                              Share.share(
                                  'https://arabdeals.de/Offer/View/$id');
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
  void _refreshOffers(){
    setState(
      (){
        futuredOffers=GetOffersHttpService.getOffers();
      }
    );
  }
  _showOpenBorwserPermissionDialog(
      BuildContext context, String url, String code) async {
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
                            constraints: BoxConstraints(
                              maxWidth: widthOfScreen - 90,
                            ),
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
                              if (code != null) {
                                await FlutterClipboard.copy(code);
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.INFO,
                                  animType: AnimType.SCALE,
                                  headerAnimationLoop: false,
                                  autoHide: Duration(seconds: 5),
                                  title: 'Copy',
                                  desc:
                                      'The code has been copied to your clipboard',
                                  isDense: true,
                                ).show();
                                print('here we go with delay');
                                await Future.delayed(Duration(seconds: 2));
                              }

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
}

class NoInternetConnectionWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppBar(scaffoldKey: _scaffoldKey),
          SizedBox(
            height: 100,
          ),
          NoInternetConnection(),
        ],
      ),
    );
  }
}

class SomethingWentWrongWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppBar(scaffoldKey: _scaffoldKey),
          SizedBox(
            height: ScreenUtil().setHeight(100),
          ),
          SomethingWentWrong(),
        ],
      ),
    );
  }
}

class OffersLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomAppBar(scaffoldKey: _scaffoldKey),
          SizedBox(
            height: 200,
          ),
          Loading(),
        ],
      ),
    );
  }
}
