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