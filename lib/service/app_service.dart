import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:record_project/model/student_model.dart';

class AppService {
  String imageName = DateTime.now().microsecondsSinceEpoch.toString();
  String url = "";
  Reference firebaseStorage = FirebaseStorage.instance.ref();
  String collectionRef = "students";
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference<StudentModel> studentRef =
      firestore.collection(collectionRef).withConverter<StudentModel>(
            fromFirestore: (snapshot, options) =>
                StudentModel.fromJson(snapshot.data() ?? {}),
            toFirestore: (value, options) => value.toJson(),
          );

  addImage(image, BuildContext context) async {
    Reference imageFolder = firebaseStorage.child('images');
    Reference uploadedImage = imageFolder.child("$imageName.jpg");
    try {
      await uploadedImage.putFile(image);
      url = await uploadedImage.getDownloadURL();
      print(url);
    } catch (e) {
      return [];
    }
  }

  updateImage(imageurl, updateimage, BuildContext context) async {
    try {
      Reference editImage = FirebaseStorage.instance.refFromURL(imageurl);
      await editImage.putFile(updateimage);
      url = await editImage.getDownloadURL();
    } catch (e) {
      return [];
    }
  }

  deleteImage(imageurl, BuildContext context) async {
    try {
      Reference delete = FirebaseStorage.instance.refFromURL(imageurl);
      await delete.delete();
    } catch (e) {
      return [];
    }
  }
  //.........................................................................................

  Future<void> addData(StudentModel model) async {
    await studentRef.add(model);
  }

  Stream<QuerySnapshot<StudentModel>> getData() {
    return studentRef.snapshots();
  }

  Future<void> deleteData(String id) async {
    await studentRef.doc(id).delete();
  }

  Future updateData(StudentModel model, String id) async {
    studentRef.doc(id).update(model.toJson());
  }
}
