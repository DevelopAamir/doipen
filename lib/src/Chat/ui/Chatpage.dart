import 'package:doipen/src/Chat/helpers/chatHandlers.dart';
import 'package:doipen/src/Chat/ui_helpers/ChatBubble.dart';
import 'package:doipen/src/SharedWidgets/ProfileCard.dart';
import 'package:doipen/src/constants/colors.dart';
import 'package:doipen/src/dashboard/ui_helpers/SendMessageTextField.dart';
import 'package:doipen/src/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String title;
  final id;
  const ChatPage({Key? key, required this.title, this.id}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: FutureBuilder(
                    future: ChatHandlers().getChats(widget.id),
                    builder: (context, AsyncSnapshot snap) {
                      return snap.hasData
                          ? ListView.builder(
                              reverse: true,
                              itemCount: snap.data.length,
                              itemBuilder: (context, i) {
                                print(snap.data.length);
                                print(Provider.of<StateManagement>(context,listen: false).currentUser_id);
                                return ChatBubble(
                                  isYou:snap.data[i]['sender_id']['ID'] == Provider.of<StateManagement>(context,listen: false).currentUser_id,
                                  msg: snap.data[i]['message'],
                                  img: snap.data[i]['sender_id']['photo'],
                                  id : snap.data[i]['chat_id']
                                );
                              },
                            )
                          : const SpinKitDoubleBounce(
                              color: primaryColor,
                            );
                    })),
            const SizedBox(
              height: 5,
            ),
            SendMessageTextField(
                onSend: (a)async{
                  await ChatHandlers().sendCMessage(widget.id,a.toString());
                  setState(() {

                  });
                },
            ),
          ],
        ),
      ),
    );
  }
}
