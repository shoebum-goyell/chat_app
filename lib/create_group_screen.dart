import 'package:chat_app/colors.dart';
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
  var bool_users = [];
  List<String> group_users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kColorDark,
        title: const Text(
          "Create Group",
          style: TextStyle(color: kColorAppBarFont),
        ),
        centerTitle: true,
      ),
      body: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Stack(
            children: [
              StreamBuilder<List<UserObj>>(
                stream: readUsers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print('ok');
                    final users = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.only(top:140.0),
                      child: Container(
                        height: 300,
                        child: ListView(
                          children: buildUsers(users),
                        ),
                      ),
                    );
                  } else {
                    return Text("");
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(width: 1, color: Colors.black),
                          color: kColorTextField),
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
                            MaterialStateProperty.all(kColorDark)),
                        onPressed: () {
                          createGroup();
                        },
                        child: Container(
                            child: const Text(
                              "Create",
                              style: TextStyle(color: kColorAppBarFont),
                            ))),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  createGroup() async {
    final groupsDocu = FirebaseFirestore.instance.collection('groups').doc();
    final group = Group(id: groupsDocu.id, groupName: group_name, users: group_users);
    final json = group.toJson();
    await groupsDocu.set(json);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Group created")));
    Navigator.pop(context);
  }


  List<Widget> buildUsers(List<UserObj> users) {
    List<Widget> lis = [];
    for (int i = 0; i < users.length; i++) {
      bool_users.add(false);
      lis.add(CheckboxListTile(
          activeColor: kColorDark,
          contentPadding: EdgeInsets.zero,
          title: Text(users[i].username),
          value: bool_users[i],
          onChanged: (bool? value){
            setState(() {
              bool_users[i] = value;
              if(value == true){
                group_users.add(users[i].uid);
              }
              else{
                var ind = group_users.remove(users[i].uid);
              }
            });
          },
        ));
    }
    return lis;
  }

  Stream<List<UserObj>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => UserObj.fromJson(doc.data())).toList());

}

