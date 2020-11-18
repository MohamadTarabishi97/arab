import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/language/localization/check_locale_function.dart';
import 'package:ArabDealProject/main.dart';
import 'package:ArabDealProject/objects/category.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/http_services/add_category_http_service.dart';
import 'package:ArabDealProject/services/http_services/delete_category_http_service.dart';
import 'package:ArabDealProject/services/http_services/edit_cagegory_http_service.dart';
import 'package:ArabDealProject/services/http_services/get_categories_http_service.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/loading.dart';
import 'package:ArabDealProject/ui/shared/no_internet_connection.dart';
import 'package:ArabDealProject/ui/shared/custom_app_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminCategoriesPage extends StatefulWidget {
  @override
  _AdminCategoriesPageState createState() => _AdminCategoriesPageState();
}

class _AdminCategoriesPageState extends State<AdminCategoriesPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Category> categories;
  double widthOfScreen;
  double heightOfScreen;
  @override
  Widget build(BuildContext context) {
    bool dataLoading = false;
    widthOfScreen = MediaQuery.of(context).size.width;
    heightOfScreen = MediaQuery.of(context).size.height;
    ScreenUtil.init(context,width:widthOfScreen,height:heightOfScreen);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
        endDrawer: DrawerWrapper(context),
        key: _scaffoldKey,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddCategoryDialog(context,
                addCategoryFunction: addCategoryToLocalList);
          },
          backgroundColor: Color(0xffde1515),
          child: Icon(Icons.add),
        ),
        body: FutureBuilder(
          future: checkInternetConnectivity(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                if (dataLoading) return _loadingWidget(_scaffoldKey);
                return FutureBuilder(
                    future: GetCategoriesHttpService.getCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        categories = snapshot.data;
                        print(categories.last.id);
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              CustomAppBar(scaffoldKey: _scaffoldKey),
                              SizedBox(height: 40),
                              Text('All The Categories',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: ScreenUtil().setSp(20))),
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
                                height: heightOfScreen - 221,
                                child: ListView.separated(
                                    itemBuilder: (context, index) {
                                      return Card(
                                        color: Colors.grey[200],
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20),
                                        child: InkWell(
                                          splashColor: Colors.red,
                                          onTap: () {
                                            // you have to send the data h
                                            _showAddCategoryDialog(context,
                                                passedCategory:
                                                    categories[index],
                                                index: index,
                                                updateCategoryToLocalListFunction:
                                                    updateCategoryToLocalList);
                                          },
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(80.0),
                                                child: Center(
                                                    child: Text(
                                                  checkWhetherArabicLocale(
                                                          context)
                                                      ? categories[index]
                                                          .nameArabic
                                                      : categories[index]
                                                          .nameGerman,
                                                  style: TextStyle(
                                                      color: Color(0xffde1515),
                                                      fontSize: ScreenUtil()
                                                          .setSp(20)),
                                                )),
                                              ),
                                              Positioned(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      InkWell(
                                                        child: Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                            size: 30),
                                                        onTap: () async {
                                                          AwesomeDialog(
                                                              btnOkColor:
                                                                  Colors.red,
                                                              context: context,
                                                              dialogType:
                                                                  DialogType
                                                                      .WARNING,
                                                              animType: AnimType
                                                                  .RIGHSLIDE,
                                                              headerAnimationLoop:
                                                                  false,
                                                              title:
                                                                  ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_categories_page_delete_category'),
                                                              dismissOnTouchOutside:
                                                                  false,
                                                              onDissmissCallback:
                                                                  () {
                                                                print(
                                                                    'dismiss called');
                                                              },
                                                              desc:
                                                                  ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_categories_page_are_you_sure_you_want_to_delete_this_category'),
                                                              isDense: true,
                                                              btnCancelOnPress:
                                                                  () {},
                                                              btnOkOnPress:
                                                                  () async {
                                                                bool
                                                                    resultOfDelete =
                                                                    await DeleteCategoryHttpService.deleteCategory(
                                                                        categories[index]
                                                                            .id);
                                                                if (resultOfDelete) {
                                                                  // if it is done

                                                                  AwesomeDialog(
                                                                      btnOkColor: Colors
                                                                          .green,
                                                                      context:
                                                                          context,
                                                                      dialogType:
                                                                          DialogType
                                                                              .SUCCES,
                                                                      animType:
                                                                          AnimType
                                                                              .RIGHSLIDE,
                                                                      headerAnimationLoop:
                                                                          false,
                                                                      title:
                                                                          ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_success'),
                                                                      dismissOnBackKeyPress:
                                                                          true,
                                                                      desc:
                                                                          ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_categories_page_category_deleted_successfully'),
                                                                      isDense:
                                                                          true,
                                                                      btnOkOnPress:
                                                                          () {
                                                                        App.refrechAction(
                                                                            context);

                                                                      }).show();
                                                                } else {
                                                                  // so something went wrong
                                                                  setState(() {
                                                                    dataLoading =
                                                                        false;
                                                                    AwesomeDialog(
                                                                            btnOkColor: Colors
                                                                                .red,
                                                                            context:
                                                                                context,
                                                                            dialogType: DialogType
                                                                                .ERROR,
                                                                            animType: AnimType
                                                                                .RIGHSLIDE,
                                                                            headerAnimationLoop:
                                                                                false,
                                                                            title:
                                                                                 ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_error'),
                                                                            dismissOnBackKeyPress:
                                                                                true,
                                                                            desc:
                                                                                 ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_something_went_wrong'),
                                                                            isDense:
                                                                                true,
                                                                            btnOkOnPress:
                                                                                () {})
                                                                        .show();
                                                                  });
                                                                }
                                                              }).show();
                                                          // after getting the result
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
                                    itemCount: categories.length),
                              )
                            ],
                          ),
                        );
                      } else
                        return SingleChildScrollView(
                            child: _loadingWidget(_scaffoldKey));
                    });
              } else {
                return SingleChildScrollView(
                    child: _noInternetConnectionWidget(_scaffoldKey));
              }
            }
            return SingleChildScrollView(child: _loadingWidget(_scaffoldKey));
          },
        ));
  }

  void addCategoryToLocalList({Category category}) {
    setState(() {
      categories.add(category);
    });
  }

  void updateCategoryToLocalList({Category category, int index}) {
    setState(() {
      categories.removeAt(index);
      categories.insert(index, category);
    });
  }
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

Widget _noInternetConnectionWidget(GlobalKey<ScaffoldState> scaffoldKey) {
  return Column(
    children: [
      CustomAppBar(scaffoldKey: scaffoldKey),
      SizedBox(
        height: 100,
      ),
      NoInternetConnection(),
    ],
  );
}

Widget _loadingWidget(GlobalKey<ScaffoldState> scaffoldKey) {
  return Column(
    children: [
      CustomAppBar(scaffoldKey: scaffoldKey),
      SizedBox(height: 200),
      Loading(),
    ],
  );
}

Future<void> _showAddCategoryDialog(BuildContext context,
    {Function addCategoryFunction,
    Function updateCategoryToLocalListFunction,
    Category passedCategory,
    int index}) {
  Category category = Category();
  final formKey = GlobalKey<FormState>();
  return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            title: Text(ArabDealLocalization.of(context).getTranslatedWordByKey(key:'add_category_page_add_category'),style:TextStyle(fontSize:ScreenUtil().setSp(16))),
            content: Container(
              width: 200,
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Container(
                      width: 250,
                      height: 60,
                      child: TextFormField(
                          onSaved: (String arabicName) {
                            category.nameArabic = arabicName;
                          },
                          initialValue: passedCategory?.nameArabic ?? '',
                          validator: (String arabicName) {
                            if (arabicName.isEmpty)
                              return 'Please enter the arabic title';
                            else
                              return null;
                          },
                          decoration: _getDecorationOfTextField(
                            hintText: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'add_category_page_enter_the_arabic_title'),
                          )),
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: 250,
                      height: 60,
                      child: TextFormField(
                          onSaved: (String germanName) {
                            category.nameGerman = germanName;
                          },
                          initialValue: passedCategory?.nameGerman ?? '',
                          validator: (String text) {
                            if (text.isEmpty)
                              return 'please enter the german title';
                            else
                              return null;
                          },
                          decoration: _getDecorationOfTextField(
                            hintText: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'add_category_page_enter_the_german_title'),
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
                              if (passedCategory == null) {
                                // that means there  is no passed Category so we will add a new Category
                                Category addedCategory =
                                    await AddCategoryHttpService.addCategory(
                                        category);
                                if (addedCategory != null) {
                                  addCategoryFunction(category: addedCategory);
                                  AwesomeDialog(
                                          btnOkColor: Colors.green,
                                          context: context,
                                          dialogType: DialogType.SUCCES,
                                          animType: AnimType.RIGHSLIDE,
                                          headerAnimationLoop: false,
                                          title: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_success'),
                                          dismissOnBackKeyPress: true,
                                          desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_add_category_page_category_added_successfully'),
                                          isDense: true,
                                          btnOkOnPress: () {
                                            Navigator.of(context).pop();
                                          })
                                      .show();
                                } else {
                                  AwesomeDialog(
                                          btnOkColor: Colors.red,
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.RIGHSLIDE,
                                          headerAnimationLoop: false,
                                          title:  ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_error'),
                                          dismissOnBackKeyPress: true,
                                          desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_something_went_wrong'),
                                          isDense: true,
                                          btnOkOnPress: () {})
                                      .show();
                                }
                              } else {
                                // that means there is a passed category so we will edit it.
                                category.id = passedCategory.id;
                                Category editedCategory =
                                    await EditCateogyHttpService.editCategory(
                                        category);
                                if (editedCategory != null) {
                                  updateCategoryToLocalListFunction(
                                      category: editedCategory, index: index);
                                  AwesomeDialog(
                                          btnOkColor: Colors.green,
                                          context: context,
                                          dialogType: DialogType.SUCCES,
                                          animType: AnimType.RIGHSLIDE,
                                          headerAnimationLoop: false,
                                          title: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_success'),
                                          dismissOnBackKeyPress: true,
                                          desc:  ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_add_category_page_category_edited_successfully'),
                                          isDense: true,
                                          btnOkOnPress: () {
                                            Navigator.of(context).pop();
                                          })
                                      .show();
                                } else {
                                   AwesomeDialog(
                                          btnOkColor: Colors.red,
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.RIGHSLIDE,
                                          headerAnimationLoop: false,
                                          title:  ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_error'),
                                          dismissOnBackKeyPress: true,
                                          desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_something_went_wrong'),
                                          isDense: true,
                                          btnOkOnPress: () {})
                                      .show();
                                }
                              }
                            } else {
                               AwesomeDialog(
                                          btnOkColor: Colors.red,
                                          context: context,
                                          dialogType: DialogType.ERROR,
                                          animType: AnimType.RIGHSLIDE,
                                          headerAnimationLoop: false,
                                          title:  ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_error'),
                                          dismissOnBackKeyPress: true,
                                          desc: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_no_internet_connection'),
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
