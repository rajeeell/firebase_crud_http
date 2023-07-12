import 'dart:convert';

import 'package:firebase_crud_http/provider/crud_operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;

class AddNewUserScreen extends StatefulWidget {
  final User? user;
  const AddNewUserScreen({Key? key, this.user}) : super(key: key);

  @override
  State<AddNewUserScreen> createState() => _AddNewUserScreenState();
}

class _AddNewUserScreenState extends State<AddNewUserScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CRUDOperationProvider>(context);
    if (widget.user != null) {
      provider.usernameController =
          TextEditingController(text: widget.user!.userName);
      provider.emailController =
          TextEditingController(text: widget.user!.email);
      provider.phoneNumberController =
          TextEditingController(text: widget.user!.phoneNumber);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add new user"),
      ),
      body: Form(
        key: provider.formKey,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                controller: provider.usernameController,
                cursorColor: Colors.black,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter username';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Username",
                  hintText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: provider.emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  } else if (!provider.emailRegExp.hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                cursorColor: Colors.black,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Email",
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: provider.phoneNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter phone number';
                  } else if (value.length < 10) {
                    return 'Please enter valid phone number';
                  }
                  return null;
                },
                keyboardType: TextInputType.phone,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Phone Number",
                  hintText: "Phone Number",
                  prefixIcon: const Icon(Icons.phone),
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : MaterialButton(
                      onPressed: () {
                        if (provider.formKey.currentState!.validate()) {
                          if (widget.user != null) {
                            print("edit user");
                            provider.updateUser(
                                context: context, id: widget.user!.docId);
                          } else {
                            provider.sendUserOnFirebase(context);
                          }
                        } else {}
                      },
                      color: Colors.red,
                      child: Text(
                        widget.user != null ? "Edit user" : "Add user",
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
