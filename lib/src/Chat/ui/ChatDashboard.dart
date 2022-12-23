import 'package:doipen/src/Chat/helpers/chatHandlers.dart';
import 'package:doipen/src/Chat/ui_helpers/ChatCard.dart';
import 'package:doipen/src/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart' as material;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../SharedWidgets/ProfileCard.dart';
import '../../dashboard/helpers/getUser.dart';
import '../../providers/provider.dart';
import '../../utils/adstate.dart';

class ChatDashboard extends StatefulWidget {
  const ChatDashboard({Key? key}) : super(key: key);

  @override
  State<ChatDashboard> createState() => _ChatDashboardState();
}

class _ChatDashboardState extends State<ChatDashboard> {
  BannerAd? banner;

  @override
  void didChangeDependencies() {
    final adState = Provider.of<AdState>(context);
    adState.initialization.then((status) {
      banner = BannerAd(
          size: AdSize.banner,
          adUnitId: adState.bannerdUnitID,
          listener: BannerAdListener(onAdFailedToLoad: (a, k) {
            print(a.toString());
            print(k.message);
            Fluttertoast.showToast(msg: k.message);
          }),
          request: AdRequest())
        ..load().then((value) {
          setState(() {});
        });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: material.RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Provider.of<StateManagement>(context,listen: false).profile!,
                const SizedBox(
                  height: 10,
                ),
                if (banner == null)
                  SizedBox(
                    height: 50,
                  )
                else
                  Container(
                    height: banner!.size.height.toDouble(),
                    child: AdWidget(
                      ad: banner!,
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Admin',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    )),
                FutureBuilder(
                    future: ChatHandlers().getAdmin(),
                    builder: (context, AsyncSnapshot snapshot) {

                      return snapshot.hasData
                          ? ChatCard(
                              title: snapshot.data!['display_name'].toString(),
                              description:
                                  snapshot.data['last_message'] == false
                                      ? 'No Conversion Done !'
                                      : snapshot.data['last_message']['message']
                                          .toString(),
                              imgUrl: snapshot.data['profile_photo'].toString(),
                              is_new:snapshot.data['last_message'] == false ? false :
                                  snapshot.data['last_message']['viewed'] == 0
                                      ? true
                                      : false,
                              uid: snapshot.data['user_id'],
                            )
                          : Container();
                    }),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Users',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w900),
                    )),
                Expanded(
                  child: FutureBuilder(
                      future: ChatHandlers().getFriends(),
                      builder: (context, AsyncSnapshot snap) {
                        return snap.hasData
                            ? ListView.builder(
                                itemCount: snap.data.length,
                                itemBuilder: (context, i) {
                                  return ChatCard(
                                    title: snap.data[i]['display_name'],
                                    description: snap.data[i]['last_message']
                                        ['message'],
                                    imgUrl: snap.data[i]['profile_photo'],
                                    is_new: snap.data[i] ==null? false : snap.data[i]['last_message']
                                                        ['viewed']
                                                    .toString() ==
                                                '0' &&
                                            snap.data[i]['last_message']
                                                    ['sender_id'] ==
                                                snap.data[i]['user_id']
                                        ? true
                                        : false,
                                    uid: snap.data[i]['user_id'],
                                  );
                                },
                              )
                            : const SpinKitDoubleBounce(
                                color: primaryColor,
                              );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
