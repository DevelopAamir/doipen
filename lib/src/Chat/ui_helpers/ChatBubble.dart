import 'package:doipen/src/Chat/helpers/chatHandlers.dart';
import 'package:doipen/src/constants/colors.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final bool isYou;
  final String msg;
  final img;
  final id;
  const ChatBubble({Key? key, required this.isYou, required this.msg, this.img, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(!isYou){
      ChatHandlers().seen(id);
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(isYou)
          Spacer(),
          if(!isYou)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(backgroundImage: NetworkImage(img),radius: 10,),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(msg),
            ),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.2),
              borderRadius: BorderRadius.only(
                topLeft: isYou != true ?  const Radius.circular(0): const Radius.circular(10),
                topRight: isYou != true ?  const Radius.circular(10): const Radius.circular(0),
                bottomLeft: const Radius.circular(10),
                bottomRight: const Radius.circular(10)
              )
            ),
          ),
          if(isYou)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(backgroundImage: NetworkImage(img,),radius: 10,),
            ),
          if(!isYou)
          Spacer(),
        ],
      ),
    );
  }
}
