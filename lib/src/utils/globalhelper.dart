import 'package:doipen/src/utils/storage.dart';
import 'package:flutter/material.dart';

class GlobalHelpers{

  static navigator(Widget page,BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return page;
    }));
  }
}