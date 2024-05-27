class StudentModel {
  String? name;
  String? email;
  String? address;
  String? image;

  StudentModel(
      {required this.name,
      required this.email,
      required this.address,
      required this.image});

  StudentModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    email = json["email"];
    address = json["address"];
    image = json["image"];
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "email": email, "address": address, "image": image};
  }
}
