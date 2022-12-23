import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';


Future upload(File file)async{
  final storage = FirebaseStorage.instance;
  var url;
  try{
    await storage.ref('Files/' + file.path.split('/').last).putFile(file).then((p0)async{
      url =await p0.ref.getDownloadURL();
    });

  }catch(e){
    Fluttertoast.showToast(msg: e.toString());
  }
  return url;

}


selectFile()async{
  final file = await FilePicker.platform.pickFiles(type: FileType.video);

  return File(file!.files.last.path.toString());

}

recordFile()async{
  final ImagePicker _picker = ImagePicker();

  final XFile? file = await _picker.pickVideo(source: ImageSource.camera);
  return File(file!.path.toString());

}