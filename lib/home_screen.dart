import 'package:chat_app/chat_screen.dart';
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
          title: Text("Your Chats"),
          actions: [
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(Colors.blue)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CreateGroupScreen()),
                  );
                },
                child: Container(
                    child: const Text(
                      "Create Group",
                      style: TextStyle(color: Colors.white),
                    ))),
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
                        MaterialStateProperty.all(Color(0xffC7B198))),
                    onPressed: () {
                      _signOut();
                    },
                    child: Container(
                        child: const Text(
                          "Sign Out",
                          style: TextStyle(color: Color(0xff596E79)),
                        ))),
              ),
            ),
          ],
        )
    );
  }

  List<Widget> buildGroups(List<Group> texts) {
    List<Widget> lis = [Divider(
        color: Colors.black
    )];
    for (int i = 0; i < texts.length; i++) {
      lis.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child:
            GestureDetector(child: Row(
              children: [
                Text(texts[i].groupName),
              ],
            ),
              onTap:() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(uid: widget.uid, gid: texts[i].id,)),
                );},
        ),
      ));
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
