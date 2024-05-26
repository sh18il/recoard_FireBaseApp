import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart';
import 'package:record_project/model/student_model.dart';
import 'package:record_project/service/app_service.dart';

class StudentController extends ChangeNotifier {
  AppService service = AppService();
  Future<void> addStudent(model) async {
    await service.addData(model);
    notifyListeners();
  }

  Stream<QuerySnapshot<StudentModel>> getStudents()  {
    return service.getData();
   
  }

  Future<void> deleteStudent(String id) async {
    await service.deleteData(id);
    notifyListeners();
  }

  Future<void> updateStudent(model, id) async {
    await service.updateData(model, id);
    notifyListeners();
  }
}
