import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:record_project/model/student_model.dart';
import 'package:record_project/service/app_service.dart';

class StudentController extends ChangeNotifier {
  AppService service = AppService();

  Future<void> addStudent(BuildContext context, StudentModel model) async {
    try {
      await service.addData(model);
      notifyListeners();
      showMessage(context, "Student added successfully");
    } catch (e) {
      showMessage(context, "Error adding student: ${e.toString()}");
    }
  }

  Stream<QuerySnapshot<StudentModel>> getStudents() {
    return service.getData();
  }

  Future<void> deleteStudent(BuildContext context, String id) async {
    try {
      await service.deleteData(id);
      notifyListeners();
      showMessage(context, "Student deleted successfully");
    } catch (e) {
      showMessage(context, "Error deleting student: ${e.toString()}");
    }
  }

  Future<void> updateStudent(BuildContext context, StudentModel model, String id) async {
    try {
      await service.updateData(model, id);
      notifyListeners();
      showMessage(context, "Student updated successfully");
    } catch (e) {
      showMessage(context, "Error updating student: ${e.toString()}");
    }
  }

 static void showMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
