import 'package:chat_app/resources/colors.dart';
import 'package:chat_app/resources/styles.dart';
import 'package:chat_app/screens/group_details_screen.dart';
import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({this.uid, this.gid, this.groupName, Key? key})
      : super(key: key);

  final String? uid;
  final String? gid;
  final String? groupName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final textController = TextEditingController();
  final scrollController = ScrollController();
  var username = "";

  @override
  void initState() {
    readUsername();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName!,
          style: TextStyle(color: kColorLight),
        ),
        backgroundColor: kColorDark,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => GroupDetailsScreen(groupName: widget.groupName, gid: widget.gid,)),
            );
          }, icon: Icon(Icons.info_outline, color: Colors.white,))
        ],
      ),
      backgroundColor: Color(0xffCDF0EA),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () {
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: StreamBuilder<List<Message>>(
                stream: readChats(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final texts = snapshot.data!;
                    if (scrollController.hasClients) {
                      final position =
                          scrollController.position.maxScrollExtent;
                      scrollController.jumpTo(position);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 120.0),
                      child: ListView(
                        controller: scrollController,
                        children: buildTexts(texts),
                      ),
                    );
                  } else {
                    print("hello");
                    return Text("");
                  }
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40.0, horizontal: 10.0),
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
                            color: kColorTextField),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 125,
                          child: TextField(
                            autofocus: true,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: textController,
                            decoration: const InputDecoration.collapsed(
                              hintText: "Type here",
                              hintStyle: TextStyle(color: Color(0xff596E79)),
                            ),
                          ),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: kColorDark,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(15)),
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
                            color: Colors.white,
                          ),
                        )),
                  ],
                ),
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
        id: chatsDocu.id,
        senderId: uid,
        text: text,
        timestamp: DateTime.now(),
        username: username,
        groupId: widget.gid!);
    final json = message.toJson();
    await chatsDocu.set(json);
  }

  List<Widget> buildTexts(List<Message> texts) {
    List<Widget> lis = [];
    for (int i = 0; i < texts.length; i++) {
      lis.add(Padding(
        padding: const EdgeInsets.only(top: 6, right: 8, left: 8),
        child: Row(
          mainAxisAlignment: texts[i].senderId == widget.uid
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  color: texts[i].senderId == widget.uid
                      ? kTextBubbleColor
                      : kColorDark,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: texts[i].senderId != widget.uid ? Text(texts[i].username,
                            style: kFontStyleChat): Container(),
                      ),
                      texts[i].text.length > 40
                          ? Container(
                              width: 230,
                              child: Text(texts[i].text,
                                  style: kFontStyleChat),
                            )
                          : texts[i].text.length < 15
                              ? Container(
                                  width: 120,
                                  child: Text(texts[i].text,
                                      style: kFontStyleChat),
                                )
                              : Container(
                                  child: Text(texts[i].text,
                                      style: kFontStyleChat),
                                ),
                    ],
                  )),
            ),
          ],
        ),
      ));
      if (i == texts.length - 1 && texts[i].senderId != widget.uid) {
        lis.add(SizedBox(
          height: 50,
        ));
        if (scrollController.hasClients) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      }
    }
    return lis;
  }

  readUsername() async {
    var un = "";
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get()
        .then((value) {
      un = value.data()!['username'];
      username = un;
    });
  }

  Stream<List<Message>> readChats() => FirebaseFirestore.instance
          .collection('chats')
          .where("groupId", isEqualTo: widget.gid)
          .snapshots()
          .map((snapshot) {
        var a =
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList();
        a.sort((a, b) {
          return a.timestamp.compareTo(b.timestamp);
        });
        return a;
      });
}
