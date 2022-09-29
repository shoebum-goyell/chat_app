import 'package:chat_app/chat_screen.dart';
import 'package:chat_app/colors.dart';
import 'package:chat_app/create_group_screen.dart';
import 'package:chat_app/models.dart';
import 'package:chat_app/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
        backgroundColor: Color(0xffCDF0EA),
        appBar: AppBar(
          backgroundColor: kColorDark,
          title: Text("Your Chats"),
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileScreen(uid: widget.uid)),
              );
            },
            child: Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateGroupScreen(uid: widget.uid)),
                  );
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ))
          ],
        ),
        body: Stack(
          children: [
            StreamBuilder<List<Group>>(
              stream: readGroups(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final groups = snapshot.data!;
                  groups.sort((a, b) {
                    return a.groupName
                        .toLowerCase()
                        .compareTo(b.groupName.toLowerCase());
                  });
                  if (groups.length == 0) {
                    return Center(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CreateGroupScreen(uid: widget.uid)),
                              );
                            },
                            child: Text(
                              "Click on the + icon to create a new group",
                              style: TextStyle(color: kColorDark, fontSize: 16),
                            )));
                  } else {
                    return ListView(
                      children: buildGroups(groups),
                    );
                  }
                } else {
                  print(widget.uid);
                  return Text("");
                }
              },
            ),
          ],
        ));
  }

  List<Widget> buildGroups(List<Group> groups) {
    List<Widget> lis = [];
    var width = MediaQuery.of(context).size.width;
    for (int i = 0; i < groups.length; i++) {
      lis.add(
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 6),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6, top: 7),
                child: Container(
                    decoration: BoxDecoration(
                        color: kColorDark,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: width - 10,
                    height: 70),
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: kColorDark,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 25),
                      child: Text(groups[i].groupName,
                          style: GoogleFonts.lexendDeca(
                              textStyle:
                                  TextStyle(color: kColorDark, fontSize: 16))),
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(
                              uid: widget.uid,
                              gid: groups[i].id,
                              groupName: groups[i].groupName,
                            )),
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
    return lis;
  }

  Stream<List<Group>> readGroups() => FirebaseFirestore.instance
      .collection('groups')
      .where('users', arrayContains: widget.uid)
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Group.fromJson(doc.data())).toList());
}
