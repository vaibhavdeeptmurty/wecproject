class ChatUser {
  ChatUser({
    required this.image,
    required this.name,
    required this.about,
    required this.createdAt,
    required this.id,
    required this.isOnline,
    required this.lastActive,
    required this.pushToken,
    required this.email,
  });
  late final String image;
  late final String name;
  late final String about;
  late final String createdAt;
  late final String id;
  late final bool isOnline;
  late final String lastActive;
  late final String pushToken;
  late final String email;

  ChatUser.fromJson(Map<String, dynamic> json){
    image = json['image']?? "";
    name = json['name']?? "";
    about = json['about']?? "";
    createdAt = json['created_at']?? "";
    id = json['id']?? "";
    isOnline = json['is_online']?? "";
    lastActive = json['last_active']?? "";
    pushToken = json['push_token']?? "";
    email = json['email']?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['image'] = image;
    _data['name'] = name;
    _data['about'] = about;
    _data['created_at'] = createdAt;
    _data['id'] = id;
    _data['is_online'] = isOnline;
    _data['last_active'] = lastActive;
    _data['push_token'] = pushToken;
    _data['email'] = email;
    return _data;
  }
}


//website used to convert json to dart:https://www.webinovers.com/web-tools/json-to-dart-convertor