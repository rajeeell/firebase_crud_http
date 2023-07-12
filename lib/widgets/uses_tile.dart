import 'dart:convert';

import 'package:firebase_crud_http/provider/crud_operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import '../screens/add_new_user_screen.dart';
import 'package:http/http.dart' as http;

class UserTile extends StatelessWidget {
  final User user;
  const UserTile({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CRUDOperationProvider>(context);
    return Card(
      child: ListTile(
        title: Text(user.userName),
        subtitle: Text("${user.email},\n${user.phoneNumber}"),
        trailing: SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddNewUserScreen(
                        user: user,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () async {
                  //delete user
                  provider.deleteUser(id: user.docId, context: context);
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
