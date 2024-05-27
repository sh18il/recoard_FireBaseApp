import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:record_project/controller/app_service_controller.dart';
import 'package:record_project/controller/image_controlls.dart';
import 'package:record_project/model/student_model.dart';
import 'package:record_project/service/app_service.dart';

class AddPage extends StatelessWidget {
  AddPage({super.key});

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log("addScreeen");

    return SafeArea(
      child: PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          Provider.of<ImagesProvider>(context, listen: false)
              .clearPickedImage();
        },
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/iPhone.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Gap(20),
                    Consumer<ImagesProvider>(
                      builder: (context,pro,_) {
                        return FutureBuilder(
                          future: Future.value(
                            pro
                                  .pickedImage),
                          builder: (context, snapshot) {
                            return CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 125, 124, 122),
                              radius: 40,
                              backgroundImage: snapshot.data != null
                                  ? FileImage(snapshot.data!)
                                  : null,
                            );
                          },
                        );
                      }
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<ImagesProvider>(context, listen: false)
                            .pickImg();
                      },
                      child: const Text("Pick Image"),
                    ),
                    const Gap(20),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const Gap(15),
                    TextFormField(
                      controller: emailCtrl,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        return null;
                      },
                    ),
                    const Gap(15),
                    TextFormField(
                      controller: addressCtrl,
                      decoration: InputDecoration(
                        labelText: "Address",
                        labelStyle: const TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.white),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an address';
                        }
                        return null;
                      },
                    ),
                    const Gap(15),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          add(context);
                        }
                      },
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> add(BuildContext context) async {
    AppService services = AppService();
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);
    await services.addImage(File(imageProvider.pickedImage!.path), context);
    final pro = Provider.of<StudentController>(context, listen: false);
    final stModel = StudentModel(
      name: nameCtrl.text,
      email: emailCtrl.text,
      address: addressCtrl.text,
      image: services.url,
    );

    await pro.addStudent(context, stModel);
    imageProvider.clearPickedImage();
    Navigator.pop(context);
  }
}
