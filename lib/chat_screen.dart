import 'package:chat_app/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({this.uid, Key? key}) : super(key: key);

  final String? uid;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  var username = "";

  @override
  void initState() {
    readUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            StreamBuilder<List<Message>>(
              stream: readChats(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final texts = snapshot.data!;
                  return ListView(
                    children: buildTexts(texts),
                  );
                } else {
                  return Text("");
                }
              },
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(width: 1, color: Colors.black),
                            color: const Color(0xffF0ECE2)),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 125,
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            controller: textController,
                            decoration: const InputDecoration.collapsed(
                              hintText: "Type here",
                              hintStyle: TextStyle(color: Color(0xff596E79)),
                            ),
                          ),
                        )),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xffC7B198))),
                        onPressed: () {
                          if (textController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text("Message can't be empty")));
                          } else {
                            createMessage(
                                text: textController.text, uid: widget.uid!);
                            textController.clear();
                          }
                        },
                        child: Container(
                          child: const Icon(
                            Icons.send,
                            color: Color(0xff596E79),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Padding(
              padding:
              const EdgeInsets.symmetric(vertical: 80.0, horizontal: 20.0),
              child: Align(
                alignment: Alignment.bottomLeft,
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
        ),
      ),
    );
  }

  createMessage({required String text, required String uid}) async {
    final chatsDocu = FirebaseFirestore.instance.collection('chats').doc();
    final message = Message(
        id: chatsDocu.id, senderId: uid, text: text, timestamp: DateTime.now(), username: username, groupId: "");
    final json = message.toJson();
    await chatsDocu.set(json);
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  List<Widget> buildTexts(List<Message> texts) {
    List<Widget> lis = [];
    for (int i = 0; i < texts.length; i++) {
      lis.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: texts[i].senderId == widget.uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Text(texts[i].senderId == widget.uid? "you: ": texts[i].username + " : "),
            Text(texts[i].text),
          ],
        ),
      ));
    }
    return lis;
  }

  readUsername() async{
    var un = "";
    await FirebaseFirestore.instance.collection('users').doc(widget.uid).get().then((value){
      un = value.data()!['username'];
      username = un;
    });
  }

  Stream<List<Message>> readChats() => FirebaseFirestore.instance
      .collection('chats')
      .orderBy('timestamp')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
}
