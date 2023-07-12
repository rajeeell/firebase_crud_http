import 'dart:convert';

import 'package:firebase_crud_http/provider/crud_operation_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import '../widgets/uses_tile.dart';
import 'add_new_user_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<CRUDOperationProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Firestore CRUD Operation"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddNewUserScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.fetchUser(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (context, index) {
              return UserTile(user: provider.list[index]);
            },
            itemCount: provider.list.length,
          ),
        ),
      ),
    );
  }
}
