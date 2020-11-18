import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/search_offer_service.dart';
import 'package:ArabDealProject/services/http_services/delete_offer_by_admin_http_service.dart';
import 'package:ArabDealProject/language/localization/check_locale_function.dart';
import 'package:ArabDealProject/objects/offer.dart';
import 'package:ArabDealProject/services/http_services/get_offers_to_approve_http_service.dart';
import 'package:ArabDealProject/ui/admin_section/admin_add_offer.dart';
import 'package:ArabDealProject/ui/admin_section/admin_confirm_offer_page.dart';
import 'package:ArabDealProject/ui/shared/cached__image_from_network.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/image_network.dart';
import 'package:ArabDealProject/ui/shared/loading.dart';
import 'package:ArabDealProject/ui/shared/no_internet_connection.dart';
import 'package:ArabDealProject/ui/shared/user_logged_in_drawer.dart';
import 'package:ArabDealProject/ui/user_section/user_add_offer_page.dart';
import 'package:ArabDealProject/ui/user_section/user_offer_page.dart';
import 'package:ArabDealProject/ui/shared/custom_app_bar.dart';
import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class AdminApproveOffersPage extends StatefulWidget {
   bool offersAreLoaded ;
   AdminApproveOffersPage(){
     offersAreLoaded=false;
   }
  _AdminApproveOffersPageState createState() => _AdminApproveOffersPageState();
}

class _AdminApproveOffersPageState extends State<AdminApproveOffersPage> {
  double widthOfScreen;
  double heightOfScreen;
 
  final searchController = TextEditingController();
  SearchOffer searchOffer;
  List<Offer> offers = [];
  List<Offer> offersFromInternet = [];
  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    ScreenUtil.init(context,width:widthOfScreen,height:heightOfScreen);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    print('build called');
    return Scaffold(
        backgroundColor: Colors.grey[200],
        endDrawer: DrawerWrapper(context),
        key: _scaffoldKey,
        body: ChangeNotifierProvider(
          create: (context) => SearchOffer(),
          child: FutureBuilder(
              future: checkInternetConnectivity(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data == true) {
                    if (widget.offersAreLoaded) offers = offersFromInternet;
                    print('data is already loaded');
                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                          widget.offersAreLoaded
                              ? Column(
                                  children: [
                                    CustomAppBar(scaffoldKey: _scaffoldKey),
                                    Container(
                                      margin: EdgeInsets.only(top: 20),
                                      width: widthOfScreen,
                                      height: heightOfScreen - 120,
                                      child: Consumer<SearchOffer>(
                                          builder: (context, provider, child) {
                                        if (searchController.text
                                                    .trim()
                                                    .length !=
                                                0 &&
                                            provider.offers != null)
                                          offers = provider.offers;
                                        return ListView.separated(
                                          itemBuilder: (context, index) {
                                            Offer offer = offers[index];
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        //you have to pass the offer object to show its details
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AdminAddOffer(
                                                                          isAddOffer:
                                                                              false,
                                                                              index:index,
                                                                              updateOffer: updateItem,
                                                                          passedOffer:
                                                                              offers[index],
                                                                        )));
                                                      },
                                                      child: Container(
                                                        margin: EdgeInsets.only(
                                                            left: 15,
                                                            right: 15),
                                                        width:
                                                            widthOfScreen - 30,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                            color:
                                                                Colors.white),
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .end,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              40.0,
                                                                          top:
                                                                              10,
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              40),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                              Icons.person_pin,
                                                                              size: 30),
                                                                          (offers[index].user!=null)?Text(offers[index].user.firstName + " " + offers[index].user.lastName, style: TextStyle(fontSize: 15))
                                                                              :SizedBox.shrink()
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              8.0,
                                                                          left:
                                                                              8.0),
                                                                      child:(offers[index].dateAr!=null&&offers[index].date!=null)? Text(
                                                                          checkWhetherArabicLocale(context)
                                                                              ? offers[index].dateAr
                                                                              : offers[index].date,
                                                                          style: TextStyle(fontSize: ScreenUtil().setSp(11))):SizedBox.shrink(),
                                                                    ),
                                                                  ]),
                                                              Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsets
                                                                        .only(
                                                                            top:
                                                                                10),
                                                                    child: Hero(
                                                                      tag: index
                                                                          .toString(),
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            140,
                                                                        height:
                                                                            100,
                                                                        child: Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 5.0, right: 5),
                                                                            child: (offers[index].imageUrl?.isNotEmpty??false)
                                                                             ? CachedImageFromNetwork(urlImage: offers[index].imageUrl[0]) 
                                                                             : SizedBox.shrink()),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                13.0,
                                                                            right:
                                                                                10),
                                                                        child: ConstrainedBox(
                                                                            constraints: BoxConstraints(maxWidth: 140),
                                                                            child: ((checkWhetherArabicLocale(context)&&offer.offerTitleArabic!=null)||(!checkWhetherArabicLocale(context)&&offer.offerTitleGerman!=null))?Text(
                                                                              !checkWhetherArabicLocale(context) ? offer.offerTitleGerman : offer.offerTitleArabic,
                                                                              style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18)),
                                                                              textAlign: TextAlign.center,
                                                                            ):SizedBox.shrink()),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                10.0,
                                                                            right:
                                                                                10),
                                                                        child:
                                                                            Container(
                                                                          constraints:
                                                                              BoxConstraints(maxWidth: 140),
                                                                          child:((checkWhetherArabicLocale(context)&&offer.offerShortDescriptionArabic!=null)||(!checkWhetherArabicLocale(context)&&offer.offerShortDescriptionGerman!=null))? Text(
                                                                              !checkWhetherArabicLocale(context) ? offer.offerShortDescriptionGerman : offer.offerShortDescriptionArabic,
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(color: Colors.grey[800], fontSize: ScreenUtil().setSp(16))):SizedBox.shrink(),
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.only(top: 10.0),
                                                                        child:
                                                                            Container(
                                                                          constraints:
                                                                              BoxConstraints(maxWidth: 190),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 4.0),
                                                                                child: (offer.priceBefore!=null)?Text('${offer.priceBefore.toString()}\$', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[800], fontSize: ScreenUtil().setSp(14))):SizedBox.shrink(),
                                                                              ),
                                                                              SizedBox(width: 5),
                                                                               Padding(
                                                                                padding: const EdgeInsets.only(top: 4.0),
                                                                                child: (offer.priceAfter!=null)?Text(offer.priceAfter.toString() + '\$', style: TextStyle(color: Color(0xffde1515), fontSize: ScreenUtil().setSp(14))):SizedBox.shrink(),
                                                                              ),
                                                                              SizedBox(width: 5),
                                                                             Padding(
                                                                                padding: const EdgeInsets.only(top: 4.0),
                                                                                child:(offer.percent!=null) ?
                                                                                Text('${offer.percent.toString()}%', style: TextStyle(color: Colors.grey[800], fontSize: ScreenUtil().setSp(14))):SizedBox.shrink(),
                                                                              ),
                                                                              SizedBox(width: 5),
                                                                              Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'admin_offers_page_discount'))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ), // )
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            5),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                      
                                                                  
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        bool
                                                                            resultOfDeleting =
                                                                            await DeleteOfferByAdminHttpService.deleteOfferByAdmin(offers[index].id);
                                                                        if (resultOfDeleting) {
                                                                          print(
                                                                              'offer Deleted');
                                                                          setState(
                                                                              () {
                                                                            offers.removeAt(index);
                                                                          });
                                                                        } else
                                                                          print(
                                                                              'something went wrong');
                                                                      },
                                                                      child: Container(
                                                                          width:
                                                                              70,
                                                                          height:
                                                                              50,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.grey[
                                                                                  300],
                                                                              borderRadius: BorderRadius.circular(
                                                                                  4)),
                                                                          child: Icon(
                                                                              Icons.delete_forever,
                                                                              color: Colors.black,
                                                                              size: 17)),
                                                                    ),
                                                                   
                                                                  
                                                                  
                                                                   
                                                                   
                                                                  ],
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                          physics: BouncingScrollPhysics(),
                                          itemCount: offers.length,
                                          separatorBuilder: (context, index) {
                                            return Container(
                                                width: widthOfScreen,
                                                height: 10,
                                                color: Colors.grey[200]);
                                          },
                                        );
                                      }),
                                    )
                                  ],
                                )
                              : FutureBuilder(
                                  future: GetOffersToApproveHttpService.getOffersToApprove(),
                                  builder: (context, snapshot) {
                                    
                                    if(snapshot.connectionState==ConnectionState.done){
                                       if (snapshot.hasData) {
                                      print('data just loaded ');
                                      offersFromInternet = snapshot.data;
                                      widget.offersAreLoaded = true;
                                      offers = offersFromInternet;
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
                                              return ListView.separated(
                                                itemBuilder: (context, index) {
                                                  Offer offer = offers[index];
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              //you have to pass the offer object to show its details
                                                                Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AdminAddOffer(
                                                                          isAddOffer:
                                                                              false,
                                                                              index:index,
                                                                              updateOffer: updateItem,
                                                                          passedOffer:
                                                                              offers[index],
                                                                        )));
                                                            },
                                                            child: Container(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      left: 15,
                                                                      right:
                                                                          15),
                                                              width:
                                                                  widthOfScreen -
                                                                      30,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10)),
                                                                  color: Colors
                                                                      .white),
                                                              child: Container(
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
                                                                            padding: const EdgeInsets.only(
                                                                                right: 40.0,
                                                                                top: 10,
                                                                                bottom: 10,
                                                                                left: 40),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                  Container(child:(offers[index].user?.imageUrl!=null??false)? CachedImageFromNetwork(urlImage:offers[index].user.imageUrl):SizedBox.shrink(),width:30,height:30),
                                                                          SizedBox(width:10),
                                                                                (offers[index].user?.firstName != null??false) ?
                                                                                 Text(offers[index].user.firstName + " " + offers[index].user.lastName, style: TextStyle(fontSize: ScreenUtil().setSp(15))) 
                                                                                 : SizedBox.shrink()
                                                                              ],
                                                                            ),
                                                                          ),
                                                                           Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          right:
                                                                              8.0,
                                                                          left:
                                                                              8.0),
                                                                      child:(offers[index].dateAr!=null&&offers[index].date!=null)? Text(
                                                                          checkWhetherArabicLocale(context)
                                                                              ? offers[index].dateAr
                                                                              : offers[index].date,
                                                                          style: TextStyle(fontSize: ScreenUtil().setSp(11))):SizedBox.shrink(),
                                                                    ),
                                                                        ]),
                                                                    Row(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(top: 10),
                                                                          child:
                                                                              Hero(
                                                                            tag:
                                                                                index.toString(),
                                                                            child:
                                                                                 Container(
                                                                              width: 140,
                                                                              height: 100,
                                                                              child: Padding(padding: const EdgeInsets.only(left: 5.0, right: 5), child: (offers[index].imageUrl?.isNotEmpty??false) ? CachedImageFromNetwork(urlImage: offers[index].imageUrl[0]) : SizedBox.shrink()),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 13.0, right: 10),
                                                                              child: ConstrainedBox(
                                                                            constraints: BoxConstraints(maxWidth: 140),
                                                                            child: ((checkWhetherArabicLocale(context)&&offer.offerTitleArabic!=null)||(!checkWhetherArabicLocale(context)&&offer.offerTitleGerman!=null))?Text(
                                                                              !checkWhetherArabicLocale(context) ? offer.offerTitleGerman : offer.offerTitleArabic,
                                                                              style: TextStyle(color: Colors.grey[900], fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(18)),
                                                                              textAlign: TextAlign.center,
                                                                            ):SizedBox.shrink()),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 10.0, right: 10),
                                                                              child:  Container(
                                                                          constraints:
                                                                              BoxConstraints(maxWidth: 140),
                                                                          child:((checkWhetherArabicLocale(context)&&offer.offerShortDescriptionArabic!=null)||(!checkWhetherArabicLocale(context)&&offer.offerShortDescriptionGerman!=null))? Text(
                                                                              !checkWhetherArabicLocale(context) ? offer.offerShortDescriptionGerman : offer.offerShortDescriptionArabic,
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(color: Colors.grey[800], fontSize: ScreenUtil().setSp(16))):SizedBox.shrink(),
                                                                        ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 10.0),
                                                                              child: Container(
                                                                                constraints: BoxConstraints(maxWidth: 190),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                     Padding(
                                                                                padding: const EdgeInsets.only(top: 4.0),
                                                                                child: (offer.priceBefore!=null)?Text('${offer.priceBefore.toString()}\$', style: TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey[800], fontSize: ScreenUtil().setSp(14))):SizedBox.shrink(),
                                                                              ),
                                                                                    SizedBox(width: 5),
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.only(top: 4.0),
                                                                                      child: Text(offer.priceAfter.toString() + '\$', style: TextStyle(color: Color(0xffde1515), fontSize: ScreenUtil().setSp(14))),
                                                                                    ),
                                                                                    SizedBox(width: 5),
                                                                                     Padding(
                                                                                padding: const EdgeInsets.only(top: 4.0),
                                                                                child:(offer.percent!=null) ?
                                                                                Text('${offer.percent.toString()}%', style: TextStyle(color: Colors.grey[800], fontSize: ScreenUtil().setSp(14))):SizedBox.shrink(),
                                                                              ),
                                                                                    SizedBox(width: 5),
                                                                                    Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'admin_offers_page_discount'))
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ), // )
                                                                      ],
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              10.0,
                                                                          bottom:
                                                                              5),
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                         
                                                                         
                                                                          SizedBox(
                                                                              width: 5),
                                                                          InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              bool resultOfDeleting = await DeleteOfferByAdminHttpService.deleteOfferByAdmin(offers[index].id);
                                                                              if (resultOfDeleting) {
                                                                                print('offer Deleted');
                                                                                setState(() {
                                                                                  offers.removeAt(index);
                                                                                });
                                                                              } else
                                                                                print('something went wrong');
                                                                            },
                                                                            child: Container(
                                                                                width: 70,
                                                                                height: 50,
                                                                                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                                                                                child: Icon(Icons.delete_forever, color: Colors.black, size: 17)),
                                                                          ),
                                                                        
                                                                       
                                                                        ],
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  );
                                                },
                                                physics:
                                                    BouncingScrollPhysics(),
                                                itemCount: offers.length,
                                                separatorBuilder:
                                                    (context, index) {
                                                  return Container(
                                                      width: widthOfScreen,
                                                      height: 10,
                                                      color: Colors.grey[200]);
                                                },
                                              );
                                            }),
                                          )
                                        ],
                                      );
                                    } else {
                                      print('data loading');
                                      return OffersLoadingWidget();
                                    }
                                    }else{
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
                                  onFieldSubmitted: (currentText) {
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
  void updateItem(int index, Offer offer) {
    setState(() {
      offers[index] = offer;
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

