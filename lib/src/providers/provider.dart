import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../SharedWidgets/ProfileCard.dart';

class StateManagement extends ChangeNotifier{
  var currentUser;
  var currentUser_id;
  ProfileCard? profile;
  List follows = [];
  setCurrentUser({user, id}){
    currentUser = user;
    currentUser_id = id;
    notifyListeners();
  }

  setFollows(data){
    follows = data;
    notifyListeners();
  }

  setProfile(data){
    profile = data;
    notifyListeners();
  }
}