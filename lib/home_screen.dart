import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/colors.dart';
import 'package:chat_app/create_group_screen.dart';
import 'package:chat_app/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({this.uid, Key? key}) : super(key: key);

  final String? uid;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kColorDark,
          title: Text("Your Chats"),
          actions: [
            IconButton(onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateGroupScreen()),
              );
            }, icon: Icon(Icons.add, color: kBackgroundColor,))
          ],
        ),
        body: Stack(
          children: [
            StreamBuilder<List<Group>>(
              stream: readGroups(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {

                  final groups = snapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 150.0),
                    child: ListView(
                      children: buildGroups(groups),
                    ),
                  );
                } else {
                  print(widget.uid);
                  return Text("");
                }
              },
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(kColorDark)),
                    onPressed: () {
                      _signOut();
                    },
                    child: Container(
                        child: const Text(
                          "Sign Out",
                          style: TextStyle(color: kColorAppBarFont),
                        ))),
              ),
            ),
          ],
        )
    );
  }

  List<Widget> buildGroups(List<Group> groups) {
    List<Widget> lis = [];
    for (int i = 0; i < groups.length; i++) {
      lis.add(
            GestureDetector(child: Container(
               child: Padding(
                 padding: i > 0 ? const EdgeInsets.symmetric(horizontal: 10, vertical: 20) : const EdgeInsets.fromLTRB(10,30,10,20),
                 child: Text(groups[i].groupName),
               ),
            ),
              onTap:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(uid: widget.uid, gid: groups[i].id, groupName: groups[i].groupName,)),
                );},
        ),
      );
      lis.add(Divider(
          color: Colors.black
      ));
    }
    return lis;
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }


  Stream<List<Group>> readGroups() => FirebaseFirestore.instance
      .collection('groups')
      .where('users', arrayContains: widget.uid)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());
}
