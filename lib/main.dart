import 'package:doipen/src/dashboard/helpers/getUser.dart';
import 'package:doipen/src/providers/provider.dart';
import 'package:doipen/src/utils/adstate.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:doipen/src/Authentication/ui/login.dart';
import 'package:doipen/src/constants/colors.dart';
import 'package:doipen/src/dashboard/ui/Dashboard.dart';
import 'package:doipen/src/utils/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  final initFuture = MobileAds.instance.initialize();

  await Firebase.initializeApp();

  runApp(

      MultiProvider(
        providers: [
          Provider<StateManagement>(create: (_) => StateManagement()),
          Provider<AdState>(create: (_) => AdState(initFuture)),
        ],

        child: const MyApp(),
      )
       );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'doipen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primarySwatch,
      ),
      routes: {
        '/dashboard': (context) => Dashboard(),
      },
      home: const Initialization(),
    );
  }
}

//Checking is user loggedIn or not
class Initialization extends StatefulWidget {
  const Initialization({Key? key}) : super(key: key);

  @override
  State<Initialization> createState() => _InitializationState();
}

class _InitializationState extends State<Initialization> {
  _redirect() async {

    await Storage().read('token').then((value)async{
      if(value !=null) {
        await getUser(context).then((value){
        Provider.of<StateManagement>(context,listen: false).setProfile(value);
      });
      }
      print(value);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return value == null ? const Login() : const Dashboard();
      }));
    });
  }

  @override
  void initState() {
    _redirect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitDoubleBounce(
          color: primaryColor,
        ),
      ),
    );
  }
}
