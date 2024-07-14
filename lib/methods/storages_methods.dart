import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

import 'package:uuid/uuid.dart';
class StoragesMethods{
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  pickImage(ImageSource source)async{
    final ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: source);
    if(image != null){
      Uint8List imageAsBytes = await image.readAsBytes();
      return imageAsBytes;
    }else{
      print('Np Image Selected');
    }
  }

  Future<String> uploadImage(String childName, Uint8List image, bool isPost)async{
    Reference reference = firebaseStorage.ref().child(childName).child(auth.currentUser!.uid);
    if(isPost){
      String id = const Uuid().v1();
      reference.child(id);
    }
    UploadTask uploadTask = reference.putData(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    String url = await taskSnapshot.ref.getDownloadURL();
    return url;

  }
}