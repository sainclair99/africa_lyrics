class UserModel {
  final int? id;
  final String? username;
  final String ?email;

  UserModel({this.id, this.username, this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id_utitilisateur"],
      username: json['nom'],
      email: json['email'],
    );
  }
}
