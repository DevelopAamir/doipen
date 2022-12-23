import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final storage = const FlutterSecureStorage();
  store(key, value) async {
    await storage.write(key: key, value: value);
  }
  Future read(key)async{
    return await storage.read(key: key);
  }
  delete(key)async{
    await storage.delete(key: key);
  }
  Future deleteAll()async{

     await storage.deleteAll();
  }
}
