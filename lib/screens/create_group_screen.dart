import 'package:chat_app/resources/colors.dart';
import 'package:chat_app/models/user_obj.dart';
import 'package:chat_app/models/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class CreateGroupScreen extends StatefulWidget {

  const CreateGroupScreen({this.uid, Key? key}) : super(key: key);

  final String? uid;

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  var group_name = "";
  var bool_users = [];
  List<String> group_users = [];
  bool isLoading = false;

  @override
  void initState() {
    group_users.add(widget.uid!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kThemeColor,
      appBar: AppBar(
        backgroundColor: kColorDark,
        title: const Text(
          "Create Group",
          style: TextStyle(color: kColorLight),
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
                    users.sort((a, b) {
                      return a.username.toLowerCase().compareTo(b.username.toLowerCase());
                    });
                    return Padding(
                      padding: const EdgeInsets.only(top:110.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kColorDark,
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        height: MediaQuery.of(context).size.height - 340,
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
                padding: const EdgeInsets.only(top: 30.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(width: 1, color: Colors.black),
                            color: kColorTextField),
                        child: TextField(
                            autocorrect: false,
                            keyboardType: TextInputType.text,
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
                    )),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: !isLoading? ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(kColorDark)),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          createGroup();
                        },
                        child: Container(
                            child: const Text(
                              "Create",
                              style: TextStyle(color: kColorLight),
                            ))) : SizedBox(height: 25, width: 25, child: CircularProgressIndicator(color: kColorDark, strokeWidth: 2,)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  createGroup() async {
    if(group_name.trim().isEmpty){
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Group name cannot be empty")));
      setState(() {
        isLoading = false;
      });
    }
    else{
      final groupsDocu = FirebaseFirestore.instance.collection('groups').doc();
      final group = Group(id: groupsDocu.id, groupName: group_name, users: group_users);
      final json = group.toJson();
      await groupsDocu.set(json);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Group created")));
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    }
  }


  List<Widget> buildUsers(List<UserObj> users) {
    List<Widget> lis = [];
    for (int i = 0; i < users.length; i++) {
      bool_users.add(false);
      if(users[i].uid != widget.uid){
        lis.add(Padding(
          padding: const EdgeInsets.only(top: 6.0, left: 15, right: 15),
            child: CheckboxListTile(
              activeColor: kColorDark,
              contentPadding: EdgeInsets.zero,
              title: RichText(
                text: TextSpan(
                  text: users[i].username,
                  style: TextStyle(color: kColorLight),
                  children: [
                    TextSpan(text: "#" + users[i].uid.substring(1,5), style: TextStyle(color: Colors.grey))
                  ]
                ),
              ),
              value: bool_users[i],
              onChanged: (bool? value){
                setState(() {
                  bool_users[i] = value;
                  if(value == true){
                    group_users.add(users[i].uid);
                  }
                  else{
                    group_users.remove(users[i].uid);
                  }
                });
              },
            ),
          ));
      }
    }
    return lis;
  }

  Stream<List<UserObj>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => UserObj.fromJson(doc.data())).toList());

}

