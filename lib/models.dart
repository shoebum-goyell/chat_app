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

  UserObj({
    this.uid = '',
    required this.username,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'username': username,
      };

  static UserObj fromJson(Map<String, dynamic> json) => UserObj(
      uid: json['uid'],
      username: json['username']); //won't work because of some issue, converting to list needs to be done
}

class Group {
  String id;
  final String groupName;
  final List<String> users;

  Group({
    this.id = '',
    required this.groupName,
    required this.users
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'groupName': groupName,
    'users' : users
  };

  static Group fromJson(Map<String, dynamic> json) => Group(
      id: json['id'],
      groupName: json['groupName'],
      users: List<String>.from(json['users'])
  );
}