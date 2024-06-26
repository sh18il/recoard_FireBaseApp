import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:record_project/controller/app_service_controller.dart';
import 'package:record_project/model/student_model.dart';
import 'package:record_project/service/app_service.dart';
import 'package:record_project/view/add_page.dart';
import 'package:record_project/view/edit_page.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    log("home_screen");
    final provider = Provider.of<StudentController>(context, listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
          backgroundColor: const Color.fromARGB(255, 78, 88, 94),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddPage(),
            ));
          }),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/wliStZ.jpg'),
              fit: BoxFit.fill,
            ),
          ),
          child: StreamBuilder(
            stream: provider.getStudents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                List<QueryDocumentSnapshot<StudentModel>> studentDoc =
                    snapshot.data?.docs ?? [];
                if (studentDoc.isEmpty) {
                  return const Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: studentDoc.length,
                  itemBuilder: (context, index) {
                    final id = studentDoc[index].id;
                    final data = studentDoc[index].data();
                    return Card(
                      color: const Color.fromARGB(255, 104, 126, 144),
                      elevation: BorderSide.strokeAlignOutside,
                      shadowColor: Colors.grey,
                      child: SizedBox(
                        height: 100,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Image.network(
                                  data.image.toString(),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    data.name ?? "",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        provider.deleteStudent(context, id);
                                        AppService().deleteImage(
                                            data.image.toString(), context);
                                      },
                                      icon: const Icon(Icons.delete)),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                          builder: (context) => EditPage(
                                              id: id,
                                              stmodel: StudentModel(
                                                  name: data.name,
                                                  email: data.email,
                                                  address: data.address,
                                                  image: data.image)),
                                        ));
                                      },
                                      icon: const Icon(Icons.edit))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
