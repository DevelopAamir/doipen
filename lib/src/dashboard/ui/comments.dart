import 'package:doipen/src/constants/colors.dart';
import 'package:doipen/src/dashboard/helpers/posts_handlers.dart';
import 'package:doipen/src/dashboard/ui_helpers/SendMessageTextField.dart';
import 'package:doipen/src/dashboard/ui_helpers/commentBubbble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Comments extends StatefulWidget {
  final title;
  final id;
  const Comments({Key? key, this.title, this.id}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: PostHandler().getComments(id: widget.id),
              builder: (context,AsyncSnapshot snapshot) {
                return !snapshot.hasData ? Center(child: SpinKitDoubleBounce(color: primaryColor,),) :
                ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data['data'].length,
                  itemBuilder: (context, i) {
                    return CommentBubble(data: snapshot.data['data'][i],);
                  },
                );
              }
            ),
          ),
           SendMessageTextField(
            onSend: (a)async{
              await PostHandler().sendComments(title: a,id: widget.id);
              setState(() {

              });
            },
          )
        ],
      ),
    );
  }
}
