import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/language/localization/check_locale_function.dart';
import 'package:ArabDealProject/main.dart';
import 'package:ArabDealProject/objects/offer.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:ArabDealProject/services/data_services/shared_preferences_instance.dart';
import 'package:ArabDealProject/services/http_services/add_comment_http_service.dart';
import 'package:ArabDealProject/services/http_services/add_reply_to_comment_http_service.dart';
import 'package:ArabDealProject/services/http_services/delete_comment_by_admin_http_service.dart';
import 'package:ArabDealProject/services/http_services/delete_reply_by_admin_http_service.dart';
import 'package:ArabDealProject/services/http_services/dislike_comment_http_service.dart';
import 'package:ArabDealProject/services/http_services/get_offer_by_id_for_comments_http_service.dart';
import 'package:ArabDealProject/services/http_services/like_comment_http_service.dart';
import 'package:ArabDealProject/services/http_services/like_offer_http_service.dart';
import 'package:ArabDealProject/services/lunch_rul.dart';
import 'package:ArabDealProject/ui/shared/cached__image_from_network.dart';
import 'package:ArabDealProject/ui/shared/custom_app_bar.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/image_network.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OfferPage extends StatefulWidget {
  final List<String> images;
  final String index;
  final String arabicDescription;
  final String germanDescription;
  final Offer offer;
  final Function likeOfferAction;
  final Function commentOfferAction;
  final Function decrementCommentsNumber;
  OfferPage(
      {this.images,
      this.index,
      this.offer,
      this.arabicDescription,
      this.germanDescription,
      this.likeOfferAction,
      this.commentOfferAction,
      this.decrementCommentsNumber});

  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  double widthOfScreen;
  double heightOfScreen;
  String comment;
  String reply;
  bool commentsLoaded = false;
  Future<Offer> futuredOffer;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(
      debugLabel: "global key for user offer page scaffold");
  final formKeyForComment = GlobalKey<FormState>();
  final formKeyForReply = GlobalKey<FormState>();
  List formKeysForLoadedReplies = [];
  List formKeysForJustLoadedReplies = [];
  final FocusNode commentFocusNode = FocusNode();
  SharedPreferences sharedPreferences;
  Offer offerForComments;
  ScrollController _scrollController;
  ScrollController _scrollControllerForComments;
  double currentPositionOfListView;

  // List<bool> repliesShowed;
  @override
  void initState() {
    // repliesShowed =
    //     List.filled(widget.offer.commentsNumber, false, growable: true);
    _scrollController = ScrollController();
    _scrollControllerForComments = ScrollController();
    sharedPreferences = SharedPreferencesInstance.getSharedPreferences;
    currentPositionOfListView = 0;
    for (int i = 0; i < widget.offer.commentsNumber; i++) {
      formKeysForJustLoadedReplies
          .add(GlobalKey<FormState>(debugLabel: '$i JustLoaded'));
      formKeysForLoadedReplies
          .add(GlobalKey<FormState>(debugLabel: '$i AlreadyLoaded'));
      futuredOffer =
          GetCommentsByOfferIdHttpService.getCommentsByOfferId(widget.offer.id);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    int likesNumber = widget.offer.likeNumber;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    ScreenUtil.init(context, width: widthOfScreen, height: heightOfScreen);
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _scrollController.animateTo(0,
                duration: Duration(seconds: 1), curve: Curves.bounceOut);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(Icons.arrow_upward),
        ),
        endDrawer: DrawerWrapper(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(scaffoldKey: _scaffoldKey),
              Container(
                height: heightOfScreen - 100,
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.white,
                      automaticallyImplyLeading: false,
                      actions: [Container()],
                      leading: InkWell(
                        child: Icon(Icons.arrow_back_ios,
                            color: Colors.black, size: 20),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      expandedHeight: 300,
                      elevation: 10.0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          width: widthOfScreen,
                          height: 300,
                          child: Hero(
                            child: (widget.images.length != 0)
                                ? CachedImageFromNetwork(
                                    urlImage: widget.images[0])
                                : Icon(Icons.image),
                            tag: widget.index,
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        width: widthOfScreen,
                        // height: 1600,
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            ((checkWhetherArabicLocale(context) &&
                                        widget.offer.category.nameArabic !=
                                            null) ||
                                    (!checkWhetherArabicLocale(context) &&
                                        widget.offer.category.nameGerman !=
                                            null))
                                ? Text(
                                    (checkWhetherArabicLocale(context))
                                        ? widget.offer.category.nameArabic
                                        : widget.offer.category.nameGerman,
                                    style: TextStyle(
                                        color: Color(0xffde1515),
                                        fontSize: ScreenUtil().setSp(20),
                                        fontWeight: FontWeight.bold))
                                : SizedBox.shrink(),
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
                            SizedBox(
                              height: 15,
                            ),
                            ((checkWhetherArabicLocale(context) &&
                                        widget.offer.offerTitleArabic !=
                                            null) ||
                                    (!checkWhetherArabicLocale(context) &&
                                        widget.offer.offerTitleGerman != null))
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Text(
                                        checkWhetherArabicLocale(context)
                                            ? widget.offer.offerTitleArabic
                                            : widget.offer.offerTitleGerman,
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: ScreenUtil().setSp(22),
                                            fontWeight: FontWeight.bold)),
                                  )
                                : SizedBox.shrink(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: ((checkWhetherArabicLocale(context) &&
                                          widget.offer
                                                  .offerShortDescriptionArabic !=
                                              null) ||
                                      (!checkWhetherArabicLocale(context) &&
                                          widget.offer
                                                  .offerShortDescriptionGerman !=
                                              null))
                                  ? Text(
                                      checkWhetherArabicLocale(context)
                                          ? widget
                                              .offer.offerShortDescriptionArabic
                                          : widget.offer
                                              .offerShortDescriptionGerman,
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: ScreenUtil().setSp(16),
                                      ))
                                  : SizedBox.shrink(),
                            ),
                            SizedBox(height: 30),

                            Row(
                              children: [
                                (widget.offer.priceAfter != null)
                                    ? Text(
                                        '${widget.offer.priceAfter.toString()}€',
                                        style: TextStyle(
                                            color: Color(0xffde1515),
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenUtil().setSp(30)),
                                      )
                                    : SizedBox.shrink(),
                                SizedBox(
                                  width: 15,
                                ),
                                (widget.offer.priceBefore != null)
                                    ? Text(
                                        '${widget.offer.priceBefore.toString()}€',
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey[800],
                                            fontSize: ScreenUtil().setSp(30)))
                                    : SizedBox.shrink(),
                                SizedBox(width: 15),
                                (widget.offer.percent != null)
                                    ? Text(
                                        '${widget.offer.percent.toString()}%',
                                        style: TextStyle(
                                            color: Colors.grey[800],
                                            fontSize: ScreenUtil().setSp(20)))
                                    : SizedBox.shrink(),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    child: RaisedButton(
                                      onPressed: () async {
                                        if (sharedPreferences
                                            .getBool('openBrowser')) {
                                          bool isConnected =
                                              await checkInternetConnectivity();
                                          if (isConnected) {
                                            if (widget.offer.vouchersCode !=
                                                null)
                                              await FlutterClipboard.copy(
                                                  widget.offer.vouchersCode);

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
                                            await Future.delayed(
                                                Duration(seconds: 2));
                                            await LaunchUrl.launchURL(
                                                widget.offer.offerUrl);
                                          } else {
                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                content: Text(ArabDealLocalization
                                                        .of(context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_no_internet_connection'))));
                                          }
                                        } else {
                                          _showOpenBorwserPermissionDialog(
                                              context, widget.offer.offerUrl);
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      color: Color(0xffde1515),
                                      child: Text(
                                        ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'user_offer_page_move_to_offer'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(15),
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    width: 160,
                                    height: 50,
                                    margin: EdgeInsets.only(left: 10),
                                  ),
                                  Builder(
                                    builder: (context) => Container(
                                      margin: EdgeInsets.only(left: 10),
                                      constraints: BoxConstraints(maxWidth: 80),
                                      height: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: RaisedButton(
                                        onPressed: () async {
                                          bool isConnected =
                                              await checkInternetConnectivity();
                                          if (isConnected) {
                                            User user = FetchUserDataService
                                                .fetchUser();
                                            if (user != null) {
                                              int result =
                                                  await LikeOfferHttpService
                                                      .likeOffer(widget.offer);
                                              if (result == 1) {
                                                setState(() {
                                                  // widget.offer.likeNumber++;
                                                  widget.likeOfferAction(
                                                      int.parse(widget.index));
                                                  print('like');
                                                });
                                              } else if (result == 0) {
                                                setState(() {
                                                  widget.offer.likeNumber--;
                                                  // widget.
                                                  //   print('dislike');
                                                });
                                              } else {
                                                Scaffold.of(context).showSnackBar(SnackBar(
                                                    content: Text(
                                                        ArabDealLocalization.of(
                                                                context)
                                                            .getTranslatedWordByKey(
                                                                key:
                                                                    'all_pages_something_went_wrong'),
                                                        style: TextStyle(
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                        15)))));
                                              }
                                            } else {
                                              Scaffold.of(context).showSnackBar(SnackBar(
                                                  content: Text(
                                                      ArabDealLocalization.of(
                                                              context)
                                                          .getTranslatedWordByKey(
                                                              key:
                                                                  'all_pages_like_offer_condition'),
                                                      style: TextStyle(
                                                          fontSize: ScreenUtil()
                                                              .setSp(15)))));
                                            }
                                          } else {
                                            // show not connected
                                            Scaffold.of(context).showSnackBar(SnackBar(
                                                content: Text(ArabDealLocalization
                                                        .of(context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_no_internet_connection'))));
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/heart.svg',
                                                width: 20,
                                                height: 20,
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 4),
                                              Text(likesNumber.toString(),
                                                  style: TextStyle(
                                                      fontSize: ScreenUtil()
                                                          .setSp(12)))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width: 60,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4)),
                                    child: RaisedButton(
                                      onPressed: () {
                                        if (sharedPreferences
                                            .getBool('shareOption'))
                                          Share.share(
                                              'https://arabdeals.de/Offer/View/${widget.offer.id}');
                                        else
                                          _showSharePermissionDialog(
                                              context, widget.offer.id);
                                      },
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Container(
                                          //  padding: EdgeInsets.all(10),
                                          child: Icon(
                                        Icons.share,
                                        size: 15,
                                      )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                           (widget.offer.vouchersCode!=null)? Column(
                             children: [
                               SizedBox(height: 20),
                               Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(widget.offer.vouchersCode.toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[700])),
                                    SizedBox(width: 10),
                                    Icon(Icons.cut, size: 15)
                                  ],
                                ),
                             ],
                           ):SizedBox.shrink(),
                            SizedBox(height: 25),
                            Container(
                              constraints:
                                  BoxConstraints(maxWidth: widthOfScreen - 50),
                              margin: EdgeInsets.only(top: 15),
                              child: ((checkWhetherArabicLocale(context) &&
                                          widget.offer.offerDescriptionArabic !=
                                              null) ||
                                      (!checkWhetherArabicLocale(context) &&
                                          widget.offer.offerDescriptionGerman !=
                                              null))
                                  ? Linkify(
                                      maxLines: 100,
                                      softWrap: true,
                                      locale: Localizations.localeOf(context),
                                      text: (checkWhetherArabicLocale(context)
                                          ? widget.offer.offerDescriptionArabic
                                          : widget
                                              .offer.offerDescriptionGerman),
                                      // widget.offer.testDes,
                                      textAlign: TextAlign.center,
                                      linkStyle: TextStyle(color: Colors.red),
                                      options: LinkifyOptions(humanize: true),
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(15),
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold),
                                      onOpen: (link) async {
                                        if (await canLaunch(link.url)) {
                                          await launch(link.url);
                                        } else {
                                          throw 'Could not launch $link';
                                        }
                                      })
                                  : SizedBox.shrink(),
                            ),
                            SizedBox(height: 5),

                            SizedBox(height: 10),
                            // Container(width:widthOfScreen,child:Align(alignment: Alignment.centerRight,child: Icon(Icons.stars)
                            SizedBox(height: 30),
                            Row(
                              children: [
                                Container(
                                    width: 40,
                                    height: 40,
                                    child:
                                        (widget.offer?.user?.imageUrl != null ??
                                                false)
                                            ? ImageFromNetwork(
                                                url: widget.offer.user.imageUrl)
                                            : SizedBox.shrink()),
                                SizedBox(width: 20),
                                (widget.offer.user?.firstName != null ??
                                        false ||
                                            widget.offer.user?.lastName !=
                                                null ??
                                        false)
                                    ? Text(
                                        widget.offer.user.firstName +
                                            ' ' +
                                            widget.offer.user.lastName,
                                        style: TextStyle(
                                          fontSize: ScreenUtil().setSp(20),
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[700],
                                        ))
                                    : SizedBox.shrink()
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),

                            SizedBox(height: 50),
                            Container(
                                width: widthOfScreen,
                                height: 300,
                                child: CarouselSlider.builder(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    viewportFraction: 0.9,
                                    aspectRatio: 1.0,
                                    initialPage: 2,
                                  ),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      width: widthOfScreen,
                                      height: 300,
                                      child: Card(
                                          elevation: 7,
                                          color: Colors.white,
                                          child: (widget.images.length != 0 &&
                                                  widget.images[index] != null)
                                              ? ImageFromNetwork(
                                                  url: widget.images[index],
                                                )
                                              : Icon(Icons.image, size: 25)),
                                    );
                                  },
                                  itemCount: widget.images.length,
                                )),
                            SizedBox(height: 40),
                            Text(
                                ArabDealLocalization.of(context)
                                    .getTranslatedWordByKey(
                                        key:
                                            'user_offer_page_write_comment_label'),
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: ScreenUtil().setSp(20))),
                            SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    ArabDealLocalization.of(context)
                                        .getTranslatedWordByKey(
                                            key: 'user_offer_page_comments'),
                                    style: TextStyle(
                                        color: Color(0xffde1515),
                                        fontWeight: FontWeight.bold,
                                        fontSize: ScreenUtil().setSp(20))),
                                SizedBox(width: 4),
                                (widget.offer.commentsNumber != null)
                                    ? Text(
                                        widget.offer.commentsNumber.toString(),
                                        style: TextStyle(
                                            color: Color(0xffde1515),
                                            fontWeight: FontWeight.bold,
                                            fontSize: ScreenUtil().setSp(20)))
                                    : SizedBox.shrink(),
                              ],
                            ),
                            SizedBox(height: 20),
                            (widget.offer.commentsNumber == 0)
                                ? SizedBox.shrink()
                                : Container(
                                    width: widthOfScreen - 30,
                                    height: 400,
                                    child: Card(
                                      child: FutureBuilder(
                                        future: futuredOffer,
                                        builder: (context, snapshot) {
                                          if (ConnectionState.done ==
                                              snapshot.connectionState) {
                                            if (snapshot.hasData) {
                                              print(snapshot.data);
                                              offerForComments = snapshot.data;
                                              //   _scrollControllerForComments.animateTo(currentPositionOfListView, duration: Duration(milliseconds: 700), curve: Curves.bounceInOut);
                                              return Container(
                                                  child: ListView.builder(
                                                      //   controller: _scrollControllerForComments,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Container(
                                                          width: widthOfScreen -
                                                              120,
                                                          child: Card(
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              8.0),
                                                                      child: Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(width: 10),
                                                                            Container(
                                                                                width: 33,
                                                                                height: 33,
                                                                                child: (offerForComments.offersComments[index]['user']['image_url'] != null)
                                                                                    ? ImageFromNetwork(
                                                                                        url: offerForComments.offersComments[index]['user']['image_url'],
                                                                                      )
                                                                                    : Icon(Icons.person_pin_circle)),
                                                                            SizedBox(width: 10),
                                                                            Container(
                                                                              constraints: BoxConstraints(maxWidth: widthOfScreen - 110),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(top: 8.0),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Column(
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            (offerForComments.offersComments[index]['user']['user_name'] != null) ? Text(offerForComments.offersComments[index]['user']['user_name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(17))) : SizedBox.shrink(),
                                                                                            SizedBox(height: 10),
                                                                                            (offerForComments.offersComments[index]['comment_text'] != null) ? Text(offerForComments.offersComments[index]['comment_text'].toString(), textAlign: TextAlign.start, style: TextStyle(fontSize: ScreenUtil().setSp(15), color: Colors.grey[700])) : SizedBox.shrink(),
                                                                                          ],
                                                                                        ),
                                                                                        (FetchUserDataService.fetchUser()?.userType == "0" ?? false)
                                                                                            ? Builder(
                                                                                                builder: (context) => InkWell(
                                                                                                  child: Icon(Icons.delete, color: Theme.of(context).primaryColor, size: 20),
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
                                                                                                          title: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'offer_page_delete_comment'),
                                                                                                          dismissOnTouchOutside: false,
                                                                                                          onDissmissCallback: () {
                                                                                                            print('dismiss called');
                                                                                                          },
                                                                                                          desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'offer_page_are_you_sure_you_want_to_delete_this_comment'),
                                                                                                          isDense: true,
                                                                                                          btnCancelOnPress: () {},
                                                                                                          btnOkOnPress: () async {
                                                                                                            // currentPositionOfListView=_scrollControllerForComments.position.pixels;
                                                                                                            resultOfDeleting = await DeleteCommentByAdminHttpService.deleteCommentByAdmin(offerForComments.offersComments[index]['id']);
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
                                                                                                                  desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'offer_page_comment_deleted_successfully'),
                                                                                                                  isDense: true,
                                                                                                                  btnOkOnPress: () {
                                                                                                                    setState(() {
                                                                                                                      futuredOffer = GetCommentsByOfferIdHttpService.getCommentsByOfferId(widget.offer.id);
                                                                                                                      widget.decrementCommentsNumber(int.parse(widget.index));
                                                                                                                    });
                                                                                                                  }).show();
                                                                                                            } else
                                                                                                              AwesomeDialog(btnOkColor: Colors.red, context: context, dialogType: DialogType.ERROR, animType: AnimType.RIGHSLIDE, headerAnimationLoop: false, title: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_error'), dismissOnBackKeyPress: true, desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_something_went_wrong'), isDense: true, btnOkOnPress: () {}).show();
                                                                                                          }).show();
                                                                                                    } else {
                                                                                                      Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_no_internet_connection'))));
                                                                                                    }

                                                                                                    // bool result=
                                                                                                    // if(result){
                                                                                                    //   print('comment deleted');
                                                                                                    //   setState(() {/
                                                                                                    //     futuredOffer = GetCommentsByOfferIdHttpService.getCommentsByOfferId(widget.offer.id);
                                                                                                    //     widget.decrementCommentsNumber(int.parse(widget.index));
                                                                                                    //   });
                                                                                                    // }
                                                                                                    // else{
                                                                                                    //   print('something went wrong');
                                                                                                    // }
                                                                                                  },
                                                                                                ),
                                                                                              )
                                                                                            : SizedBox.shrink()
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'offer_page_replies'), style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14))),
                                                                                              SizedBox(width: 3),
                                                                                              (offerForComments.offersComments[index]['number_of_reply'] != null) ? Text(offerForComments.offersComments[index]['number_of_reply'].toString(), style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14))) : SizedBox.shrink()
                                                                                            ],
                                                                                          ),
                                                                                          SizedBox(width: 25),
                                                                                          InkWell(
                                                                                            onTap: () async {
                                                                                              bool isConnected = await checkInternetConnectivity();
                                                                                              if (isConnected) {
                                                                                                User user = FetchUserDataService.fetchUser();
                                                                                                if (user != null) {
                                                                                                  bool result = await LikeCommentHttpService.likeCeomment(commentId: offerForComments.offersComments[index]['id']);
                                                                                                  if (result == null) {
                                                                                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_something_went_wrong'))));
                                                                                                  } else {
                                                                                                    if (result) {
                                                                                                      setState(() {
                                                                                                        offerForComments.offersComments[index]['number_of_likes']++;
                                                                                                      });
                                                                                                    } else {
                                                                                                      setState(() {
                                                                                                        offerForComments.offersComments[index]['number_of_likes']--;
                                                                                                      });
                                                                                                    }
                                                                                                  }
                                                                                                } else {
                                                                                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'user_offer_page_you_need_to_login_to_like_the_comment'))));
                                                                                                }
                                                                                              } else {
                                                                                                Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_no_internet_connection'))));
                                                                                              }
                                                                                            },
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Icon(Icons.thumb_up, color: Theme.of(context).primaryColor, size: 20),
                                                                                                SizedBox(width: 2),
                                                                                                Text(offerForComments.offersComments[index]['number_of_likes'].toString(), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(10)))
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                          SizedBox(width: 20),
                                                                                          InkWell(
                                                                                            onTap: () async {
                                                                                              bool isConnected = await checkInternetConnectivity();
                                                                                              if (isConnected) {
                                                                                                User user = FetchUserDataService.fetchUser();
                                                                                                if (user != null) {
                                                                                                  bool result = await DislikeCommentHttpService.dislikeCeomment(commentId: offerForComments.offersComments[index]['id']);
                                                                                                  if (result == null) {
                                                                                                    Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_something_went_wrong'), style: TextStyle(fontSize: ScreenUtil().setSp(15)))));
                                                                                                  } else {
                                                                                                    if (result) {
                                                                                                      setState(() {
                                                                                                        offerForComments.offersComments[index]['number_of_deslike']++;
                                                                                                      });
                                                                                                    } else {
                                                                                                      setState(() {
                                                                                                        offerForComments.offersComments[index]['number_of_deslike']--;
                                                                                                      });
                                                                                                    }
                                                                                                  }
                                                                                                } else {
                                                                                                  //show you need to login
                                                                                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'user_offer_page_you_need_to_login_to_dislike_the_comment'))));
                                                                                                }
                                                                                              } else {
                                                                                                //show no internet connection
                                                                                                Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_no_internet_connection'))));
                                                                                              }
                                                                                            },
                                                                                            child: Row(
                                                                                              children: [
                                                                                                Icon(Icons.thumb_down, color: Theme.of(context).primaryColor, size: 20),
                                                                                                SizedBox(width: 2),
                                                                                                Text(offerForComments.offersComments[index]['number_of_deslike'].toString(), style: TextStyle(color: Theme.of(context).primaryColor, fontSize: ScreenUtil().setSp(10)))
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  ])
                                                                                ],
                                                                              ),
                                                                            )
                                                                          ]),
                                                                    )
                                                                  ],
                                                                ),
                                                                // repliesShowed[
                                                                //         index]
                                                                //     ?
                                                                Container(
                                                                    width: 300,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Align(
                                                                          alignment: checkWhetherArabicLocale(context)
                                                                              ? Alignment.centerRight
                                                                              : Alignment.centerLeft,
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(horizontal: 20.0),
                                                                            child: (offerForComments.offersComments[index]['reply'] != null)
                                                                                ? Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      ...offerForComments.offersComments[index]['reply'].map((reply) {
                                                                                        return Padding(
                                                                                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                                                                                          child: Column(
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                                children: [
                                                                                                  Row(
                                                                                                    children: [
                                                                                                      (reply['user']['image_url'] != null) ? Container(child: CachedImageFromNetwork(urlImage: reply['user']['image_url']), width: 30, height: 30) : SizedBox.shrink(),
                                                                                                      SizedBox(width: 10),
                                                                                                      (reply['user']['user_name'] != null) ? Text(reply['user']['user_name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(14))) : SizedBox.shrink()
                                                                                                    ],
                                                                                                  ),
                                                                                                  (FetchUserDataService.fetchUser()?.userType == "0" ?? false)
                                                                                                      ? Padding(
                                                                                                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                                                                          child: Builder(
                                                                                                            builder: (context) => InkWell(
                                                                                                              child: Icon(Icons.delete, color: Colors.grey[500], size: 18),
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
                                                                                                                      title: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'offer_page_delete_reply'),
                                                                                                                      dismissOnTouchOutside: false,
                                                                                                                      onDissmissCallback: () {
                                                                                                                        print('dismiss called');
                                                                                                                      },
                                                                                                                      desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'offer_page_are_you_sure_you_want_to_delete_this_reply'),
                                                                                                                      isDense: true,
                                                                                                                      btnCancelOnPress: () {},
                                                                                                                      btnOkOnPress: () async {
                                                                                                                        resultOfDeleting = await DeleteReplyByAdminHttpService.deleteRplayByAdmin(reply['id']);
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
                                                                                                                              desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'offer_page_reply_deleted_successfully'),
                                                                                                                              isDense: true,
                                                                                                                              btnOkOnPress: () {
                                                                                                                                setState(() {
                                                                                                                                  futuredOffer = GetCommentsByOfferIdHttpService.getCommentsByOfferId(widget.offer.id);
                                                                                                                                });
                                                                                                                              }).show();
                                                                                                                        } else
                                                                                                                          AwesomeDialog(btnOkColor: Colors.red, context: context, dialogType: DialogType.ERROR, animType: AnimType.RIGHSLIDE, headerAnimationLoop: false, title: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_error'), dismissOnBackKeyPress: true, desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_something_went_wrong'), isDense: true, btnOkOnPress: () {}).show();
                                                                                                                      }).show();
                                                                                                                } else {
                                                                                                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_no_internet_connection'))));
                                                                                                                }

                                                                                                                // bool result=
                                                                                                                // if(result){
                                                                                                                //   print('comment deleted');
                                                                                                                //   setState(() {/
                                                                                                                //     futuredOffer = GetCommentsByOfferIdHttpService.getCommentsByOfferId(widget.offer.id);
                                                                                                                //     widget.decrementCommentsNumber(int.parse(widget.index));
                                                                                                                //   });
                                                                                                                // }
                                                                                                                // else{
                                                                                                                //   print('something went wrong');
                                                                                                                // }
                                                                                                              },
                                                                                                            ),
                                                                                                          ),
                                                                                                        )
                                                                                                      : SizedBox.shrink()
                                                                                                ],
                                                                                              ),
                                                                                              Padding(
                                                                                                padding: checkWhetherArabicLocale(context) ? EdgeInsets.only(right: 40.0) : EdgeInsets.only(left: 40.0),
                                                                                                child: Text(reply['reply_text'], style: TextStyle(fontSize: ScreenUtil().setSp(12))),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      })
                                                                                    ],
                                                                                  )
                                                                                : SizedBox.shrink(),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        Container(
                                                                          width:
                                                                              300,
                                                                          child:
                                                                              Row(
                                                                            children: [
                                                                              SizedBox(width: 15),
                                                                              Builder(
                                                                                builder: (context) => Container(
                                                                                  child: RaisedButton(
                                                                                      onPressed: () async {
                                                                                        bool isConnected = await checkInternetConnectivity();
                                                                                        if (isConnected) {
                                                                                          User user = FetchUserDataService.fetchUser();
                                                                                          if (user != null) {
                                                                                            if (formKeysForLoadedReplies[index].currentState.validate()) {
                                                                                              formKeysForLoadedReplies[index].currentState.save();
                                                                                              print(reply);
                                                                                              bool result = await AddReplyToCommentHttpService.addReplyToComment(commentId: offerForComments.offersComments[index]['id'], reply: reply);
                                                                                              if (result) {
                                                                                                setState(() {
                                                                                                  futuredOffer = GetCommentsByOfferIdHttpService.getCommentsByOfferId(widget.offer.id);
                                                                                                });
                                                                                              } else
                                                                                                Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_something_went_wrong'), style: TextStyle(fontSize: ScreenUtil().setSp(15)))));
                                                                                            }
                                                                                          } else {
                                                                                            Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_reply_offer_condition'), style: TextStyle(fontSize: ScreenUtil().setSp(15)))));
                                                                                          }
                                                                                        } else {
                                                                                          Scaffold.of(context).showSnackBar(SnackBar(content: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'all_pages_no_internet_connection'))));
                                                                                        }
                                                                                      },
                                                                                      child: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'offer_page_ok'), style: TextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(13))),
                                                                                      color: Theme.of(context).primaryColor),
                                                                                  width: 70,
                                                                                  height: 40,
                                                                                ),
                                                                              ),
                                                                              SizedBox(width: 10),
                                                                              Container(
                                                                                  width: 200,
                                                                                  height: 60,
                                                                                  child: Form(
                                                                                    key: formKeysForLoadedReplies[index],
                                                                                    child: TextFormField(
                                                                                      decoration: _getDecorationOfTextField(
                                                                                        hintText: ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'offer_page_type_your_reply'),
                                                                                      ),
                                                                                      validator: (replyText) {
                                                                                        return replyText.isEmpty ? ArabDealLocalization.of(context).getTranslatedWordByKey(key: 'offer_page_type_your_reply_first') : null;
                                                                                      },
                                                                                      onSaved: (replyText) {
                                                                                        reply = replyText;
                                                                                      },
                                                                                    ),
                                                                                  ))
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            height:
                                                                                10),
                                                                        // InkWell(
                                                                        //     child: Icon(Icons.arrow_drop_up),
                                                                        //     onTap: () {
                                                                        //       setState(() {
                                                                        //        // repliesShowed[index] = false;
                                                                        //       });
                                                                        //     })
                                                                      ],
                                                                    ))
                                                                // : SizedBox
                                                                //     .shrink()
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      itemCount:
                                                          offerForComments
                                                              .commentsNumber));
                                            } else if (snapshot.hasError) {
                                              return Container(
                                                  child: Center(
                                                      child: Text(
                                                          'Something went wrong')));
                                            } else
                                              return Container(
                                                  child: Center(
                                                      child:
                                                          CircularProgressIndicator()));
                                          } else
                                            return Container(
                                                child: Center(
                                                    child:
                                                        CircularProgressIndicator()));
                                        },
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 40),
                            Container(
                                width: widthOfScreen - 10,
                                height: 230,
                                child: Card(
                                  child: Column(
                                    children: [
                                      Container(
                                          margin: EdgeInsets.only(
                                              top: 20, left: 10, right: 10),
                                          height: 100,
                                          width: widthOfScreen - 20,
                                          child: Form(
                                            key: formKeyForComment,
                                            child: TextFormField(
                                                validator: (commentText) {
                                                  return commentText.isEmpty
                                                      ? 'Please type your comment first'
                                                      : null;
                                                },
                                                onSaved: (commentText) {
                                                  comment = commentText;
                                                },
                                                cursorColor: Color(0xffde1515),
                                                focusNode: commentFocusNode,
                                                maxLines: 10,
                                                onTap: _commentTitleFocus,
                                                textInputAction:
                                                    TextInputAction.done,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .grey[400],
                                                                width: 1)),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Color(
                                                                    0xffde1515),
                                                                width: 1)),
                                                    labelText: ArabDealLocalization
                                                            .of(context)
                                                        .getTranslatedWordByKey(
                                                            key:
                                                                'user_offer_page_comment_text_field'),
                                                    labelStyle: TextStyle(
                                                        color: (commentFocusNode
                                                                .hasFocus)
                                                            ? Color(0xffde1515)
                                                            : Colors.grey[400]),
                                                    alignLabelWithHint: false,
                                                    filled: true)),
                                          )),
                                      SizedBox(height: 20),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          children: [
                                            Builder(
                                              builder: (context) => Container(
                                                  width: 130,
                                                  height: 60,
                                                  child: RaisedButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7)),
                                                      ),
                                                      color: Colors.red,
                                                      onPressed: () async {
                                                        bool isConnected =
                                                            await checkInternetConnectivity();
                                                        if (isConnected) {
                                                          User user =
                                                              FetchUserDataService
                                                                  .fetchUser();
                                                          if (user != null) {
                                                            if (formKeyForComment
                                                                .currentState
                                                                .validate()) {
                                                              formKeyForComment
                                                                  .currentState
                                                                  .save();
                                                              print(comment);
                                                              bool result = await AddCommentHttpService
                                                                  .addComment(
                                                                      offerId: widget
                                                                          .offer
                                                                          .id,
                                                                      comment:
                                                                          comment);
                                                              if (result) {
                                                                setState(() {
                                                                  // repliesShowed
                                                                  //     .add(false);
                                                                  futuredOffer =
                                                                      GetCommentsByOfferIdHttpService.getCommentsByOfferId(widget
                                                                          .offer
                                                                          .id);

                                                                  formKeysForJustLoadedReplies.add(GlobalKey<
                                                                          FormState>(
                                                                      debugLabel:
                                                                          '{widget.offer.commentsNumber} JustLoaded'));
                                                                  formKeysForLoadedReplies.add(GlobalKey<
                                                                          FormState>(
                                                                      debugLabel:
                                                                          '{widget.offer.commentsNumber} AlreadyLoaded'));

                                                                  widget.commentOfferAction(
                                                                      int.parse(
                                                                          widget
                                                                              .index));
                                                                });
                                                              }
                                                            }
                                                          } else {
                                                            Scaffold.of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(ArabDealLocalization
                                                                      .of(
                                                                          context)
                                                                  .getTranslatedWordByKey(
                                                                      key:
                                                                          'all_pages_comment_offer_condition')),
                                                            ));
                                                          }
                                                        } else {
                                                          Scaffold.of(context)
                                                              .showSnackBar(SnackBar(
                                                                  content: Text(ArabDealLocalization.of(
                                                                          context)
                                                                      .getTranslatedWordByKey(
                                                                          key:
                                                                              'all_pages_no_internet_connection'))));
                                                        }
                                                      },
                                                      child: Text(
                                                          ArabDealLocalization
                                                                  .of(context)
                                                              .getTranslatedWordByKey(
                                                                  key:
                                                                      'user_offer_page_comment_button'),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize:
                                                                  ScreenUtil()
                                                                      .setSp(
                                                                          14))))),
                                            ),
                                            SizedBox(width: 20),
                                            Container(
                                                width: 130,
                                                height: 60,
                                                child: RaisedButton(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  7)),
                                                    ),
                                                    color: Colors.grey[400],
                                                    onPressed: () {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              FocusNode());
                                                    },
                                                    child: Text(
                                                        ArabDealLocalization.of(
                                                                context)
                                                            .getTranslatedWordByKey(
                                                                key:
                                                                    'user_offer_page_cancel_button'),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                ScreenUtil()
                                                                    .setSp(
                                                                        14))))),
                                          ],
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                        ),
                                      )
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  void _commentTitleFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(commentFocusNode);
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
}

InputDecoration _getDecorationOfTextField({@required String hintText}) {
  return InputDecoration(
      hintText: hintText,
      filled: true,
      hintStyle: TextStyle(fontSize: ScreenUtil().setSp(16)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[400]),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xffde1515)),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ));
}
