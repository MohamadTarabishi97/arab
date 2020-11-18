import 'package:ArabDealProject/language/localization/check_locale_function.dart';
import 'package:ArabDealProject/main.dart';
import 'package:ArabDealProject/objects/category.dart';
import 'package:ArabDealProject/objects/offer.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:ArabDealProject/services/http_services/add_offer_by_admin_http_service.dart';
import 'package:ArabDealProject/services/http_services/edit_offer_by_admin_http_service.dart';
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
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AdminAddOffer extends StatefulWidget {
  AdminAddOffer(
      {this.isAddOffer, this.passedOffer, this.updateOffer, this.index});
  final bool isAddOffer;
  final Offer passedOffer;
  final Function updateOffer;
  final int index;
  _AdminAddOfferState createState() => _AdminAddOfferState();
}

class _AdminAddOfferState extends State<AdminAddOffer> {
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
  }

  @override
  Widget build(BuildContext context) {
    heightOfScreen = MediaQuery.of(context).size.height;
    widthOfScreen = MediaQuery.of(context).size.width;
   ScreenUtil.init(context,width:widthOfScreen,height:heightOfScreen);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    if (!widget.isAddOffer) {
      showCategoriesDropDown = true;
    }
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
                        constraints: BoxConstraints(
                                  minHeight: (widget.isAddOffer) ? 1600 : 1900),//we check whether add offer or edit offer to change the height of the screen because we add old offer's files
                        color: Colors.white,
                        child: Container(
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              InkWell(
                                child: AnimatedCrossFade(
                                    firstChild: Container(
                                      width: 250,
                                      height: 60,
                                      child: Center(
                                          child: Text(
                                              ArabDealLocalization.of(
                                                      context)
                                                  .getTranslatedWordByKey(
                                                      key:
                                                          'all_pages_press_to_select_category'),
                                              style: TextStyle(
                                                  fontSize: ScreenUtil()
                                                      .setSp(13),
                                                  fontWeight: FontWeight
                                                      .normal))),
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
                                                if (snapshot.hasData &&
                                                    showCategoriesDropDown) {
                                                  if (firstTimeCategoriesLoaded) {
                                                    print(
                                                        'fuck youooooooooooooooo');
                                                    categories =
                                                        snapshot.data;
                                                    firstTimeCategoriesLoaded =
                                                        false;
                                                    categoryIsPicked =
                                                        true;
                                                    selectedCategory =
                                                        categories[0];
                                                    if (!widget
                                                        .isAddOffer) {
                                                      selectedCategory = categories
                                                          .firstWhere((element) =>
                                                              widget
                                                                  .passedOffer
                                                                  .category
                                                                  .id ==
                                                              element.id);
                                                    } else
                                                      selectedCategory =
                                                          categories[0];
                                                    print('hello');
                                                  }
                                                  return DropdownButtonHideUnderline(
                                                    child: DropdownButton<
                                                        Category>(
                                                      items: categories
                                                          .map((category) =>
                                                              DropdownMenuItem<
                                                                  Category>(
                                                                value:
                                                                    category,
                                                                child: Text(
                                                                    checkWhetherArabicLocale(context)
                                                                        ? category
                                                                            .nameArabic
                                                                        : category
                                                                            .nameGerman,
                                                                    textAlign: TextAlign
                                                                        .center,
                                                                    style:
                                                                        TextStyle(fontSize: ScreenUtil().setSp(17))),
                                                              ))
                                                          .toList(),
                                                      onChanged:
                                                          (selectedValue) {
                                                        setState(() {
                                                          selectedCategory =
                                                              selectedValue;
                                                          categoryIsPicked =
                                                              true;
                                                        });
                                                      },
                                                      value:
                                                          selectedCategory,
                                                    ),
                                                  );
                                                }
                                                return Text('Loading',
                                                    style: TextStyle(
                                                        fontSize:
                                                            ScreenUtil()
                                                                .setSp(
                                                                    13),
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
                                constraints: BoxConstraints(minHeight:60),
                                child: TextFormField(
                                   maxLines: null,
                                        textInputAction: TextInputAction.newline,
                                    initialValue: !(widget.isAddOffer)
                                        ? widget
                                            .passedOffer.offerTitleArabic
                                        : "",
                                       
                                    focusNode: arabicTitleFocusNode,
                                    // validator: (arabicTitle) {
                                    //   return arabicTitle.isEmpty
                                    //       ? ArabDealLocalization.of(
                                    //               context)
                                    //           .getTranslatedWordByKey(
                                    //               key:
                                    //                   'all_pages_field_cant_be_empty')
                                    //       : null;
                                    // },
                                    onTap: _arabicTitleFocus,
                                    onSaved: (arabicTitle) {
                                      offer.offerTitleArabic =
                                          arabicTitle;
                                    },
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
                                constraints: BoxConstraints(minHeight:60),
                                child: TextFormField(
                                   maxLines: null,
                                        textInputAction: TextInputAction.newline,
                                  initialValue: !(widget.isAddOffer)
                                      ? widget
                                          .passedOffer.offerTitleGerman
                                      : "",
                                  // validator: (offerTitleGerman) {
                                  //   return offerTitleGerman.isEmpty
                                  //       ? ArabDealLocalization.of(context)
                                  //           .getTranslatedWordByKey(
                                  //               key:
                                  //                   'all_pages_field_cant_be_empty')
                                  //       : null;
                                  // },
                                  onTap: _germanTitleFocus,
                                  onSaved: (germanTitle) {
                                    offer.offerTitleGerman = germanTitle;
                                  },
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
                                constraints: BoxConstraints(minHeight:60),
                                child: TextFormField(
                                   maxLines: null,
                                        textInputAction: TextInputAction.newline,
                                    
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
                                    onTap: _arabicDesFocus,
                                    onSaved: (arabicShortDescription) {
                                      offer.offerShortDescriptionArabic =
                                          arabicShortDescription;
                                    },
                                    focusNode: arabicDesFocusNode,
                                   
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
                                constraints: BoxConstraints(minHeight:60),
                                child: TextFormField(
                                   maxLines: null,
                                        textInputAction: TextInputAction.newline,
                                    
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
                                    
                                    onTap: _germanDesFocus,
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
                                 constraints: BoxConstraints(minHeight:60),
                                child: TextFormField(
                                   maxLines: null,
                                        textInputAction: TextInputAction.newline,
                                    initialValue: !(widget.isAddOffer)
                                        ? widget.passedOffer
                                            .offerDescriptionArabic
                                        : "",
                                    // validator: (offerDescriptionArabic) {
                                    //   return offerDescriptionArabic
                                    //           .isEmpty
                                    //       ? ArabDealLocalization.of(
                                    //               context)
                                    //           .getTranslatedWordByKey(
                                    //               key:
                                    //                   'all_pages_field_cant_be_empty')
                                    //       : null;
                                    // },
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
                                 constraints: BoxConstraints(minHeight:60),
                                child: TextFormField(
                                   maxLines: null,
                                        textInputAction: TextInputAction.newline,
                                    initialValue: !(widget.isAddOffer)
                                        ? widget.passedOffer
                                            .offerDescriptionGerman
                                        : "",
                                  
                                    // validator: (offerDescriptionGerman) {
                                    //   return offerDescriptionGerman
                                    //           .isEmpty
                                    //       ? ArabDealLocalization.of(
                                    //               context)
                                    //           .getTranslatedWordByKey(
                                    //               key:
                                    //                   'all_pages_field_cant_be_empty')
                                    //       : null;
                                    // },
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
                                 constraints: BoxConstraints(minHeight:60),
                                child: TextFormField(
                                   maxLines: null,
                                        textInputAction: TextInputAction.newline,
                                    initialValue: !(widget.isAddOffer)
                                        ? widget.passedOffer.videoUrl ??
                                            ""
                                        : "",
                                    // validator: (videoUrl) {
                                    //   return videoUrl.isEmpty
                                    //       ? ArabDealLocalization.of(
                                    //               context)
                                    //           .getTranslatedWordByKey(
                                    //               key:
                                    //                   'all_pages_field_cant_be_empty')
                                    //       : null;
                                    // },
                                  
                                    onTap: _videoURLFocus,
                                    onSaved: (videoURL) {
                                      offer.videoUrl = videoURL;
                                    },
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
                                 constraints: BoxConstraints(minHeight:60),
                                child: TextFormField(
                                   maxLines: null,
                                        textInputAction: TextInputAction.newline,
                                    onTap: _offerURLFocus,
                                    // validator: (offerUrl) {
                                    //   return offerUrl.isEmpty
                                    //       ? ArabDealLocalization.of(
                                    //               context)
                                    //           .getTranslatedWordByKey(
                                    //               key:
                                    //                   'all_pages_field_cant_be_empty')
                                    //       : null;
                                    // },
                                    initialValue: !(widget.isAddOffer)
                                        ? widget.passedOffer.offerUrl
                                        : "",
                                    onSaved: (offerURL) {
                                      offer.offerUrl = offerURL;
                                    },
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
                                 constraints: BoxConstraints(minHeight:60),
                                child: TextFormField(
                                   maxLines: null,
                                        textInputAction: TextInputAction.newline,
                                    keyboardType: TextInputType.number,
                                    onTap: _oldPriceFocus,
                                    // validator: (priceBefore) {
                                    //   return priceBefore.isEmpty
                                    //       ? ArabDealLocalization.of(
                                    //               context)
                                    //           .getTranslatedWordByKey(
                                    //               key:
                                    //                   'all_pages_field_cant_be_empty')
                                    //       : null;
                                    // },
                                    initialValue: !(widget.isAddOffer)
                                        ? widget.passedOffer.priceBefore
                                            .toString()
                                        : "",
                                    onSaved: (oldPrice) {
                                      if (oldPrice.isNotEmpty &&
                                          isNumeric(oldPrice))
                                        offer.priceBefore =
                                            double.parse(oldPrice);
                                    },
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
                                 constraints: BoxConstraints(minHeight:60),
                                child: TextFormField(
                                   maxLines: null,
                                        textInputAction: TextInputAction.newline,
                                    onTap: _newPriceFocus,
                                    initialValue: !(widget.isAddOffer)
                                        ? widget.passedOffer.priceAfter
                                            .toString()
                                        : "",
                                    keyboardType: TextInputType.number,
                                    // validator: (newPrice) {
                                    //   return newPrice.isEmpty
                                    //       ? ArabDealLocalization.of(
                                    //               context)
                                    //           .getTranslatedWordByKey(
                                    //               key:
                                    //                   'all_pages_field_cant_be_empty')
                                    //       : null;
                                    // },
                                    onSaved: (newPrice) {
                                      if (newPrice.isNotEmpty &&
                                          isNumeric(newPrice))
                                        offer.priceAfter =
                                            double.parse(newPrice);
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
                                 constraints: BoxConstraints(minHeight:60),
                                child: TextFormField(
                                   maxLines: null,
                                        textInputAction: TextInputAction.newline,
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
                                    // validator: (vouchersCode) {
                                    //   return vouchersCode.isEmpty
                                    //       ? ArabDealLocalization.of(
                                    //               context)
                                    //           .getTranslatedWordByKey(
                                    //               key:
                                    //                   'all_pages_field_cant_be_empty')
                                    //       : null;
                                    // },
                                    onSaved: (discount) {
                                      offer.vouchersCode = discount;
                                    },
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
                                        Text(
                                            ArabDealLocalization.of(
                                                    context)
                                                .getTranslatedWordByKey(
                                                    key:
                                                        'all_pages_currnet_files'),
                                            style: TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize: ScreenUtil()
                                                    .setSp(15))),
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
                                                        setState(() {
                                                          widget
                                                              .passedOffer
                                                              .imageUrl
                                                              .removeAt(
                                                                  index);
                                                        });
                                                      },
                                                    )),
                                                  ],
                                                ),
                                              );
                                            },
                                            itemCount: widget.passedOffer
                                                    .imageUrl?.length ??
                                                0,
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                      ],
                                    ),
                              Container(
                                  height: 50,
                                  child: RaisedButton.icon(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    onPressed: () async {
                                      await loadAssets();
                                      print('hello');
                                    },
                                    label: Text(
                                        ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'all_pages_Pick_files_button'),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize:
                                                ScreenUtil().setSp(18))),
                                    color: Color(0xffde1515),
                                    icon: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                    ),
                                  )),
                              SizedBox(height: 20),
                              Container(
                                width: 300,
                                height: 200,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    border: Border(
                                        top: BorderSide(
                                            color: Colors.grey[400]),
                                        bottom: BorderSide(
                                            color: Colors.grey[400]),
                                        left: BorderSide(
                                            color: Colors.grey[400]),
                                        right: BorderSide(
                                            color: Colors.grey[400])),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(5))),
                                margin: EdgeInsets.all(15),
                                child: (images.length == 0)
                                    ? Center(
                                        child: Padding(
                                        padding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                        child: Text(
                                            ArabDealLocalization.of(
                                                    context)
                                                .getTranslatedWordByKey(
                                                    key:
                                                        'all_pages_pick_files'),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: ScreenUtil()
                                                    .setSp(17))),
                                      ))
                                    : StaggeredGridView.countBuilder(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 2,
                                        padding:
                                            EdgeInsets.only(bottom: 30),
                                        mainAxisSpacing: 2,
                                        itemCount: images?.length ?? 0,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            child: AssetThumb(
                                              asset: images[index],
                                              width: 150,
                                              quality: 100,
                                              height: 150,
                                            ),
                                            onTap: () {},
                                          );
                                        },
                                        staggeredTileBuilder: (index) {
                                          return StaggeredTile.extent(
                                              1, 100);
                                        }),
                              ),
                              SizedBox(height: 40),
                              Container(
                                  width: 250,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom:30),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    onPressed: () async {
                                      bool isConnected =
                                          await checkInternetConnectivity();
                                      if (isConnected) {
                                        if (formKey.currentState
                                            .validate()) {
                                          await _uploadImages();
                                          if (!widget.isAddOffer) {
                                            saveDataToOffer();
                                            await _editOffer(context);
                                          } else {
                                            // add offer case
                                            print(categoryIsPicked);
                                            if (categoryIsPicked) {
                                              saveDataToOffer();
                                              print(selectedCategory);

                                              await _addOffer(context);
                                            } else {
                                              showToast(
                                                  'Select a category',
                                                  context: context,
                                                  animation:
                                                      StyledToastAnimation
                                                          .slideFromBottom,
                                                  reverseAnimation:
                                                      StyledToastAnimation
                                                          .slideToBottom,
                                                  startOffset:
                                                      Offset(0.0, 3.0),
                                                  reverseEndOffset:
                                                      Offset(0.0, 3.0),
                                                  position:
                                                      StyledToastPosition
                                                          .bottom,
                                                  curve:
                                                      Curves.elasticOut);
                                            }
                                          }
                                        } else {
                                          showToast(
                                              'Complete all the required fields',
                                              context: context,
                                              animation:
                                                  StyledToastAnimation
                                                      .slideFromBottom,
                                              reverseAnimation:
                                                  StyledToastAnimation
                                                      .slideToBottom,
                                              startOffset:
                                                  Offset(0.0, 3.0),
                                              reverseEndOffset:
                                                  Offset(0.0, 3.0),
                                              position:
                                                  StyledToastPosition
                                                      .bottom,
                                              curve: Curves.elasticOut);
                                        }
                                      } else {
                                        Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text(ArabDealLocalization
                                                    .of(context)
                                                .getTranslatedWordByKey(
                                                    key:
                                                        'all_pages_no_internet_connection'))));
                                      }
                                    },
                                    child: Text(
                                        ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key: (widget.isAddOffer)
                                                    ? 'admin_add_offer_add'
                                                    : 'all_pages_edit'),
                                        style: TextStyle(
                                            color: Colors.white)),
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

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      print('logged in');
      resultList = await MultiImagePicker.pickImages(
        maxImages: 6,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#de1515",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }
    if (!mounted) return;
    setState(() {
      images = resultList;
      _error = error;
    });
  }

  void saveDataToOffer() {
    formKey.currentState.save();
    offer.categoryId = selectedCategory.id.toString();
    User user = FetchUserDataService.fetchUser();
    offer.createdBy = user.id;
    if (!widget.isAddOffer) {
      //edit offer case , adding some old data
      offer.user = widget.passedOffer.user;
      offer.date = widget.passedOffer.date;
      offer.dateAr = widget.passedOffer.dateAr;
      offer.category = selectedCategory;
      offer.percent = widget.passedOffer.percent;
    }
  }

  Future _addOffer(BuildContext context) async {
    bool resultOfAdding =
        await AddOfferByAdminHttpService.addOfferByAdmin(offer);
    if (resultOfAdding) {
      AwesomeDialog(
          btnOkColor: Colors.green,
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_success'),
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
          desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_offer_added_successfully'),
          isDense: true,
          btnOkOnPress: () {
            App.refrechAction(context);
          }).show();
    } else
      AwesomeDialog(
              btnOkColor: Colors.red,
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: false,
              title: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_error'),
              dismissOnBackKeyPress: true,
              desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_something_went_wrong'),
              isDense: true,
              btnOkOnPress: () {})
          .show();
  }

  Future _uploadImages() async {
    if (offer.imageUrl == null) offer.imageUrl = [];
    if (!widget.isAddOffer) {
      offer.imageUrl = widget
          .passedOffer.imageUrl; //for edit offer case , adding the old files
    }
    for (Asset imageAsset in images) {
      String uploadedImageURL =
          await UploadImageToServerHttpService.uploadImage(imageAsset);
      if (uploadedImageURL != null) {
        offer.imageUrl.add(uploadedImageURL);
      }
    }
  }

  Future _editOffer(BuildContext context) async {
    offer.id = widget.passedOffer.id;
    bool resultOfEditing =
        await EditOfferByAdminHttpService.editOfferByAdmin(offer);
    if (resultOfEditing) {
      AwesomeDialog(
          btnOkColor: Colors.green,
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_success'),
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
          desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_offer_edited_successfully'),
          isDense: true,
          btnOkOnPress: () {
            App.refrechAction(context);
          }).show();
      // widget.updateOffer(widget.index, offer);
    } else
      AwesomeDialog(
              btnOkColor: Colors.red,
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: false,
              title: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_error'),
              dismissOnBackKeyPress: true,
              desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_something_went_wrong'),
              isDense: true,
              btnOkOnPress: () {})
          .show();
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
            color: focusNode.hasFocus ? Color(0xffde1515) : Colors.grey[400],
            fontSize: ScreenUtil().setSp(14)),
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
