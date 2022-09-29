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
      username: json['username']);
}
