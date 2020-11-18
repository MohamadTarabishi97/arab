import 'package:ArabDealProject/main.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:ArabDealProject/services/data_services/search_offer_service.dart';
import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';
import 'package:ArabDealProject/services/floating_action_button_wrapper.dart';
import 'package:ArabDealProject/services/http_services/add_search_history_http_serivce.dart';
import 'package:ArabDealProject/services/http_services/get_offers_http_service.dart';
import 'package:ArabDealProject/language/localization/check_locale_function.dart';
import 'package:ArabDealProject/objects/offer.dart';
import 'package:ArabDealProject/services/http_services/like_offer_http_service.dart';
import 'package:ArabDealProject/services/lunch_rul.dart';
import 'package:ArabDealProject/services/move_to_the_top_home_page.dart';
import 'package:ArabDealProject/shared_contexts.dart';
import 'package:ArabDealProject/ui/shared/cached__image_from_network.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/loading.dart';
import 'package:ArabDealProject/ui/shared/no_internet_connection.dart';
import 'package:ArabDealProject/ui/shared/something_went_wrong.dart';
//import 'package:ArabDealProject/ui/user_section/animation_test.dart';
import 'package:ArabDealProject/ui/user_section/user_add_offer_page.dart';
import 'package:ArabDealProject/ui/user_section/user_offer_page.dart';
import 'package:ArabDealProject/ui/shared/custom_app_bar.dart';
import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(
    debugLabel: "global key for user home page scaffold");

class HomePage extends StatefulWidget {
  bool offersAreLoaded;
  HomePage() {
    print('ddddddddddddddddd called');
    offersAreLoaded = false;
  }
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double widthOfScreen;
  double heightOfScreen;

  final searchController = TextEditingController();
  SearchOffer searchOffer;
  List<Offer> offers = [];
  List<Offer> offersFromInternet = [];
  ScrollController _scrollController;
  bool showAddOfferButton = true;
  FloatingAcitonButtonWrapper floatingAcitonButtonWrapperProvider;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    _scrollController = ScrollController();
    MoveToTheTopHomePage.moveToTheTopHomePageAction = goToTheTopIndex;
    sharedPreferences = SharedPreferencesInstance.getSharedPreferences;
    super.initState();
  }

  // void _scrollListener(BuildContext context) {

  //   print('scorllLister called');
  //   _scrollController.addListener(() {
  //     floatingAcitonButtonWrapperProvider =
  //       Provider.of<FloatingAcitonButtonWrapper>(context, listen: false);
  //   floatingAcitonButtonWrapperProvider.assignShowActionButton(true);
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
    //_scrollListener(context);
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    SharedContexts.homeContext = context;
    ScreenUtil.init(context, width: widthOfScreen, height: heightOfScreen);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    print('build called');
    return Scaffold(
        backgroundColor: Colors.grey[200],
        endDrawer: DrawerWrapper(
          context,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.offersAreLoaded)
              _scrollController.animateTo(0,
                  duration: Duration(seconds: 1), curve: Curves.bounceOut);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.arrow_upward),
        ),
        // floatingActionButton: Consumer<FloatingAcitonButtonWrapper>(
        //   builder: (context, provider, child) {
        //     if (provider.showAddOfferButton == null){
        //        return Visibility(
        //         visible: (FetchUserDataService.fetchUser() != null),
        //         child: FloatingActionButton(
        //           onPressed: () {
        //             Navigator.of(context).push(MaterialPageRoute(
        //                 builder: (_) => UserAddOffer(isAddOffer: true)));
        //           },
        //           backgroundColor: Theme.of(context).primaryColor,
        //           child: Icon(Icons.add),
        //         ),
        //       );
        //     }
        //        else{
        //           if(provider.showAddOfferButton)
        //       return Visibility(
        //         visible: (FetchUserDataService.fetchUser() != null),
        //         child: FloatingActionButton(
        //           onPressed: () {
        //             Navigator.of(context).push(MaterialPageRoute(
        //                 builder: (_) => UserAddOffer(isAddOffer: true)));
        //           },
        //           backgroundColor: Theme.of(context).primaryColor,
        //           child: Icon(Icons.add),
        //         ),
        //       );
        //     else
        //       return FloatingActionButton(
        //         onPressed: () {
        //           if (widget.offersAreLoaded)
        //             _scrollController.animateTo(0,
        //                 duration: Duration(seconds: 1),
        //                 curve: Curves.bounceOut);

        //         },
        //         backgroundColor: Theme.of(context).primaryColor,
        //         child: Icon(Icons.arrow_upward),
        //       );
        //        }
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
                    if (widget.offersAreLoaded) {
                      offers = offersFromInternet;
                      print('data is already loaded');
                    }
                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                          widget.offersAreLoaded
                              ? Column(
                                  children: [
                                    CustomAppBar(scaffoldKey: _scaffoldKey),
                                    RefreshIndicator(
                                      onRefresh: () {
                                        App.refrechAction(context);
                                        return Future.delayed(
                                            Duration(seconds: 2));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(20)),
                                        width: widthOfScreen,
                                        height: heightOfScreen - 120,
                                        child: Consumer<SearchOffer>(builder:
                                            (context, provider, child) {
                                          if (searchController.text
                                                      .trim()
                                                      .length !=
                                                  0 &&
                                              provider.offers != null)
                                            offers = provider.offers;

                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: WaterfallFlow.builder(
                                              gridDelegate:
                                                  SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount:
                                                          _getNumberOfItems(),
                                                      crossAxisSpacing: 1,
                                                      mainAxisSpacing: 2.0),
                                              physics: BouncingScrollPhysics(),
                                              controller: _scrollController,
                                              itemBuilder: (context, index) {
                                                Offer offer = offers[index];
                                                // offer.offerDescriptionGerman=offer.offerDescriptionGerman+'Adidas Performance Tiro 19 Herren Poloshirt für 15,96€ statt 34,95€ inkl. Versand.• In verschiedenen Farben  https://pub.dev/packages/flutter_linkify';
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                              return OfferPage(
                                                                likeOfferAction:
                                                                    incrementLikesNumber,
                                                                arabicDescription:
                                                                    offer
                                                                        .offerDescriptionArabic,
                                                                germanDescription:
                                                                    offer
                                                                        .offerDescriptionGerman,
                                                                commentOfferAction:
                                                                    incrementCommentsNumber,
                                                                decrementCommentsNumber:
                                                                    decrementCommentsNumber,
                                                                images: offers[
                                                                        index]
                                                                    .imageUrl,
                                                                offer: offer,
                                                                index: index
                                                                    .toString(),
                                                              );
                                                            }));
                                                          },
                                                          child: LayoutBuilder(
                                                              builder: (context,
                                                                  constraints) {
                                                            return ConstrainedBox(
                                                              constraints:
                                                                  BoxConstraints(
                                                                      maxWidth:
                                                                          _getWidthOfItem() -
                                                                              1),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            10)),
                                                                    color: Colors
                                                                        .white),
                                                                child:
                                                                    Container(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.end,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(right: 8.0, top: 5, left: 8.0),
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
                                                                            padding:
                                                                                EdgeInsets.only(top: 10),
                                                                            child:
                                                                                Hero(
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
                                                                          ConstrainedBox(
                                                                            constraints:
                                                                                BoxConstraints(
                                                                              maxWidth: ScreenUtil().setWidth(185),
                                                                            ),
                                                                            child:
                                                                                Container(
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 13.0, right: 10),
                                                                                    child: ConstrainedBox(
                                                                                        constraints: BoxConstraints(
                                                                                          maxWidth: ScreenUtil().setWidth(150),
                                                                                        ),
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
                                                                                      constraints: BoxConstraints(
                                                                                        maxWidth: ScreenUtil().setWidth(160),
                                                                                      ),
                                                                                      child: ((checkWhetherArabicLocale(context) && offer.offerShortDescriptionArabic != null) || (!checkWhetherArabicLocale(context) && offer.offerShortDescriptionGerman != null)) ? Text(!checkWhetherArabicLocale(context) ? offer.offerShortDescriptionGerman : offer.offerShortDescriptionArabic, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[800], fontSize: ScreenUtil().setSp(16))) : SizedBox.shrink(),
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 10.0),
                                                                                    child: Container(
                                                                                      constraints: BoxConstraints(
                                                                                        maxWidth: ScreenUtil().setWidth(185),
                                                                                      ),
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
                                                                                          Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'user_home_page_discount'), style: TextStyle(fontSize: ScreenUtil().setSp(12)))
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ), // )
                                                                        ],
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                10.0,
                                                                            bottom:
                                                                                5),
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
                                                                                      setState(() {
                                                                                        offers[index].likeNumber++;
                                                                                        print('like');
                                                                                      });
                                                                                    } else if (result == 0) {
                                                                                      setState(() {
                                                                                        offers[index].likeNumber--;
                                                                                        print('dislike');
                                                                                      });
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
                                                                                constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(70)),
                                                                                margin: checkWhetherArabicLocale(context) ? EdgeInsets.only(right: ScreenUtil().setWidth(18)) : EdgeInsets.only(left: ScreenUtil().setWidth(18)),
                                                                                padding: EdgeInsets.all(7),
                                                                                height: ScreenUtil().setHeight(30),
                                                                                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    SvgPicture.asset(
                                                                                      'assets/images/heart.svg',
                                                                                      width: ScreenUtil().setWidth(17),
                                                                                      height: ScreenUtil().setHeight(17),
                                                                                      color: Colors.black,
                                                                                    ),
                                                                                    SizedBox(width: 4),
                                                                                    (offers[index].likeNumber != null) ? Text(offers[index].likeNumber.toString(), style: TextStyle(fontSize: ScreenUtil().setSp(15))) : SizedBox.shrink()
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 5),
                                                                            InkWell(
                                                                              onTap: () {},
                                                                              child: Container(
                                                                                  constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(70)),
                                                                                  height: ScreenUtil().setHeight(30),
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
                                                                              onTap: () {
                                                                                if (sharedPreferences.getBool('shareOption'))
                                                                                  Share.share('https://arabdeals.de/Offer/View/${offer.id}');
                                                                                else
                                                                                  _showSharePermissionDialog(context, offer.id);
                                                                              },
                                                                              child: Container(width: ScreenUtil().setWidth(40), height: ScreenUtil().setHeight(30), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)), child: Icon(Icons.share, color: Colors.black, size: 17)),
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
                                                                                  _showOpenBorwserPermissionDialog(context, offer.offerUrl);
                                                                                }
                                                                              },
                                                                              child: Container(
                                                                                  width: ScreenUtil().setWidth(80),
                                                                                  height: ScreenUtil().setHeight(30),
                                                                                  decoration: BoxDecoration(color: Color(0xffde1515), borderRadius: BorderRadius.circular(4)),
                                                                                  child: Center(
                                                                                    child: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'user_home_page_move_to_offer'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14))),
                                                                                  )),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                        width: widthOfScreen,
                                                        height: ScreenUtil()
                                                            .setHeight(10),
                                                        color: Colors.grey[200])
                                                  ],
                                                );
                                              },
                                              itemCount: offers.length,
                                            ),
                                          );
                                        }),
                                      ),
                                    )
                                  ],
                                )
                              : FutureBuilder(
                                  future: GetOffersHttpService.getOffers(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasData) {
                                        print('data just loaded ');
                                        offersFromInternet = snapshot.data;
                                        widget.offersAreLoaded = true;
                                        offers = offersFromInternet;
                                        return Column(
                                          children: [
                                            CustomAppBar(
                                                scaffoldKey: _scaffoldKey),
                                            RefreshIndicator(
                                              onRefresh: () {
                                                App.refrechAction(context);
                                                return Future.delayed(
                                                    Duration(seconds: 2));
                                              },
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(top: 20),
                                                width: widthOfScreen,
                                                height: heightOfScreen - 120,
                                                child: Consumer<SearchOffer>(
                                                    builder: (context, provider,
                                                        child) {
                                                  if (searchController
                                                          .text.isNotEmpty &&
                                                      provider.offers != null)
                                                    offers = provider.offers;
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15.0),
                                                    child:
                                                        WaterfallFlow.builder(
                                                      gridDelegate:
                                                          SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  _getNumberOfItems(),
                                                              crossAxisSpacing:
                                                                  1,
                                                              mainAxisSpacing:
                                                                  2.0),
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      controller:
                                                          _scrollController,
                                                      itemBuilder:
                                                          (context, index) {
                                                        Offer offer =
                                                            offers[index];

                                                        // offer.offerDescriptionGerman=offer.offerDescriptionGerman+'Adidas Performance Tiro 19 Herren Poloshirt für 15,96€ statt 34,95€ inkl. Versand.• In verschiedenen Farben  https://pub.dev/packages/flutter_linkify';
                                                        return Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .push(MaterialPageRoute(builder:
                                                                            (context) {
                                                                      return OfferPage(
                                                                        likeOfferAction:
                                                                            incrementLikesNumber,
                                                                        commentOfferAction:
                                                                            incrementCommentsNumber,
                                                                        decrementCommentsNumber:
                                                                            decrementCommentsNumber,
                                                                        arabicDescription:
                                                                            offer.offerDescriptionArabic,
                                                                        germanDescription:
                                                                            offer.offerDescriptionGerman,
                                                                        images:
                                                                            offers[index].imageUrl,
                                                                        offer: offers[
                                                                            index],
                                                                        index: index
                                                                            .toString(),
                                                                      );
                                                                    }));
                                                                  },
                                                                  child: LayoutBuilder(
                                                                      builder:
                                                                          (context,
                                                                              constraints) {
                                                                    return ConstrainedBox(
                                                                      constraints:
                                                                          BoxConstraints(
                                                                              maxWidth: _getWidthOfItem() - 1),
                                                                      child:
                                                                          Container(
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.all(Radius.circular(10)),
                                                                            color: Colors.white),
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            children: [
                                                                              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(right: 8.0, top: 5, left: 8.0),
                                                                                  child: (offers[index].dateAr != null && offers[index].date != null) ? Text(checkWhetherArabicLocale(context) ? offers[index].dateAr : offers[index].date, style: TextStyle(fontSize: ScreenUtil().setSp(11))) : SizedBox.shrink(),
                                                                                ),
                                                                              ]),
                                                                              Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
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
                                                                                  ConstrainedBox(
                                                                                    constraints: BoxConstraints(
                                                                                      maxWidth: ScreenUtil().setWidth(185),
                                                                                    ),
                                                                                    child: Container(
                                                                                      child: Column(
                                                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                        children: [
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(top: 13.0, right: 10),
                                                                                            child: ConstrainedBox(
                                                                                                constraints: BoxConstraints(
                                                                                                  maxWidth: ScreenUtil().setWidth(150),
                                                                                                ),
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
                                                                                              constraints: BoxConstraints(
                                                                                                maxWidth: ScreenUtil().setWidth(160),
                                                                                              ),
                                                                                              child: ((checkWhetherArabicLocale(context) && offer.offerShortDescriptionArabic != null) || (!checkWhetherArabicLocale(context) && offer.offerShortDescriptionGerman != null)) ? Text(!checkWhetherArabicLocale(context) ? offer.offerShortDescriptionGerman : offer.offerShortDescriptionArabic, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[800], fontSize: ScreenUtil().setSp(16))) : SizedBox.shrink(),
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.only(top: 10.0),
                                                                                            child: Container(
                                                                                              constraints: BoxConstraints(
                                                                                                maxWidth: ScreenUtil().setWidth(185),
                                                                                              ),
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
                                                                                                  Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'user_home_page_discount'), style: TextStyle(fontSize: ScreenUtil().setSp(12)))
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ), // )
                                                                                ],
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    InkWell(
                                                                                      onTap: () async {
                                                                                        bool isConnected = await checkInternetConnectivity();
                                                                                        if (isConnected) {
                                                                                          User user = FetchUserDataService.fetchUser();
                                                                                          if (user != null) {
                                                                                            int result = await LikeOfferHttpService.likeOffer(offer);
                                                                                            if (result == 1) {
                                                                                              setState(() {
                                                                                                offers[index].likeNumber++;
                                                                                                print('like');
                                                                                              });
                                                                                            } else if (result == 0) {
                                                                                              setState(() {
                                                                                                offers[index].likeNumber--;
                                                                                                print('dislike');
                                                                                              });
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
                                                                                        constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(70)),
                                                                                        margin: checkWhetherArabicLocale(context) ? EdgeInsets.only(right: ScreenUtil().setWidth(18)) : EdgeInsets.only(left: ScreenUtil().setWidth(18)),
                                                                                        padding: EdgeInsets.all(7),
                                                                                        height: ScreenUtil().setHeight(30),
                                                                                        decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                          children: [
                                                                                            SvgPicture.asset(
                                                                                              'assets/images/heart.svg',
                                                                                              width: ScreenUtil().setWidth(17),
                                                                                              height: ScreenUtil().setHeight(17),
                                                                                              color: Colors.black,
                                                                                            ),
                                                                                            SizedBox(width: 4),
                                                                                            (offers[index].likeNumber != null) ? Text(offers[index].likeNumber.toString(), style: TextStyle(fontSize: ScreenUtil().setSp(15))) : SizedBox.shrink()
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(width: 5),
                                                                                    InkWell(
                                                                                      onTap: () {},
                                                                                      child: Container(
                                                                                          constraints: BoxConstraints(maxWidth: ScreenUtil().setWidth(70)),
                                                                                          height: ScreenUtil().setHeight(30),
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
                                                                                      onTap: () {
                                                                                        if (sharedPreferences.getBool('shareOption'))
                                                                                          Share.share('https://arabdeals.de/Offer/View/${offer.id}');
                                                                                        else
                                                                                          _showSharePermissionDialog(context, offer.id);
                                                                                      },
                                                                                      child: Container(width: ScreenUtil().setWidth(40), height: ScreenUtil().setHeight(30), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)), child: Icon(Icons.share, color: Colors.black, size: 17)),
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
                                                                                      desc: 'The code has been copied to your clipboard',
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
                                                                                          _showOpenBorwserPermissionDialog(context, offer.offerUrl);
                                                                                        }
                                                                                      },
                                                                                      child: Container(
                                                                                          width: ScreenUtil().setWidth(80),
                                                                                          height: ScreenUtil().setHeight(30),
                                                                                          decoration: BoxDecoration(color: Color(0xffde1515), borderRadius: BorderRadius.circular(4)),
                                                                                          child: Center(
                                                                                            child: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'user_home_page_move_to_offer'), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14))),
                                                                                          )),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }),
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                                width:
                                                                    widthOfScreen,
                                                                height:
                                                                    ScreenUtil()
                                                                        .setHeight(
                                                                            10),
                                                                color: Colors
                                                                    .grey[200])
                                                          ],
                                                        );
                                                      },
                                                      itemCount: offers.length,
                                                    ),
                                                  );
                                                }),
                                              ),
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
                                    } else {
                                      print('data loading');
                                      return OffersLoadingWidget();
                                    }
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
                                        hintText:
                                            ArabDealLocalization.of(context)
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
                                          searchOffer =
                                              Provider.of<SearchOffer>(context,
                                                  listen: false);
                                          searchOffer.searchAndReturn(
                                              listOfOffers: offersFromInternet,
                                              currentText: currentText
                                                  .trimRight()
                                                  .trimLeft());
                                          bool result =
                                              await AddSearchHistoryHttpService
                                                  .addSearchHistroy(
                                                      currentText);
                                        }
                                      }
                                    }),
                                width: widthOfScreen,
                                height: ScreenUtil().setHeight(60)),
                          ),
                        ],
                      ),
                    );
                  } else
                    return Column(
                      children: [
                        NoInternetConnectionWidget(),
                      ],
                    );
                } else {
                  print('connectivity loading');
                  return OffersLoadingWidget();
                }
              }),
        ));
  }

  void goToTheTopIndex() {
    if (widget.offersAreLoaded)
      _scrollController.animateTo(0,
          duration: Duration(milliseconds: 10), curve: Curves.bounceInOut);
  }

  void incrementCommentsNumber(int index) {
    setState(() {
      offers[index].commentsNumber++;
    });
  }

  void decrementCommentsNumber(int index) {
    setState(() {
      offers[index].commentsNumber--;
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

  void incrementLikesNumber(int index) {
    setState(() {
      offers[index].likeNumber++;
    });
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

  @override
  void dispose() {
    print('dispose method called');
    super.dispose();
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
            height: ScreenUtil().setHeight(100),
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
            height: ScreenUtil().setHeight(200),
          ),
          Loading(),
        ],
      ),
    );
  }
}
