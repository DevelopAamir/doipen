import 'package:doipen/src/Authentication/helpers/auth_helpers.dart';
import 'package:doipen/src/SharedWidgets/ProfileCard.dart';
import 'package:doipen/src/SharedWidgets/progressindicator.dart';
import 'package:doipen/src/dashboard/helpers/confirm.dart';
import 'package:doipen/src/dashboard/ui_helpers/profileInfocard.dart';
import 'package:doipen/src/providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Authentication/helpers/uploadResume.dart';
import '../../constants/colors.dart';
import '../helpers/posts_handlers.dart';
import '../ui_helpers/VideoCard.dart';

class Profile extends StatefulWidget {
  final name;
  final role;
  final photo;
  final userEmail;
  final id;
  final followers;
  final isSubpage;
  const Profile({Key? key, this.name, this.role, this.photo, this.userEmail, this.id, this.followers, this.isSubpage= false}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var data;
  bool visible = false;
  getProfile()async{
    data = await AuthHelpers().getProfileAllData(widget.id);
    print(data);
    if(mounted)
    setState(() {

    });
  }
  @override
  void initState() {
    getProfile();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    print(widget.role);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomProgressIndicator(
            visibility: visible,
            child: SingleChildScrollView(
              child: data == null? Container(): Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfileCard(
                    username: widget.name,
                    userType: widget.role,
                    photo_url: data['pro_picture'],
                    notCurrentUser: Provider.of<StateManagement>(context,listen: false).currentUser !=  widget.userEmail,
                    isSubpage: true,
                    followers: widget.followers,

                  ),
                  const SizedBox(
                    height: 25,
                  ),

                   Card(
                    color: primaryColor.withOpacity(.70),
                    child:   ListTile(
                      title:  const Text('First Name : ',style: TextStyle(color: Colors.white),),
                      trailing: Text(data['first_name'],style: const TextStyle(color: Colors.white),),
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Card(
                    color: primaryColor.withOpacity(.70),
                    child:   ListTile(
                      title:  const Text('Last Name : ',style: TextStyle(color: Colors.white),),
                      trailing: Text(data['last_name'],style: const TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),

                  Card(
                    color: primaryColor.withOpacity(.70),
                    child:   ListTile(
                      title:  const Text('Email : ',style: TextStyle(color: Colors.white),),
                      trailing: Text(data['email'],style: const TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Card(
                    color: primaryColor.withOpacity(.70),
                    child:   ListTile(
                      title:  const Text('Phone No : ',style: TextStyle(color: Colors.white),),
                      trailing: Text(data['jobsearch_field_user_phone'],style: const TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Card(
                    color: primaryColor.withOpacity(.70),
                    child:   ListTile(
                      title:  const Text('Profile Url : ',style: TextStyle(color: Colors.white),),
                      trailing: OutlinedButton(child: const Text('view',style:  TextStyle(color: Colors.white),),onPressed: (){

                          launchUrl(Uri.parse('https://'+data['profile'].toString().split('://').last));
                      },)
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),

                  Card(
                    color: primaryColor.withOpacity(.70),
                    child:   ListTile(
                      title:  Text(data['resume'].toString() == 'null'? 'No Resume Uploaded' : 'Resume',style: const TextStyle(color: Colors.white),),
                      trailing: const Icon(Icons.download),
                      onTap: ()async{
                        setState(() {
                          visible = true;
                        });
                        await openFile(data['resume'].toString());
                        setState(() {
                          visible = false;
                        });
                        //launchUrl(Uri.parse());
                      },
                    ),
                  ),

                  const SizedBox(height: 25,),

                   Padding(
                    padding: EdgeInsets.only(bottom: 25.0,left: 8),
                    child:  Text("${data['first_name']}'s Uploads",style: TextStyle(color: primaryColor,fontSize: 20,fontWeight: FontWeight.w700)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 400,
                      child: FutureBuilder(
                        future: PostHandler().getPost(id : widget.id),
                        builder: (context, AsyncSnapshot snapshot) =>
                        !snapshot.hasData
                            ? const Center(
                          child: SpinKitDoubleBounce(
                            color: primaryColor,
                          ),
                        )
                            : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!['posts'].length,
                            itemBuilder: (context, i) {
                              return VideoCard(
                                data: snapshot.data!['posts'][i],
                                id: snapshot.data!['posts'][i]['ID'],
                                title: snapshot.data['posts'][i]
                                ['post_title'],
                                url: snapshot.data['posts'][i]['guid'],
                                posted_by: snapshot.data['posts'][i]
                                ['post_author'],
                                fromProfile: true,
                                onDelete: () async {
                                  await showConfirm(
                                    context,
                                        () async {
                                      Navigator.pop(context);
                                      await PostHandler()
                                          .deletePost(
                                          id: snapshot
                                              .data['posts']
                                          [i]['ID'],
                                          refresh: (a) {
                                            setState(
                                                  () {

                                              },
                                            );
                                          },
                                          context: context);
                                    },
                                  );
                                },
                              );
                            }),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
