import 'package:doipen/src/Chat/ui/Chatpage.dart';
import 'package:doipen/src/constants/colors.dart';
import 'package:doipen/src/utils/globalhelper.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String title;
  final String description;
  final String imgUrl;
  final bool is_new;
  final uid;
  const ChatCard({Key? key, required this.title, required this.description, required this.imgUrl, required this.is_new, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
        child:  ListTile(
          contentPadding: const EdgeInsets.only(left: 8,top: 5,bottom: 5),
          leading:  CircleAvatar(radius: 25,backgroundImage: NetworkImage(imgUrl),),
          trailing:is_new? const Padding(
            padding: EdgeInsets.only(right: 15.0),
            child: Icon(Icons.notifications_active),
          ) : null,
          title: Text(title,style: const TextStyle(fontWeight: FontWeight.bold),),
          subtitle: Text(description,style: is_new ? const TextStyle(fontWeight: FontWeight.w900, fontSize: 18,color: Colors.black) : null,),
          onTap: (){
            GlobalHelpers.navigator(ChatPage(title: title,id: uid,), context);
          },
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: primaryColor.withOpacity(.2)
        ),
      ),
    );
  }
}
