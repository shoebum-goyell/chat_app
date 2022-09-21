import 'package:chat_app/login_screen.dart';
import 'package:chat_app/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CreateGroupScreen extends StatefulWidget {

  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  var group_name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff596E79),
      appBar: AppBar(
        backgroundColor: const Color(0xffC7B198),
        title: const Text(
          "Create Group",
          style: TextStyle(color: Color(0xff596E79)),
        ),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(width: 1, color: Colors.black),
                    color: const Color(0xffC7B198)),
                child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration.collapsed(
                      hintText: "Group name",
                      hintStyle: TextStyle(color: Color(0xff596E79)),
                    ),
                    onChanged: (text) {
                      setState(() {
                        group_name = text;
                      });
                    }),
              ),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(Color(0xffC7B198))),
                  onPressed: () {
                    createGroup();
                  },
                  child: Container(
                      child: const Text(
                        "Create",
                        style: TextStyle(color: Color(0xff596E79)),
                      ))),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  createGroup() async {
    final groupsDocu = FirebaseFirestore.instance.collection('groups').doc();
    final group = Group(id: groupsDocu.id, groupName: group_name, users: []);
    final json = group.toJson();
    await groupsDocu.set(json);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Group created")));
    Navigator.pop(context);
  }
}

