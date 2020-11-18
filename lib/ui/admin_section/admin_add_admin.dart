// add or edit
import 'package:ArabDealProject/language/localization/arab_deal_localization.dart';
import 'package:ArabDealProject/main.dart';
import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/check_internet_connectivity.dart';
import 'package:ArabDealProject/services/http_services/add_admin_http_service.http.dart';
import 'package:ArabDealProject/services/http_services/edit_admin_http_service.dart';
import 'package:ArabDealProject/services/http_services/upload_image_to_server_http_service.dart';
import 'package:ArabDealProject/ui/shared/drawer_wrapper.dart';
import 'package:ArabDealProject/ui/shared/custom_app_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class AdminAddAdmin extends StatefulWidget {
  final User passedAdmin;
  AdminAddAdmin({this.passedAdmin});
  @override
  _AdminAddAdminState createState() => _AdminAddAdminState();
}

class _AdminAddAdminState extends State<AdminAddAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>(debugLabel: "global key for add admin scaffold");
  final formKey = GlobalKey<FormState>();
  double heightOfScreen;
  double widthOfScreen;
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';
  FocusNode firstNameFocusNode = new FocusNode();
  FocusNode lastNameFocusNode = new FocusNode();
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passwordFocusNode = new FocusNode();
  FocusNode phoneFocusNode = new FocusNode();
  FocusNode usernameFocusNode=new FocusNode();
  bool checkBoxesInitialized=false;
  bool canAddOffer = false;
  bool canDeleteOffer = false;
  bool canEditOffer = false;
  bool canAddCategory = false;
  bool canEditCategory = false;
  bool canDeleteCategory = false;
  bool canSeeReports = false;
  bool canManageAdmin = false;
  bool dataLoading = false;
  User passedAdmin;
  @override
  Widget build(BuildContext context) {
    heightOfScreen = MediaQuery.of(context).size.height;
    widthOfScreen = MediaQuery.of(context).size.width;
    ScreenUtil.init(context,width:widthOfScreen,height:heightOfScreen);
    passedAdmin = widget.passedAdmin ?? User(admin: Map<String, int>());
     if(widget.passedAdmin!=null&&!checkBoxesInitialized)
    _initializeCheckBoxes();
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
              Container(
                width: widthOfScreen,
                height: heightOfScreen - 100,
                child: SingleChildScrollView(
                  child: Container(
                    width: widthOfScreen,
                    //height: 1620,
                    color: Colors.white,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          SizedBox(height: 30),
                          Container(
                            width: 250,
                            height: 60,
                            child: TextFormField(
                                initialValue: passedAdmin?.firstName ?? "",
                                focusNode: firstNameFocusNode,
                                onTap: _arabicTitleFocus,
                                onSaved: (firstName) {
                                  passedAdmin.firstName = firstName;
                                },
                                validator: (firstName) {
                                  return firstName.isEmpty
                                      ?  ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'all_pages_field_cant_be_empty  ')
                                      : null;
                                },
                                decoration: _getDecorationOfTextField(
                                    hintText: 'Firstname',
                                    focusNode: firstNameFocusNode)),
                          ),
                          SizedBox(height: 30),
                          Container(
                            width: 250,
                            height: 60,
                            child: TextFormField(
                              initialValue: passedAdmin?.lastName ?? "",
                              onTap: _germanTitleFocus,
                              onSaved: (lastName) {
                                passedAdmin.lastName = lastName;
                              },
                              validator: (lastName) {
                                return lastName.isEmpty
                                    ?  ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'all_pages_field_cant_be_empty  ')
                                    : null;
                              },
                              decoration: _getDecorationOfTextField(
                                  hintText: 'Lastname',
                                  focusNode: lastNameFocusNode),
                              focusNode: lastNameFocusNode,
                            ),
                          ),
                           SizedBox(height: 30),
                          Container(
                            width: 250,
                            height: 60,
                            child: TextFormField(
                              initialValue: passedAdmin?.username ?? "",
                              onTap: _germanDesFocus,
                              onSaved: (username) {
                                passedAdmin.username = username;
                              },
                              validator: (username) {
                                return username.isEmpty
                                    ?   ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'all_pages_field_cant_be_empty  ')
                                    : null;
                              },
                            decoration: _getDecorationOfTextField(
                                  hintText:   ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'all_pages_username'),
                                  focusNode: usernameFocusNode),
                              focusNode: usernameFocusNode,
                            ),
                          ),
                          SizedBox(height: 30),
                          Container(
                            width: 250,
                            height: 80,
                            child: TextFormField(
                                initialValue: passedAdmin?.email ?? "",
                                maxLines: 10,
                                onTap: _arabicDesFocus,
                                onSaved: (email) {
                                  passedAdmin.email = email;
                                },
                                validator: (email) {
                                  return email.isEmpty
                                      ?  ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'all_pages_field_cant_be_empty  ')
                                      : null;
                                },
                                focusNode: emailFocusNode,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _getDecorationOfTextField(
                                    hintText: 'Email',
                                    focusNode: emailFocusNode)),
                          ),   
                        (passedAdmin.username==null)?  Column(
                            children:[
                                 SizedBox(height: 30),
                          Container(
                            width: 250,
                            height: 80,
                            child: TextFormField(
                                initialValue: passedAdmin?.password ?? "",
                                maxLines: 10,
                                onTap: _passwordFocus,
                                onSaved: (password) {
                                  passedAdmin.password = password;
                                },
                                validator: (password) {
                                  return password.isEmpty
                                      ?  ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'all_pages_field_cant_be_empty  ')
                                      : null;
                                },
                                focusNode: passwordFocusNode,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.emailAddress,
                                decoration: _getDecorationOfTextField(
                                    hintText: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'login_page_password'),
                                    focusNode: passwordFocusNode)),
                          ),   
                            ]
                          ) :SizedBox.shrink(),           
                          SizedBox(height: 30),
                          Container(
                            width: 250,
                            height: 80,
                            child: TextFormField(
                                initialValue: passedAdmin?.phoneNumber ?? "",
                                textInputAction: TextInputAction.done,
                                onTap: _arabicDetailsFocus,
                                onSaved: (mobilePhone) {
                                  passedAdmin.phoneNumber = mobilePhone;
                                },
                                validator: (mobilePhone) {
                                  return mobilePhone.isEmpty
                                      ?  ArabDealLocalization.of(context)
                                            .getTranslatedWordByKey(
                                                key:
                                                    'all_pages_field_cant_be_empty  ')
                                      : null;
                                },
                                focusNode: phoneFocusNode,
                                keyboardType: TextInputType.number,
                                decoration: _getDecorationOfTextField(
                                    hintText: 'Mobile phone',
                                    focusNode: phoneFocusNode)),
                          ),
                          SizedBox(height: 30),
                          SizedBox(height: 20),
                          Container(
                            
                              height: 50,
                              child: RaisedButton.icon(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onPressed: () async {
                                  await loadAssets();
                                  print('hello');
                                },
                                label:Text(
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
                                    top: BorderSide(color: Colors.grey[400]),
                                    bottom: BorderSide(color: Colors.grey[400]),
                                    left: BorderSide(color: Colors.grey[400]),
                                    right: BorderSide(color: Colors.grey[400])),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
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
                                    padding: EdgeInsets.only(bottom: 30),
                                    mainAxisSpacing: 2,
                                    itemCount: images.length,
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
                                      return StaggeredTile.extent(1, 100);
                                    }),
                          ),
                          SizedBox(height: 40),
                          SizedBox(height: 30),
                          Text('Admin roles',
                              style: TextStyle(
                                  color: Color(0xffde1515),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Checkbox(
                                  value: canAddOffer,
                                  activeColor: Color(0xffde1515),
                                  onChanged: (newCanAddOffer) {
                                    setState(() {
                                      canAddOffer = newCanAddOffer;
                                    });
                                  }),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Can Add Offers',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Checkbox(
                                  value: canDeleteOffer,
                                  activeColor: Color(0xffde1515),
                                  onChanged: (newCanDeleteOffer) {
                                    setState(() {
                                      canDeleteOffer = newCanDeleteOffer;
                                    });
                                  }),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Can delete Offers',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Checkbox(
                                  value: canEditOffer,
                                  activeColor: Color(0xffde1515),
                                  onChanged: (newCanEditOffer) {
                                    setState(() {
                                      canEditOffer = newCanEditOffer;
                                    });
                                  }),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Can Edit Offers',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Checkbox(
                                  value: canAddCategory,
                                  activeColor: Color(0xffde1515),
                                  onChanged: (newCanAddCategory) {
                                    setState(() {
                                      canAddCategory = newCanAddCategory;
                                    });
                                  }),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Can Add Category',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Checkbox(
                                  value: canEditCategory,
                                  activeColor: Color(0xffde1515),
                                  onChanged: (newCanEditCategory) {
                                    setState(() {
                                      canEditCategory = newCanEditCategory;
                                    });
                                  }),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Can Edit Category',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Checkbox(
                                  value: canDeleteCategory,
                                  activeColor: Color(0xffde1515),
                                  onChanged: (newCanDeleteCategory) {
                                    setState(() {
                                      canDeleteCategory = newCanDeleteCategory;
                                    });
                                  }),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Can Delete Category',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Checkbox(
                                  value: canSeeReports,
                                  activeColor: Color(0xffde1515),
                                  onChanged: (newCanSeeReports) {
                                    setState(() {
                                      canSeeReports = newCanSeeReports;
                                    });
                                  }),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Can See Reports',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Checkbox(
                                  value: canManageAdmin,
                                  activeColor: Color(0xffde1515),
                                  onChanged: (newCanManageAdmin) {
                                    setState(() {
                                      canManageAdmin = newCanManageAdmin;
                                    });
                                  }),
                              SizedBox(
                                width: 50,
                              ),
                              Text('Can Manage Admin',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16))
                            ],
                          ),
                          SizedBox(height: 40),
                          Container(
                              width: 250,
                              height: 50,
                              margin: EdgeInsets.only(bottom:25),
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                onPressed: () async {
                                  if (formKey.currentState.validate()) {
                                    formKey.currentState.save();
                                    passedAdmin.admin['can_add_offer'] =
                                        canAddOffer ? 1 : 0;
                                    passedAdmin.admin['can_delete_offer'] =
                                        canDeleteOffer ? 1 : 0;
                                    passedAdmin.admin['can_edit_offer'] =
                                        canEditOffer ? 1 : 0;
                                    passedAdmin.admin['can_add_category'] =
                                        canAddCategory ? 1 : 0;
                                    passedAdmin.admin['can_delete_category'] =
                                        canDeleteCategory ? 1 : 0;
                                    passedAdmin.admin['can_edit_category'] =
                                        canEditCategory ? 1 : 0;
                                    passedAdmin.admin['can_see_reports'] =
                                        canSeeReports ? 1 : 0;
                                    passedAdmin
                                            .admin['change_can_manage_admin'] =
                                        canManageAdmin ? 1 : 0;
                                    bool internetConnectionExisted =
                                        await checkInternetConnectivity();
                                    if (internetConnectionExisted) {
                                      print('there is internet connection');
                                      await _uploadImages();
                                      if (widget.passedAdmin == null) {
                                       // print(passedAdmin.imageUrl);
                                      //  so we would add admin
                                        bool resultOfAdding =
                                            await AddAdminHttpService.addAdmin(
                                                passedAdmin);
                                        print(resultOfAdding.toString());
                                        if (resultOfAdding){
                                            AwesomeDialog(
                                                  btnOkColor: Colors.green,
                                                  context: context,
                                                  dialogType: DialogType.SUCCES,
                                                  animType: AnimType.RIGHSLIDE,
                                                  headerAnimationLoop: false,
                                                  dismissOnTouchOutside: false,
                                                  title: ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_success'),
                                                  dismissOnBackKeyPress: false,
                                                  desc:
                                                      ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_add_admin_page_admin_added_successfully'),
                                                  isDense: true,
                                                  btnOkOnPress: () {
                                                    App.refrechAction(context);
                                                  })
                                              .show();
                                              

                                        }
                                        
                                        else {
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
                                        }
                                      } else {
                                        // so we would edit admin
                                        print('we would edit admin');
                                        bool resultOfEditing =
                                            await EditAdminHttpService
                                                .editAdmin(passedAdmin);
                                        if (resultOfEditing){
                                           AwesomeDialog(
                                                  btnOkColor: Colors.green,
                                                  context: context,
                                                  dialogType: DialogType.SUCCES,
                                                  animType: AnimType.RIGHSLIDE,
                                                  headerAnimationLoop: false,
                                                  dismissOnTouchOutside: false,
                                                
                                                  title:ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_success'),
                                                  dismissOnBackKeyPress: false,
                                                  desc:
                                                      ArabDealLocalization.of(context).getTranslatedWordByKey(key:'admin_add_admins_page_admin_edited_successfully'),
                                                  isDense: true,
                                                  btnOkOnPress: () {
                                                     App.refrechAction(context);
                                                  })
                                              .show();
                                             

                                        }
                                         
                                        else {
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
                                        }
                                      }
                                    } else {
                                      // no internet connection
                                      AwesomeDialog(
                                                  btnOkColor: Colors.red,
                                                  context: context,
                                                  dialogType: DialogType.ERROR,
                                                  animType: AnimType.RIGHSLIDE,
                                                  headerAnimationLoop: false,
                                                  title:  ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_error'),
                                                  dismissOnBackKeyPress: true,
                                                  desc:  ArabDealLocalization.of(context).getTranslatedWordByKey(key:'all_pages_no_internet_connection'),
                                                  isDense: true,
                                                  btnOkOnPress: () {})
                                              .show();
                                    }
                                    print('done');
                                  }
                                },
                                child: Text('Ok',
                                    style: TextStyle(color: Colors.white)),
                                color: Color(0xffde1515),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      print('logged in');
      resultList = await MultiImagePicker.pickImages(
        maxImages: 1,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  Future _uploadImages() async {
     if(images.length!=0){
        String uploadedImageURL =
          await UploadImageToServerHttpService.uploadImage(images[0]);
     passedAdmin.imageUrl=uploadedImageURL;
     } //else keep the old file  
     else{
       passedAdmin.imageUrl=widget.passedAdmin?.imageUrl;
     }
  }

  void _initializeCheckBoxes() {
    print('fine');
    User user = widget.passedAdmin;
    if (user.admin['can_add_offer'] == 1)
      canAddOffer = true;
    else
      canAddOffer = false;

    if (user.admin['can_delete_offer'] == 1)
      canDeleteOffer = true;
    else
      canDeleteOffer = false;

    if (user.admin['can_edit_offer'] == 1)
      canEditOffer = true;
    else
      canEditOffer = false;

    if (user.admin['can_add_category'] == 1)
      canAddCategory = true;
    else
      canAddCategory = false;

    if (user.admin['can_edit_category'] == 1)
      canEditCategory = true;
    else
      canEditCategory = false;

    if (user.admin['can_delete_category'] == 1)
      canDeleteCategory = true;
    else
      canDeleteCategory = false;

    if (user.admin['can_see_reports'] == 1)
      canSeeReports = true;
    else
      canSeeReports = false;

    if (user.admin['can_manage_admin'] == 1)
      canManageAdmin = true;
    else
      canManageAdmin = false;

      checkBoxesInitialized=true;
  }

  void _arabicTitleFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(firstNameFocusNode);
    });
  }

  void _germanTitleFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(lastNameFocusNode);
    });
  }

  void _arabicDetailsFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(phoneFocusNode);
    });
  }

  void _passwordFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(passwordFocusNode);
    });
  }

  void _arabicDesFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(emailFocusNode);
    });
  }

  void _germanDesFocus() {
    setState(() {
      FocusScope.of(context).requestFocus(usernameFocusNode);
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
