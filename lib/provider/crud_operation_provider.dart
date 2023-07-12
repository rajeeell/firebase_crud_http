import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/user.dart';

class CRUDOperationProvider extends ChangeNotifier {
  CRUDOperationProvider() {
    fetchUser();
  }

  late List<User> list;
  final formKey = GlobalKey<FormState>();
  final emailRegExp = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  bool isLoading = false;

  sendUserOnFirebase(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    //send user
    final response = await http.post(
        Uri.parse(
            "https://demodemo-f0668-default-rtdb.firebaseio.com/users.json"),
        body: jsonEncode({
          "name": usernameController.text,
          "email": emailController.text,
          "phone_number": phoneNumberController.text,
        }));

    if (response.statusCode == 200) {
      usernameController = TextEditingController();
      emailController = TextEditingController();
      phoneNumberController = TextEditingController();
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode("Data added")),
        backgroundColor: Colors.green,
      ));
      fetchUser();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode(response.body)["error"]),
        backgroundColor: Colors.red,
      ));
    }

    isLoading = false;
    notifyListeners();
    // print(response.id);
  }

  updateUser({required String id, required BuildContext context}) async {
    //update user
    final response = await http.patch(
        Uri.parse(
            "https://demodemo-f0668-default-rtdb.firebaseio.com/users${id}.json"),
        body: jsonEncode({
          "name": usernameController.text,
          "email": emailController.text,
          "phone_number": phoneNumberController.text,
        }));
    if (response.statusCode == 200) {
      usernameController = TextEditingController();
      emailController = TextEditingController();
      phoneNumberController = TextEditingController();
      isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode("Data added")),
        backgroundColor: Colors.green,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode(response.body)["error"]),
        backgroundColor: Colors.red,
      ));
    }
    print(response.body);
  }

  fetchUser() async {
    list = [];
    final response = await http.get(Uri.parse(
        "https://demodemo-f0668-default-rtdb.firebaseio.com/users.json"));
    final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
    extractedData.forEach((key, value) {
      list.add(User(
          email: value["email"],
          phoneNumber: value["phone_number"],
          userName: value["name"],
          docId: key));
    });
    notifyListeners();
    print(response.body);
  }

  deleteUser({required String id, required BuildContext context}) async {
    final response = await http.delete(Uri.parse(
        "https://demodemo-f0668-default-rtdb.firebaseio.com/users/${id}.json"));

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(("Data deleted")),
        backgroundColor: Colors.green,
      ));
      fetchUser();  
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonDecode(response.body)["error"]),
        backgroundColor: Colors.red,
      ));
    }
  }
}
