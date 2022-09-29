import 'package:chat_app/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({this.uid, Key? key}) : super(key: key);

  final String? uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var username = "";
  var hash = "";

  @override
  void initState() {
    readUsernameandHash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorDark,
        title: Text("Profile"),
      ),
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                  text:username,
                  style: TextStyle(color: kColorDark, fontSize: 25),
                  children: [
                    TextSpan(text: "#" + hash, style: TextStyle(color: Colors.grey))
                  ]
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
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
        ),
      ),
    );
  }

  readUsernameandHash() async {
    var un = "";
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((value) {
      un = value.data()!['username'];
      setState((){
        hash = widget.uid!.substring(1,5);
        username = un;
      });
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }


}
