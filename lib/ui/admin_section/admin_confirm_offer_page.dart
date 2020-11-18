// there is no need for initial values in this page

import 'package:ArabDealProject/language/localization/check_locale_function.dart';
import 'package:ArabDealProject/main.dart';
import 'package:ArabDealProject/objects/category.dart';
import 'package:ArabDealProject/objects/offer.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:ArabDealProject/services/http_services/add_offer_by_admin_http_service.dart';
import 'package:ArabDealProject/services/http_services/add_offer_by_user_http_service.dart';
import 'package:ArabDealProject/services/http_services/confirm_offer_by_admin_http_service.dart';
import 'package:ArabDealProject/services/http_services/get_categories_http_service.dart';
import 'package:ArabDealProject/services/http_services/upload_image_to_server_http_service.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/image_network.dart';
import 'package:ArabDealProject/ui/shared/no_internet_connection.dart';
import 'package:ArabDealProject/ui/shared/custom_app_bar.dart';
import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AdminConfirmOffer extends StatefulWidget {
  AdminConfirmOffer({this.isAddOffer, this.passedOffer});
  final bool isAddOffer;
  final Offer passedOffer;
  _AdminConfirmOfferState createState() => _AdminConfirmOfferState();
}

class _AdminConfirmOfferState extends State<AdminConfirmOffer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double heightOfScreen;
  double widthOfScreen;
  bool showCategoriesDropDown = false;
  bool categoryIsPicked = false;
  Category selectedCategory;
  bool firstTimeCategoriesLoaded = true;
  List<Category> categories;
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  final formKey = GlobalKey<FormState>();
  FocusNode arabicTitleFocusNode = new FocusNode();
  FocusNode germanTitleFocusNode = new FocusNode();
  FocusNode arabicDesFocusNode = new FocusNode();
  FocusNode germanDesFocusNode = new FocusNode();
  FocusNode arabicDetailsFocusNode = new FocusNode();
  FocusNode germanDetailsFocusNode = new FocusNode();
  FocusNode videoURLFocusNode = new FocusNode();
  FocusNode offerURLFocusNode = new FocusNode();
  FocusNode oldPriceFocusNode = new FocusNode();
  FocusNode newPriceFocusNode = new FocusNode();
  FocusNode discountFocusNode = new FocusNode();
  Offer offer;
  @override
  void initState() {
    super.initState();
    offer = Offer();
    showCategoriesDropDown = true;
  }

  @override
  Widget build(BuildContext context) {
    heightOfScreen = MediaQuery.of(context).size.height;
    widthOfScreen = MediaQuery.of(context).size.height;
    ScreenUtil.init(context,width:widthOfScreen,height:heightOfScreen);
      print(widget.isAddOffer);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: DrawerWrapper(context),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(scaffoldKey: _scaffoldKey),
              FutureBuilder(
                  future: checkInternetConnectivity(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data == true) {
                        return Container(
                          width: widthOfScreen,
                          height: heightOfScreen - 100,
                          child: SingleChildScrollView(
                            child: Container(
                              width: widthOfScreen,
                              height: 1650,
                              color: Colors.white,
                              child: Container(
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    InkWell(
                                      child: AnimatedCrossFade(
                                          firstChild: Container(
                                            width: 200,
                                            height: 60,
                                            child: Center(
                                                child: Text(
                                                    'Click to select a category',
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold))),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
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
                                                        color:
                                                            Colors.grey[400])),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                          ),
                                          secondChild: Container(
                                              width: 200,
                                              height: 60,
                                              alignment: Alignment.center,
                                              constraints: new BoxConstraints(
                                                  maxWidth: 250, maxHeight: 60),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  color: Colors.grey[200],
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
                                                child: FutureBuilder(
                                                    future:
                                                        GetCategoriesHttpService
                                                            .getCategories(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        if (firstTimeCategoriesLoaded) {
                                                          categories =
                                                              snapshot.data;
                                                          firstTimeCategoriesLoaded =
                                                              false;
                                                          selectedCategory =
                                                              categories[0];
                                                          print('hello');
                                                          selectedCategory = categories
                                                              .firstWhere((element) =>
                                                                  widget
                                                                      .passedOffer
                                                                      .category
                                                                      .id ==
                                                                  element.id);
                                                        }
                                                        return IgnorePointer(
                                                          ignoring: true,
                                                          child:
                                                              DropdownButtonHideUnderline(
                                                            child:
                                                                DropdownButton<
                                                                    Category>(
                                                              items: categories
                                                                  .map((category) =>
                                                                      DropdownMenuItem<
                                                                          Category>(
                                                                        value:
                                                                            category,
                                                                        child:
                                                                            Text(
                                                                          checkWhetherArabicLocale(context)
                                                                              ? category.nameArabic
                                                                              : category.nameGerman, style: TextStyle(fontSize: ScreenUtil().setSp(17)),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                              
                                                                        ),
                                                                      ))
                                                                  .toList(),
                                                              onChanged: (_) {
                                                                showToast(
                                                                    'You can not change the category',
                                                                    context:
                                                                        context,
                                                                    animation:
                                                                        StyledToastAnimation
                                                                            .slideFromBottom,
                                                                    reverseAnimation:
                                                                        StyledToastAnimation
                                                                            .slideToBottom,
                                                                    startOffset:
                                                                        Offset(0.0,
                                                                            3.0),
                                                                    reverseEndOffset:
                                                                        Offset(0.0,
                                                                            3.0),
                                                                    position:
                                                                        StyledToastPosition
                                                                            .bottom,
                                                                    curve: Curves
                                                                        .elasticOut);
                                                              },
                                                              value:
                                                                  selectedCategory,
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      return Text('Loading',
                                                          style: TextStyle(
                                                              fontSize: ScreenUtil().setSp(15),
                                                              color: Colors
                                                                  .grey[700]));
                                                    }),
                                              )),
                                          crossFadeState:
                                              (showCategoriesDropDown)
                                                  ? CrossFadeState.showSecond
                                                  : CrossFadeState.showFirst,
                                          duration: Duration(milliseconds: 500)),
                                      onTap: () {
                                        setState(() {
                                          showCategoriesDropDown = true;
                                        });
                                      },
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: 250,
                                      height: 60,
                                      child: TextFormField(
                                          initialValue: !(widget.isAddOffer)
                                              ? widget
                                                  .passedOffer.offerTitleArabic
                                              : "",
                                          focusNode: arabicTitleFocusNode,
                                          validator: (arabicTitle) {
                                            return arabicTitle.isEmpty
                                                ? ArabDealLocalization.of(
                                                        context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_field_cant_be_empty')
                                                : null;
                                          },
                                          onTap: _arabicTitleFocus,
                                          onSaved: (arabicTitle) {
                                            offer.offerTitleArabic =
                                                arabicTitle;
                                          },
                                          enabled: false,
                                          decoration: _getDecorationOfTextField(
                                              hintText: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'admin_add_offer_arabic_title'),
                                              focusNode: arabicTitleFocusNode)),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: 250,
                                      height: 60,
                                      child: TextFormField(
                                        initialValue: !(widget.isAddOffer)
                                            ? widget
                                                .passedOffer.offerTitleGerman
                                            : "",
                                        validator: (offerTitleGerman) {
                                          return offerTitleGerman.isEmpty
                                              ? ArabDealLocalization.of(context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'all_pages_field_cant_be_empty')
                                              : null;
                                        },
                                        onTap: _germanTitleFocus,
                                        onSaved: (germanTitle) {
                                          offer.offerTitleGerman = germanTitle;
                                        },
                                        enabled: false,
                                        decoration: _getDecorationOfTextField(
                                            hintText: ArabDealLocalization.of(
                                                    context)
                                                .getTranslatedWordByKey(
                                                    key:
                                                        'admin_add_offer_german_title'),
                                            focusNode: germanTitleFocusNode),
                                        focusNode: germanTitleFocusNode,
                                      ),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: 250,
                                      height: 80,
                                      child: TextFormField(
                                          maxLines: 10,
                                          initialValue: !(widget.isAddOffer)
                                              ? widget.passedOffer
                                                  .offerShortDescriptionArabic
                                              : "",
                                          validator:
                                              (offerShortDescriptionArabic) {
                                            return offerShortDescriptionArabic
                                                    .isEmpty
                                                ? ArabDealLocalization.of(
                                                        context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_field_cant_be_empty')
                                                : null;
                                          },
                                          enabled: false,
                                          onTap: _arabicDesFocus,
                                          onSaved: (arabicShortDescription) {
                                            offer.offerShortDescriptionArabic =
                                                arabicShortDescription;
                                          },
                                          focusNode: arabicDesFocusNode,
                                          textInputAction: TextInputAction.done,
                                          decoration: _getDecorationOfTextField(
                                              hintText: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'admin_add_offer_arabic_short_description'),
                                              focusNode: arabicDesFocusNode)),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: 250,
                                      height: 80,
                                      child: TextFormField(
                                          maxLines: 10,
                                          initialValue: !(widget.isAddOffer)
                                              ? widget.passedOffer
                                                  .offerShortDescriptionGerman
                                              : "",
                                          validator:
                                              (offerShortDescriptionGerman) {
                                            return offerShortDescriptionGerman
                                                    .isEmpty
                                                ? ArabDealLocalization.of(
                                                        context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_field_cant_be_empty')
                                                : null;
                                          },
                                          textInputAction: TextInputAction.done,
                                          onTap: _germanDesFocus,
                                          enabled: false,
                                          onSaved: (germanShortDescription) {
                                            offer.offerShortDescriptionGerman =
                                                germanShortDescription;
                                          },
                                          focusNode: germanDesFocusNode,
                                          decoration: _getDecorationOfTextField(
                                              hintText: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'admin_add_offer_german_short_description'),
                                              focusNode: germanDesFocusNode)),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: 250,
                                      height: 80,
                                      child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          initialValue: !(widget.isAddOffer)
                                              ? widget.passedOffer
                                                  .offerDescriptionArabic
                                              : "",
                                          validator: (offerDescriptionArabic) {
                                            return offerDescriptionArabic
                                                    .isEmpty
                                                ? ArabDealLocalization.of(
                                                        context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_field_cant_be_empty')
                                                : null;
                                          },
                                          enabled: false,
                                          onTap: _arabicDetailsFocus,
                                          onSaved: (arabicDetails) {
                                            offer.offerDescriptionArabic =
                                                arabicDetails;
                                          },
                                          focusNode: arabicDetailsFocusNode,
                                          decoration: _getDecorationOfTextField(
                                              hintText: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'admin_add_offer_arabic_details'),
                                              focusNode:
                                                  arabicDetailsFocusNode)),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: 250,
                                      height: 80,
                                      child: TextFormField(
                                          initialValue: !(widget.isAddOffer)
                                              ? widget.passedOffer
                                                  .offerDescriptionGerman
                                              : "",
                                          textInputAction: TextInputAction.done,
                                          validator: (offerDescriptionGerman) {
                                            return offerDescriptionGerman
                                                    .isEmpty
                                                ? ArabDealLocalization.of(
                                                        context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_field_cant_be_empty')
                                                : null;
                                          },
                                          enabled: false,
                                          onTap: _germanDetailsFocus,
                                          onSaved: (germanDetails) {
                                            offer.offerDescriptionGerman =
                                                germanDetails;
                                          },
                                          focusNode: germanDetailsFocusNode,
                                          decoration: _getDecorationOfTextField(
                                              hintText: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'admin_add_offer_german_details'),
                                              focusNode:
                                                  germanDetailsFocusNode)),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: 250,
                                      height: 80,
                                      child: TextFormField(
                                          maxLines: 10,
                                          initialValue: !(widget.isAddOffer)
                                              ? widget.passedOffer.videoUrl ??
                                                  ""
                                              : "",
                                          validator: (videoUrl) {
                                            return videoUrl.isEmpty
                                                ? ArabDealLocalization.of(
                                                        context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_field_cant_be_empty')
                                                : null;
                                          },
                                          textInputAction: TextInputAction.done,
                                          onTap: _videoURLFocus,
                                          onSaved: (videoURL) {
                                            offer.videoUrl = videoURL;
                                          },
                                          enabled: false,
                                          focusNode: videoURLFocusNode,
                                          decoration: _getDecorationOfTextField(
                                              hintText: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'admin_add_offer_video_url'),
                                              focusNode: videoURLFocusNode)),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: 250,
                                      height: 80,
                                      child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          onTap: _offerURLFocus,
                                          validator: (offerUrl) {
                                            return offerUrl.isEmpty
                                                ? ArabDealLocalization.of(
                                                        context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_field_cant_be_empty')
                                                : null;
                                          },
                                          initialValue: !(widget.isAddOffer)
                                              ? widget.passedOffer.offerUrl
                                              : "",
                                          onSaved: (offerURL) {
                                            offer.offerUrl = offerURL;
                                          },
                                          enabled: false,
                                          focusNode: offerURLFocusNode,
                                          decoration: _getDecorationOfTextField(
                                              hintText: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'admin_add_offer_offer_url'),
                                              focusNode: offerURLFocusNode)),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: 250,
                                      height: 80,
                                      child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.number,
                                          onTap: _oldPriceFocus,
                                          validator: (priceBefore) {
                                            return priceBefore.isEmpty
                                                ? ArabDealLocalization.of(
                                                        context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_field_cant_be_empty')
                                                : null;
                                          },
                                          initialValue: !(widget.isAddOffer)
                                              ? widget.passedOffer.priceBefore
                                                  .toString()
                                              : "",
                                          onSaved: (oldPrice) {
                                            offer.priceBefore =
                                                int.parse(oldPrice);
                                          },
                                          enabled: false,
                                          focusNode: oldPriceFocusNode,
                                          decoration: _getDecorationOfTextField(
                                              hintText: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'admin_add_offer_old_price'),
                                              focusNode: oldPriceFocusNode)),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: 250,
                                      height: 80,
                                      child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          onTap: _newPriceFocus,
                                          initialValue: !(widget.isAddOffer)
                                              ? widget.passedOffer.priceAfter
                                                  .toString()
                                              : "",
                                          keyboardType: TextInputType.number,
                                          validator: (newPrice) {
                                            return newPrice.isEmpty
                                                ? ArabDealLocalization.of(
                                                        context)
                                                    .getTranslatedWordByKey(
                                                        key:
                                                            'all_pages_field_cant_be_empty')
                                                : null;
                                          },
                                          enabled: false,
                                          onSaved: (newPrice) {
                                            offer.priceAfter =
                                                int.parse(newPrice);
                                          },
                                          focusNode: newPriceFocusNode,
                                          decoration: _getDecorationOfTextField(
                                              hintText: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'admin_add_offer_new_price'),
                                              focusNode: newPriceFocusNode)),
                                    ),
                                    SizedBox(height: 30),
                                    Container(
                                      width: 250,
                                      height: 80,
                                      child: TextFormField(
                                          textInputAction: TextInputAction.done,
                                          onTap: _discountFocus,
                                          initialValue: !(widget.isAddOffer)
                                              ? (widget.passedOffer.vouchersCode
                                                          .toString() ==
                                                      "null")
                                                  ? ""
                                                  : widget
                                                      .passedOffer.vouchersCode
                                                      .toString()
                                              : "",
                                          enabled: false,
                                          focusNode: discountFocusNode,
                                          decoration: _getDecorationOfTextField(
                                              hintText: ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'admin_add_offer_discount_code'),
                                              focusNode: discountFocusNode)),
                                    ),
                                    SizedBox(height: 20),
                                    SizedBox(height: 10),
                                    (widget.isAddOffer)
                                        ? SizedBox.shrink()
                                        : Column(
                                            children: [
                                              Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_confirm_offer_current_files'),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: ScreenUtil().setSp(15))),
                                              SizedBox(height: 10),
                                              Container(
                                                width: 300,
                                                height: 100,
                                                decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    border: Border(
                                                        top: BorderSide(
                                                            color: Colors
                                                                .grey[400]),
                                                        bottom: BorderSide(
                                                            color: Colors
                                                                .grey[400]),
                                                        left: BorderSide(
                                                            color: Colors
                                                                .grey[400]),
                                                        right: BorderSide(
                                                            color: Colors
                                                                .grey[400])),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                5))),
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Stack(
                                                        children: [
                                                          ImageFromNetwork(
                                                              url: widget
                                                                      .passedOffer
                                                                      .imageUrl[
                                                                  index]),
                                                          Positioned(
                                                              child: InkWell(
                                                            child: Icon(
                                                                Icons.cancel,
                                                                size: 17,
                                                                color: Colors
                                                                    .grey[500]),
                                                            onTap: () {
                                                              setState(() {});
                                                            },
                                                          )),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  itemCount: widget.passedOffer
                                                      .imageUrl.length,
                                                ),
                                              ),
                                              SizedBox(height: 30),
                                            ],
                                          ),
                                    SizedBox(height: 20),
                                    SizedBox(height: 40),
                                    Container(
                                       // width: 250,
                                        height: 50,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          onPressed: () async {
                                            bool result =
                                                await ConfirmOfferByAdminHttpService
                                                    .confirmOfferByAdmin(
                                                        widget.passedOffer.id);
                                            if (result) {
                                              AwesomeDialog(
                                                      btnOkColor: Colors.green,
                                                      context: context,
                                                      dialogType:
                                                          DialogType.SUCCES,
                                                      animType:
                                                          AnimType.RIGHSLIDE,
                                                      headerAnimationLoop:
                                                          false,
                                                      title: ArabDealLocalization
                                                              .of(context)
                                                          .getTranslatedWordByKey(
                                                              key:
                                                                  'all_pages_success'),
                                                      dismissOnBackKeyPress:
                                                          false,
                                                      dismissOnTouchOutside:
                                                          false,
                                                      desc: ArabDealLocalization
                                                              .of(context)
                                                          .getTranslatedWordByKey(
                                                              key:
                                                                  'admin_confirm_offers_page_offer_confirmed_successfully'),
                                                      isDense: true,
                                                      btnOkOnPress: () {
                                                        App.refrechAction(context);
                                                      })
                                                  .show();

                                            } else {
                                              AwesomeDialog(
                                                      btnOkColor: Colors.red,
                                                      context: context,
                                                      dialogType:
                                                          DialogType.ERROR,
                                                      animType:
                                                          AnimType.RIGHSLIDE,
                                                      headerAnimationLoop:
                                                          false,
                                                      title: ArabDealLocalization
                                                              .of(context)
                                                          .getTranslatedWordByKey(
                                                              key:
                                                                  'all_pages_error'),
                                                      dismissOnBackKeyPress:
                                                          true,
                                                      desc: ArabDealLocalization
                                                              .of(context)
                                                          .getTranslatedWordByKey(
                                                              key:
                                                                  'all_pages_something_went_wrong'),
                                                      isDense: true,
                                                      btnOkOnPress: () {})
                                                  .show();
                                            }
                                          },
                                          child: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_confirm_offers_page_confirm'),
                                              style: TextStyle(
                                                  color: Colors.white,fontSize:ScreenUtil().setSp(16))),
                                          color: Color(0xffde1515),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: [
                            SizedBox(height: 150),
                            NoInternetConnection()
                          ],
                        );
                      }
                    } else
                      return NoInternetConnection();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void _arabicTitleFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(arabicTitleFocusNode);
    });
  }

  void _germanTitleFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(germanTitleFocusNode);
    });
  }

  void _arabicDetailsFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(arabicDetailsFocusNode);
    });
  }

  void _germanDetailsFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(germanDetailsFocusNode);
    });
  }

  void _arabicDesFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(arabicDesFocusNode);
    });
  }

  void _germanDesFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(germanDesFocusNode);
    });
  }

  void _videoURLFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(videoURLFocusNode);
    });
  }

  void _offerURLFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(offerURLFocusNode);
    });
  }

  void _oldPriceFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(oldPriceFocusNode);
    });
  }

  void _newPriceFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(newPriceFocusNode);
    });
  }

  void _discountFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(discountFocusNode);
    });
  }

  InputDecoration _getDecorationOfTextField(
      {@required String hintText, FocusNode focusNode}) {
    return InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(
            color: focusNode.hasFocus ? Color(0xffde1515) : Colors.grey[400]),
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
