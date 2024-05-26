import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record_project/service/app_service.dart';

class ImagesProvider extends ChangeNotifier {
  AppService service = AppService();
  File? pickedImage;
  File? editPickedImage;
  ImagePicker image = ImagePicker();

  Future<void> pickImg() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    pickedImage = File(img!.path);
    notifyListeners();
  }

  Future<void> editPickImg() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    editPickedImage = File(img!.path);
    notifyListeners();
  }

  void clearPickedImage() {
    pickedImage = null;
    notifyListeners();
  }

  void clearEditImage() {
    editPickedImage = null;
    notifyListeners();
  }
  
}
