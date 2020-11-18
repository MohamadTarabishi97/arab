import 'package:ArabDealProject/notifications/objects/message_object.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';



class NotificationWidget extends StatefulWidget {
  NotificationWidget({Key key}) : super(key: key);

  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  final FirebaseMessaging _firebaseMessaging=FirebaseMessaging();
  final List<MessageObject> messages=[];

  @override
  void initState() {
   
    super.initState();
     _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        final notification=message['notification'];
        setState(() {
          messages.add(MessageObject(
            title: notification['title'],
            body: notification['body']
          ));
        });
      //  _showItemDialog(message);
      },
    //  onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
       // _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
       // _navigateToItemDetail(message);
      },
    );
     _firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
  );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body:Center(child:Text("messages[0].body")) 
    );
  }
}