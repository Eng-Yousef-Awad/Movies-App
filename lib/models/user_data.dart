class Userdata {
  String name;
  String email;
  String id;
  String phone;
  String avatar;
  List<int> watchLater;
  List<int> history;

  Userdata({
    required this.name,
    required this.email,
    this.id = "",
    required this.phone,
    this.avatar = "",
    required this.watchLater,
    required this.history,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) {
    return Userdata(
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      id: json['id'] ?? "",
      phone: json['phone'] ?? "",
      avatar: json['avatar'] ?? "",
      watchLater: List<int>.from(json['watchLater'] ?? []),
      history: List<int>.from(json['history'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'id': id,
      'phone': phone,
      'avatar': avatar,
      'watchLater': watchLater,
      'history': history,
    };
  }
}
