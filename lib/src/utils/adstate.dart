import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initialization;
  AdState(this.initialization);
  String get bannerdUnitID => 'ca-app-pub-3940256099942544/6300978111';    //ca-app-pub-9205086316490823/1637899892  TODO Replace with it
  String get interIntentialAd => 'ca-app-pub-3940256099942544/8691691433';  //ca-app-pub-9205086316490823/3241559945  TODO Replace with it
}
