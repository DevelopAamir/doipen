import 'dart:async';
import 'dart:io';

import 'package:doipen/src/Chat/ui/ChatDashboard.dart';
import 'package:doipen/src/SharedWidgets/progressindicator.dart';
import 'package:doipen/src/constants/colors.dart';
import 'package:doipen/src/dashboard/helpers/confirm.dart';
import 'package:doipen/src/dashboard/helpers/dashboardhelper.dart';
import 'package:doipen/src/dashboard/helpers/getUser.dart';
import 'package:doipen/src/dashboard/helpers/posts_handlers.dart';
import 'package:doipen/src/dashboard/ui/profile.dart';
import 'package:doipen/src/dashboard/ui_helpers/VideoCard.dart';
import 'package:doipen/src/dashboard/ui_helpers/addPostDilaog.dart';
import 'package:doipen/src/SharedWidgets/ProfileCard.dart';
import 'package:doipen/src/Chat/ui_helpers/searchBar.dart';
import 'package:doipen/src/providers/provider.dart';
import 'package:doipen/src/utils/adstate.dart';
import 'package:doipen/src/utils/globalhelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatefulWidget {
  final page;
  const Dashboard({Key? key, this.page}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  bool visible = false;
  BannerAd? banner;
  InterstitialAd? interstitialAd;
  Widget? profile;

  @override
  void initState() {
    getUser(context).then((val){
      Provider.of<StateManagement>(context,listen: false).setProfile(val);
    });
    super.initState();
  }

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
        ..load();
      InterstitialAd.load(
          adUnitId: adState.interIntentialAd,
          request: AdRequest(),
          adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (a) {
                interstitialAd = a;
                interstitialAd!.show();
              },
              onAdFailedToLoad: (
                a,
              ) {}));
    });
    super.didChangeDependencies();
  }

  Future<bool> onwillPop()async{
    exit(0);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.page != null) {
      currentIndex = widget.page;
      if (mounted) {
        setState(() {});
      }
    }
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage(
                'assets/home.png',
              ),
              size: 30,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/add.png'),
              size: 30,
            ),
            label: 'Add Videos',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage('assets/message.png'),
              size: 30,
            ),
            label: 'Messages',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: primaryColor,
        onTap: (a) async {
          if (a == 1) {
            setState(() {
              visible = true;
            });
            await DashboardHelper().showAddPostDialog(context);
            setState(() {
              visible = false;
            });
            await getUser(context);
          } else {
            setState(() {
              currentIndex = a;
            });
          }
        },
        selectedIconTheme: const IconThemeData(size: 30),
      ),
      body: WillPopScope(
        onWillPop: onwillPop,
        child: SafeArea(
          child: CustomProgressIndicator(
            visibility: visible,
            child: RefreshIndicator(
              onRefresh: () async {

              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: currentIndex == 2
                    ? const ChatDashboard()
                    : Column(
                        children: [
                          context.watch<StateManagement>()
                              .profile!,
                          const SizedBox(
                            height: 30,
                          ),
                          if (banner == null)
                            const SizedBox(
                              height: 0,
                            )
                          else
                            Container(
                              height: banner!.size.height.toDouble(),
                              child: AdWidget(
                                ad: banner!,
                              ),
                            ),
                          const SizedBox(
                            height: 30,
                          ),
                          Expanded(
                            child: FutureBuilder(
                              future: PostHandler().getPost(),
                              builder: (context, AsyncSnapshot snapshot) =>
                                  !snapshot.hasData
                                      ? const Center(
                                          child: SpinKitDoubleBounce(
                                            color: primaryColor,
                                          ),
                                        )
                                      : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            snapshot.data!['posts'].length,
                                        itemBuilder: (context, i) {
                                          print(snapshot.data[i]);
                                          return VideoCard(
                                              data: snapshot.data!['posts'][i],
                                              id: snapshot.data['posts'][i]
                                                  ['ID'],
                                              title: snapshot.data['posts'][i]
                                                  ['post_title'],
                                              url: snapshot.data['posts'][i]
                                                  ['guid'],
                                              posted_by: snapshot.data['posts']
                                                  [i]['post_author'],
                                              onDelete: () async {
                                                await showConfirm(
                                                  context,
                                                  () async {
                                                    Navigator.pop(context);
                                                    await PostHandler()
                                                        .deletePost(
                                                            id: snapshot.data[
                                                                    'posts'][i]
                                                                ['ID'],
                                                            refresh: (a) {
                                                              setState(
                                                                () {
                                                                  visible = a;
                                                                },
                                                              );
                                                            },
                                                            context: context);
                                                  },
                                                );
                                              },
                                              followers: snapshot.data['posts']
                                                  [i]['followers']);
                                        },
                                      ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
