import 'package:ArabDealProject/objects/user.dart';
import 'package:ArabDealProject/services/data_services/fetch_user_service.dart';
import 'package:ArabDealProject/ui/shared/admin_logged_in_drawer.dart';
import 'package:ArabDealProject/ui/shared/user_logged_in_drawer.dart';
import 'package:ArabDealProject/ui/shared/user_logged_out_drawer.dart';
import 'package:flutter/material.dart';

class DrawerWrapper extends StatefulWidget {
  DrawerWrapper(this.context);
  final BuildContext context;
  

  _DrawerWrapperState createState() => _DrawerWrapperState();
}

class _DrawerWrapperState extends State<DrawerWrapper> {
  User user;
  @override
  Widget build(BuildContext context) {
    user = FetchUserDataService.fetchUser();
    if (user != null) {
      // there is a user or an admin lodded in !
      if (user.userType == "0") {
        // that's means an admin already logged in !
        return AdminLoggedInDrawer(
          currentContetxt: widget.context,
          logoutAction: _logoutAction,
          
        );
      } else {
        // that's means a user already logged in !
        return UserLoggedInDrawer(
            currentContetxt: widget.context,
            logoutAction: _logoutAction,
            );
      }
    } else {
      // not logged in !
      return UserLoggedOutDrawer(
          currentContetxt: widget.context,
          );
    }
  }

  void _logoutAction() {
    setState(() {
      user = null;
    });
  }
}
