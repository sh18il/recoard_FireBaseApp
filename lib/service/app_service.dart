import 'dart:io';

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

  Future<void> addImage(File image, BuildContext context) async {
    Reference imageFolder = firebaseStorage.child('images');
    Reference uploadedImage = imageFolder.child("$imageName.jpg");
    try {
      await uploadedImage.putFile(image);
      url = await uploadedImage.getDownloadURL();
      print(url);
    } catch (e) {
      _showErrorMessage(context, 'Failed to upload image: ${e.toString()}');
    }
  }

  Future updateImage(String imageurl, File updateimage, BuildContext context) async {
    try {
      Reference editImage = FirebaseStorage.instance.refFromURL(imageurl);
      await editImage.putFile(updateimage);
      url = await editImage.getDownloadURL();
    } catch (e) {
      // ignore: use_build_context_synchronously
      _showErrorMessage(context, 'Failed to update image: ${e.toString()}');
    }
  }

  Future<void> deleteImage(String imageurl, BuildContext context) async {
    try {
      Reference delete = FirebaseStorage.instance.refFromURL(imageurl);
      await delete.delete();
    } catch (e) {
      _showErrorMessage(context, 'Failed to delete image: ${e.toString()}');
    }
  }

  Future<void> addData(StudentModel model) async {
    try {
      await studentRef.add(model);
    } catch (e) {
      print('Failed to add data: ${e.toString()}');
    }
  }

  Stream<QuerySnapshot<StudentModel>> getData() {
    return studentRef.snapshots();
  }

  Future<void> deleteData(String id) async {
    try {
      await studentRef.doc(id).delete();
    } catch (e) {
      print('Failed to delete data: ${e.toString()}');
    }
  }

  Future<void> updateData(StudentModel model, String id) async {
    try {
      await studentRef.doc(id).update(model.toJson());
    } catch (e) {
      print('Failed to update data: ${e.toString()}');
    }
  }

  void _showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
