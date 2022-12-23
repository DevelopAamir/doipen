import 'dart:convert';

import 'package:doipen/src/constants/apikeys.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import '';
import '../../utils/storage.dart';
class ChatHandlers{
  getFriends()async{
    var token =await Storage().read('token');
    const url = getfriends;
    var response = await http.get(Uri.parse(url),headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body);
    print(data);
    return data;
  }
  getAdmin()async{
    var token =await Storage().read('token');
    const url = getadmin;
    var response = await http.get(Uri.parse(url),headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body);
    print(data);
    return data;
  }
  getChats(id)async{
    var token =await Storage().read('token');
    var url = getchats + '?id=$id';
    var response = await http.get(Uri.parse(url),headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body);
    print(data);
    return data;
  }
  Future sendCMessage(id,message)async{
    var token =await Storage().read('token');
    var url = sendmessage + '?id=$id&message=$message';
    var response = await http.post(Uri.parse(url),headers: {'Authorization': 'Bearer $token'});
    var data = jsonDecode(response.body);
    Fluttertoast.showToast(msg: data['message']);
    print(data);
    return data;
  }
  seen(id)async{
    print(id);
    var token =await Storage().read('token');
    var url = seenApi + '?id=$id';
    await http.post(Uri.parse(url),headers: {'Authorization': 'Bearer $token'});




  }
}