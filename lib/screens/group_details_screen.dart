import 'package:chat_app/resources/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class GroupDetailsScreen extends StatefulWidget {

  const GroupDetailsScreen({this.groupName,this.gid, Key? key}) : super(key: key);

  final String? groupName;
  final String? gid;

  @override
  State<GroupDetailsScreen> createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  List<String> group_users = [];

  @override
  void initState() {
    readGroup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorDark,
      appBar: AppBar(
        backgroundColor: kColorDark,
        title: Text(
          widget.groupName! + " Info",
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
                    Padding(padding: const EdgeInsets.only(top:20.0),
                        child: Text("Users: ", style: TextStyle(color: Colors.white, fontSize: 24),)
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:60.0, bottom: 40.0),
                      child: ListView(
                          children: buildUsers(group_users),
                        ),
                    )
            ],
          ),
        ),
      ),
    );
  }



  List<Widget> buildUsers(List<String> users) {
    List<Widget> lis = [];
    for (int i = 0; i < users.length; i++) {
        lis.add(Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15),
          child: RichText(
              text: TextSpan(
                  text: users[i].substring(0, users[i].length-4),
                  style: TextStyle(color: kColorLight, fontSize: 20),
                  children: [
                    TextSpan(text: "#" + users[i].substring(users[i].length-4,users[i].length), style: TextStyle(color: Colors.grey))
                  ]
              ),
            ),
        ));
      }
    return lis;
    }


  readGroup() async {
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(widget.gid)
        .get()
        .then((value) {
      List<String> users = List<String>.from(value['users']);
      for(int i = 0; i<users.length; i++){
        readUser(users[i]);
      }
    });
  }

  readUser(String userid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userid)
        .get()
        .then((value) {
      setState((){
       group_users.add(value['username'] + value['uid'].toString().substring(1,5));
      });
    });
  }

}
