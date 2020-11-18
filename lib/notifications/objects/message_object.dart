import 'package:flutter/cupertino.dart';

@immutable
class MessageObject{
final String title;
final String body;
const MessageObject({this.title,this.body});
}