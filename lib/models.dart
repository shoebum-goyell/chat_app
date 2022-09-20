import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  final String senderId;
  final String username;
  final DateTime timestamp;
  final String groupId;
  final String text;

  Message(
      {this.id = '',
        required this.text,
        required this.username,
        required this.senderId,
        required this.groupId,
        required this.timestamp});

  Map<String, dynamic> toJson() => {
        'id': id,
        'senderId': senderId,
        'text': text,
        'timestamp': timestamp,
        'username': username,
        'groupId' : groupId
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
      id: json['id'],
      senderId: json['senderId'],
      username: json['username'],
      groupId: json['groupId'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate());
}

class UserObj {
  String uid;
  final String username;
  final List<String> groups;

  UserObj({
    this.uid = '',
    required this.username,
    required this.groups,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
        'groups': groups,
      };

  static UserObj fromJson(Map<String, dynamic> json) => UserObj(
      uid: json['uid'],
      username: json['username'],
      groups: json['groups']);
}
