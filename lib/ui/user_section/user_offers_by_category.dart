import 'package:ArabDealProject/language/localization/check_locale_function.dart';
import 'package:ArabDealProject/objects/category.dart';
import 'package:ArabDealProject/objects/offer.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:ArabDealProject/services/data_services/search_offer_service.dart';
import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';
import 'package:ArabDealProject/services/http_services/add_search_history_http_serivce.dart';
import 'package:ArabDealProject/services/http_services/get_categories_http_service.dart';
import 'package:ArabDealProject/services/http_services/like_offer_http_service.dart';
import 'package:ArabDealProject/services/http_services/with_provider/get_offers_by_category_http_service.dart';
import 'package:ArabDealProject/services/lunch_rul.dart';
import 'package:ArabDealProject/ui/shared/cached__image_from_network.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/loading.dart';
import 'package:ArabDealProject/ui/shared/no_internet_connection.dart';
import 'package:ArabDealProject/ui/user_section/user_offer_page.dart';
import 'package:ArabDealProject/ui/shared/custom_app_bar.dart';
import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waterfall_flow/waterfall_flow.dart';

class OffersByCategoryPage extends StatefulWidget {
  _OffersByCategoryPageState createState() => _OffersByCategoryPageState();
}

class _OffersByCategoryPageState extends State<OffersByCategoryPage> {
  double widthOfScreen;
  double heightOfScreen;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(
      debugLabel: "global key for offers by cagegory scaffold");
  bool dataFirstLoading = true;
  List<Category> categories;
  List<Offer> offers;
  List<Offer> offersFromInternet;
  Category selectedCategory;
  ScrollController _scrollController;
  SearchOffer searchOffer;
  SharedPreferences sharedPreferences;
  final searchController = TextEditingController();
  @override
  void initState() {
    _scrollController = ScrollController();
    sharedPreferences = SharedPreferencesInstance.getSharedPreferences;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    ScreenUtil.init(context, width: widthOfScreen, height: heightOfScreen);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    GetOffersByCategoryWithProviderHttpService offersProvider;

    return ChangeNotifierProvider(
      create: (context) {
        return GetOffersByCategoryWithProviderHttpService();
      },
      child: ChangeNotifierProvider(
        create: (context) => SearchOffer(),
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (!dataFirstLoading)
                _scrollController.animateTo(0,
                    duration: Duration(seconds: 1), curve: Curves.bounceOut);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(Icons.arrow_upward),
          ),
          backgroundColor: Colors.grey[200],
          endDrawer: DrawerWrapper(context),
          key: _scaffoldKey,
          body: FutureBuilder(
              future: checkInternetConnectivity(),
              builder: (context, snapshot) {
                offersProvider =
                    Provider.of<GetOffersByCategoryWithProviderHttpService>(
                        context,
                        listen: false);
                if (snapshot.hasData) {
                  if (snapshot.data) {
                    return FutureBuilder(
                      future: GetCategoriesHttpService.getCategories(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (dataFirstLoading) {
                            categories = snapshot.data;
                            selectedCategory = categories[0];
                            String categoryId = selectedCategory.id.toString();

                            offersProvider.getOffersByCategory(categoryId);
                            dataFirstLoading = false;
                          }
                          return SingleChildScrollView(
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    CustomAppBar(scaffoldKey: _scaffoldKey),
                                    Container(
                                      margin: EdgeInsets.only(
                                        top: 30,
                                      ),
                                      width: widthOfScreen,
                                      height: heightOfScreen - 130,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 180,
                                              height: 50,
                                              margin: EdgeInsets.only(top: 30),
                                              alignment: Alignment.center,
                                              constraints: new BoxConstraints(
                                                  maxWidth: 250, maxHeight: 60),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  border: Border(
                                                      top: BorderSide(
                                                          color:
                                                              Colors.grey[400]),
                                                      left: BorderSide(
                                                          color:
                                                              Colors.grey[400]),
                                                      right: BorderSide(
                                                          color:
                                                              Colors.grey[400]),
                                                      bottom: BorderSide(
                                                          color: Colors
                                                              .grey[400]))),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 3.0, right: 3.0),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child:
                                                      DropdownButton<Category>(
                                                    //focusColor: Colors.white,
                                                    items: categories
                                                        .map((category) =>
                                                            DropdownMenuItem<
                                                                Category>(
                                                              value: category,
                                                              child: Text(
                                                                checkWhetherArabicLocale(
                                                                        context)
                                                                    ? category
                                                                        .nameArabic
                                                                    : category
                                                                        .nameGerman,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize: ScreenUtil()
                                                                        .setSp(
                                                                            16)),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                              ),
                                                            ))
                                                        .toList(),
                                                    onChanged: (selectedValue) {
                                                      setState(() {
                                                        _scrollController
                                                            .animateTo(0,
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            1),
                                                                curve: Curves
                                                                    .bounceOut);
                                                        selectedCategory =
                                                            selectedValue;

                                                        String categoryId =
                                                            selectedCategory.id
                                                                .toString();
                                                        offersProvider
                                                            .getOffersByCategory(
                                                                categoryId);
                                                      });
                                                      offersProvider
                                                          .dataLoadingAction();
                                                    },
                                                    value: selectedCategory,
                                                  ),
                                                ),
                                              )),
                                          Consumer<
                                              GetOffersByCategoryWithProviderHttpService>(
                                            builder:
                                                (context, provider, child) {
                                              offersFromInternet =
                                                  provider.offers;
                                              offers = offersFromInternet;

                                              if (offers != null) {
                                                return Consumer<SearchOffer>(
                                                    builder: (context, provider,
                                                        child) {
                                                  if (searchController.text
                                                              .trim()
                                                              .length !=
                                                          0 &&
                                                      provider.offers != null)
                                                    offers = provider.offers;
                                                  return Container(
                                                    width: widthOfScreen,
                                                    height:
                                                        heightOfScreen - 220,
                                                    margin: EdgeInsets.only(
                                                        top: 10),
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
                                                });
                                              } else {
                                                return Column(children: [
                                                  Row(),
                                                  SizedBox(height: 100),
                                                  Loading()
                                                ]);
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Positioned(
                                  top: 90,
                                  left: 5,
                                  right: 5,
                                  child: Container(
                                      margin:
                                          EdgeInsets.only(left: 8, right: 8),
                                      child: TextFormField(
                                        controller: searchController,
                                        decoration: InputDecoration(
                                            prefixIcon: Icon(Icons.search),
                                            hintText:
                                                ArabDealLocalization.of(context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_search'),
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
                                            if (currentText.trim().length !=
                                                0) {
                                              searchOffer =
                                                  Provider.of<SearchOffer>(
                                                      context,
                                                      listen: false);
                                              searchOffer.searchAndReturn(
                                                  listOfOffers:
                                                      offersFromInternet,
                                                  currentText: currentText
                                                      .trimRight()
                                                      .trimLeft());
                                              bool result =
                                                  await AddSearchHistoryHttpService
                                                      .addSearchHistroy(
                                                          currentText);
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
                        } else {
                          return _LoadingWidget();
                        }
                      },
                    );
                  } else {
                    return _NoInternetConnectionWidget();
                  }
                } else {
                  return _LoadingWidget();
                }
              }),
        ),
      ),
    );
  }

  Widget _LoadingWidget() {
    return Column(
      children: [
        CustomAppBar(scaffoldKey: _scaffoldKey),
        SizedBox(height: 200),
        Loading(),
      ],
    );
  }

  void incrementCommentsNumber(int index) {
    setState(() {
      offers[index].commentsNumber++;
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

  Widget _NoInternetConnectionWidget() {
    return Column(
      children: [
        CustomAppBar(scaffoldKey: _scaffoldKey),
        SizedBox(height: 120),
        NoInternetConnection()
      ],
    );
  }

  InputDecoration _getDecorationOfTextField(
      {@required String hintText, FocusNode focusNode}) {
    return InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
            color: focusNode.hasFocus ? Color(0xffde1515) : Colors.grey[700]),
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
