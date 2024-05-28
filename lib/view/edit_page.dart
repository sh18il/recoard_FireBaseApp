import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:record_project/controller/app_service_controller.dart';
import 'package:record_project/controller/image_controlls.dart';
import 'package:record_project/model/student_model.dart';
import 'package:record_project/service/app_service.dart';

class EditPage extends StatefulWidget {
  final String id;
  final StudentModel stmodel;
  const EditPage({super.key, required this.id, required this.stmodel});

  @override
  // ignore: library_private_types_in_public_api
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController addressCtrl;
  bool isNewImagePicked = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.stmodel.name);
    emailCtrl = TextEditingController(text: widget.stmodel.email);
    addressCtrl = TextEditingController(text: widget.stmodel.address);
    Provider.of<ImagesProvider>(context, listen: false).editPickedImage =
        File(widget.stmodel.image.toString());
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImagesProvider>(context, listen: false);
    log("editScreen");

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/iPhone.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Gap(20),
              Consumer<ImagesProvider>(builder: (context, pro, _) {
                return CircleAvatar(
                  backgroundColor: const Color.fromARGB(255, 211, 210, 206),
                  radius: 40,
                  backgroundImage: isNewImagePicked
                      ? FileImage(pro.editPickedImage!)
                      : widget.stmodel.image != null
                          ? NetworkImage(widget.stmodel.image.toString())
                              as ImageProvider
                          : null,
                );
              }),
              TextButton(
                onPressed: () async {
                  await provider.editPickImg();
                  setState(() {
                    isNewImagePicked = true;
                  });
                },
                child: const Text("Pick Image"),
              ),
              const Gap(20),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: nameCtrl,
                decoration: InputDecoration(
                  label: const Text("Name"),
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const Gap(15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: emailCtrl,
                decoration: InputDecoration(
                  label: const Text("Email"),
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const Gap(15),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: addressCtrl,
                decoration: InputDecoration(
                  label: const Text("Address"),
                  labelStyle: const TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const Gap(15),
              ElevatedButton(
                onPressed: () async {
                  await editStudentData(context);
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> editStudentData(BuildContext context) async {
    AppService services = AppService();
    final provider = Provider.of<StudentController>(context, listen: false);
    final imageProvider = Provider.of<ImagesProvider>(context, listen: false);

    String imageUrl = widget.stmodel.image.toString();
    if (isNewImagePicked) {
      imageUrl = await services.updateImage(
          imageUrl, File(imageProvider.editPickedImage!.path), context);
    }

    final newData = StudentModel(
      name: nameCtrl.text,
      email: emailCtrl.text,
      address: addressCtrl.text,
      image: imageUrl,
    );

    await provider.updateStudent(context, newData, widget.id);
    Navigator.pop(context);
  }
}
